@isTest
public class UpdateColorNameWiseColorValueTest {
	
    
    @testSetup
    static void setupTestData() {
        // Creating test Staticvalue__c records
        Staticvalue__c staticValue1 = new Staticvalue__c(Color_Name__c = 'Red', Color_Value__c = 10);
        Staticvalue__c staticValue2 = new Staticvalue__c(Color_Name__c = 'Blue', Color_Value__c = 20);
        insert new List<Staticvalue__c>{staticValue1, staticValue2};

        // Creating test Account records
        Account account1 = new Account(Name = 'Test Account 1', Color_Name__c = 'Red');
        Account account2 = new Account(Name = 'Test Account 2', Color_Name__c = 'Blue');
		Account account3 = new Account(Name = 'Test Account 3', Color_Name__c = 'Blue');
        insert new List<Account>{account1, account2,account3};
    }

    @isTest
    static void testSetValueColorWise() {
        // Call the method to test
        Test.startTest();
        UpdateColorNameWiseColorValue.setValueColorWise();
        Test.stopTest();
        
        // Verify that the Account records have been updated with the correct Color_Value__c
        Account updatedAccount1 = [SELECT Color_Value__c FROM Account WHERE Name = 'Test Account 1'];
        Account updatedAccount2 = [SELECT Color_Value__c FROM Account WHERE Name = 'Test Account 2'];
        
        System.assertEquals(10, updatedAccount1.Color_Value__c);
        System.assertEquals(20, updatedAccount2.Color_Value__c);
        
        // Verify that the Staticvalue__c records have the correct Account_Id__c values
        Staticvalue__c updatedStaticValue1 = [SELECT Account_Id__c FROM Staticvalue__c WHERE Color_Name__c = 'Red'];
        Staticvalue__c updatedStaticValue2 = [SELECT Account_Id__c FROM Staticvalue__c WHERE Color_Name__c = 'Blue'];
        
        System.assertNotEquals(null, updatedStaticValue1.Account_Id__c);
        System.assertNotEquals(null, updatedStaticValue2.Account_Id__c);
    }
    
    @isTest
    static void testEmptyData() {
        // Delete all test data
        delete [SELECT Id FROM Staticvalue__c];
        delete [SELECT Id FROM Account];
        
        // Call the method to test
        Test.startTest();
        UpdateColorNameWiseColorValue.setValueColorWise();
        Test.stopTest();
        
        // Verify that no exceptions were thrown and no updates occurred
        System.assertEquals(0, [SELECT COUNT() FROM Account]);
        System.assertEquals(0, [SELECT COUNT() FROM Staticvalue__c]);
    }
    
    @isTest
    static void testExceptionHandling() {
        // Create invalid data to trigger an exception
        Account invalidAccount = new Account(Name = 'Invalid Account', Color_Name__c = null);
        insert invalidAccount;
        
        // Call the method to test
        Test.startTest();
        try {
            UpdateColorNameWiseColorValue.setValueColorWise();
            System.assert(false, 'Exception was not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Error Message'));
        }
        Test.stopTest();
    }
}