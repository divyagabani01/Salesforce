@IsTest
public class AccountTriggerHelperTest {
	@testSetup
        static void setupTestData() {
              // Create test Accounts
            List<Account> accounts = new List<Account>();
            for (Integer i = 0; i < 5; i++) {
                accounts.add(new Account(Name = 'Test Account ' + i));
            }
            insert accounts;
            
            // Create test Contacts related to Accounts
            List<Contact> contacts = new List<Contact>();
			List<Opportunity> opportunities = new List<Opportunity>();
                  	for (Integer i = 0; i < 10; i++) {
                            contacts.add(new Contact(FirstName = 'Test', LastName = 'Contact ' + i, AccountId = i < 5 ? accounts[i].Id :accounts[0].Id));
                            opportunities.add(new Opportunity(Name = 'Test Opportunity ' + i, Amount = 1000 * (i + 1), StageName = 'Prospecting', CloseDate = System.today(), AccountId = i < 5 ? accounts[i].Id :accounts[0].Id));
            		}
          
            insert contacts;
            
            insert opportunities;
        }
		@IsTest
    static void AccountTriggerHelper(){
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : [SELECT Id FROM Account]) {
            accountIds.add(acc.Id);
        }
        Test.startTest();
            // Call the method with 'Contact' type
            AccountTriggerHelper.updateAccountCounts(accountIds, 'Contact');
            AccountTriggerHelper.updateAccountCounts(accountIds, 'Opportunity');
		Test.stopTest();
    }
}