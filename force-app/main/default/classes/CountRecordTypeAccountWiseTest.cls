@isTest
public class CountRecordTypeAccountWiseTest {

    @testSetup
    static void setupTestData() {
        // Query existing record types for Scenario__c
        Map<String, Id> recordTypeMap = new Map<String, Id>();
        for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Scenario__c' AND DeveloperName IN ('Apex', 'Trigger', 'Aura', 'Lwc', 'Object')]) {
            recordTypeMap.put(rt.DeveloperName, rt.Id);
        }

        // Ensure the required record types are available
        System.assert(recordTypeMap.containsKey('Apex'), 'Apex record type must be available');
        System.assert(recordTypeMap.containsKey('Trigger'), 'Trigger record type must be available');
        System.assert(recordTypeMap.containsKey('Aura'), 'Aura record type must be available');
        System.assert(recordTypeMap.containsKey('Lwc'), 'Lwc record type must be available');
        System.assert(recordTypeMap.containsKey('Object'), 'Object record type must be available');

        // Create test accounts
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{ acc1, acc2 };

        // Create test scenarios
        List<Scenario__c> scenarios = new List<Scenario__c>{
            new Scenario__c(Account__c = acc1.Id, RecordTypeId = recordTypeMap.get('Apex')),
            new Scenario__c(Account__c = acc1.Id, RecordTypeId = recordTypeMap.get('Apex')),
            new Scenario__c(Account__c = acc1.Id, RecordTypeId = recordTypeMap.get('Trigger')),
            new Scenario__c(Account__c = acc2.Id, RecordTypeId = recordTypeMap.get('Lwc')),
            new Scenario__c(Account__c = acc2.Id, RecordTypeId = recordTypeMap.get('Aura')),
            new Scenario__c(Account__c = acc2.Id, RecordTypeId = recordTypeMap.get('Aura'))
        };
        insert scenarios;
    }

    @isTest
    static void testGetRecordTypeWiseCount() {
        // Retrieve test scenarios
        List<Scenario__c> scenarios = [SELECT Id, Account__r.Id, RecordType.Name FROM Scenario__c];

        // Call the method
        CountRecordTypeAccountWise.getRecordTypeWiseCount(scenarios);

        // Verify the counts on the accounts
        Account updatedAcc1 = [SELECT Apex_Count__c, Trigger_Count__c, Aura_Count__c, Lwc_Count__c, Object_Count__c FROM Account WHERE Name = 'Test Account 1'];
        Account updatedAcc2 = [SELECT Apex_Count__c, Trigger_Count__c, Aura_Count__c, Lwc_Count__c, Object_Count__c FROM Account WHERE Name = 'Test Account 2'];

        System.assertEquals(2, updatedAcc1.Apex_Count__c, 'Account 1 should have 2 Apex scenarios');
        System.assertEquals(1, updatedAcc1.Trigger_Count__c, 'Account 1 should have 1 Trigger scenario');
        System.assertEquals(0, updatedAcc1.Aura_Count__c, 'Account 1 should have 0 Aura scenarios');
        System.assertEquals(0, updatedAcc1.Lwc_Count__c, 'Account 1 should have 0 Lwc scenarios');
        System.assertEquals(0, updatedAcc1.Object_Count__c, 'Account 1 should have 0 Object scenarios');

        System.assertEquals(0, updatedAcc2.Apex_Count__c, 'Account 2 should have 0 Apex scenarios');
        System.assertEquals(0, updatedAcc2.Trigger_Count__c, 'Account 2 should have 0 Trigger scenarios');
        System.assertEquals(2, updatedAcc2.Aura_Count__c, 'Account 2 should have 2 Aura scenarios');
        System.assertEquals(1, updatedAcc2.Lwc_Count__c, 'Account 2 should have 1 Lwc scenario');
        System.assertEquals(0, updatedAcc2.Object_Count__c, 'Account 2 should have 0 Object scenarios');
    }
}