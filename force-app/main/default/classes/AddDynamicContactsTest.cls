@IsTest
public class AddDynamicContactsTest {
	/*	@testSetup
        static void setupTestData() { 
				 // Create a test Account record
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.Phone = '555-1234';
        testAccount.BillingStreet = '456 Test St.';
        testAccount.BillingCity = 'Testville';
        testAccount.BillingState = 'CA';
        testAccount.BillingPostalCode = '90000';
        testAccount.Number_of_Contact_Field__c = 10; // Replace with your custom field API name
        insert testAccount;
        
        // Create test Contacts related to the test Account
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 1; i <= 5; i++) {
            Contact testContact = new Contact();
            testContact.LastName = 'Contact ' + i;
            testContact.AccountId = testAccount.Id;
            testContacts.add(testContact);
        }
        insert testContacts;
        }


		@IsTest
    static void AddDynamicContacts(){
        	Test.startTest();
        		String data = '{"Name":"Acme Inc.","Phone":"123-456-7890","BillingStreet":"123 Elm St.","BillingCity":"Metropolis","BillingState":"CA","BillingPostalCode":"90210","NumberOfContact":5}';
        		AddDynamicContacts.InsertAccountRecord(data);
        		String InvalidAccountName = null;
				AddDynamicContacts.InsertAccountRecord(InvalidAccountName);
			Test.stopTest();
    }*/
}