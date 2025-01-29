@IsTest
public class AccountWiseContactTest {
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
    static void AccountWiseContact(){
        Test.startTest();
			// Query test Contacts
        List<Contact> contactList = [SELECT Id, Name, Account.Name FROM Contact];

        // Call the method
        Map<String, List<String>> contactMap = AccountWiseContactList.getAccountWiseConatctList(contactList);
		System.debug('contactMap ====> ' + contactMap);
		Test.stopTest();
    }
}