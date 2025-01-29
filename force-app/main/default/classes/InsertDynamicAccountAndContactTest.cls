@IsTest
public class InsertDynamicAccountAndContactTest {
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
            for(Account acc : accounts){
                  for (Integer i = 0; i < 10; i++) {
                    contacts.add(new Contact(FirstName = 'Test', LastName = 'Contact ' + i, AccountId = acc.Id));
            		}
            }
          
            insert contacts;
        }
		@IsTest
        static void InsertDynamicAccountAndContact(){
            	
				Test.startTest();
            for(Integer i=0;i<3;i++){
                	InsertDynamicAccountsAndContact.CreateDynaicAccount('Account' + i,'Contact' + i, '123456987'+i);
            }
            	
				Test.stopTest();
        }
}