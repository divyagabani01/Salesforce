@IsTest
public class ContactTriggerHandlerTest {
	@testSetup
    static void setupTestData() { 
        List<Account> accounts = new List<Account>();
            for (Integer i = 0; i < 5; i++) {
                accounts.add(new Account(Name = 'Test Account ' + i));
            }
            insert accounts;
            
            // Create test Contacts related to Accounts
            List<Contact> contacts = new List<Contact>();            
			for(Account acc : accounts){
                  for (Integer i = 0; i < 10; i++) {
                    	contacts.add(new Contact(FirstName = 'Test', LastName = 'Contact ' + i, AccountId = acc.Id));
            		}
            }
          
            insert contacts;	
    }
	@IsTest
    static void ContactTriggerHandler(){
        // Retrieve test accounts
        List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test Account%'];
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        	Test.startTest();
                    // Call the method
                    ContactTriggerHandler.updateAccountContactCounts(accountIds);
            Test.stopTest();
    }
}