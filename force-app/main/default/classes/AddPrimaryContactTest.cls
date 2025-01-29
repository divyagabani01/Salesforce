@isTest
public class AddPrimaryContactTest {
    @testSetup
    static void setupTestData() {
        // Create test Accounts with different BillingStates
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 300; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            acc.BillingState = i < 2 ? 'CA' : 'NY';
            testAccounts.add(acc);
        }
        insert testAccounts;
    }

    @isTest
    static void testAddPrimaryContact() {
        // Create a test Contact
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );

        // Create the queueable job
        AddPrimaryContact job = new AddPrimaryContact(testContact, 'CA');

        // Enqueue the job
        Test.startTest();
        System.enqueueJob(job);
        Test.stopTest();

        // Verify that 200 Contacts have been inserted for Accounts in CA
        List<Contact> insertedContacts1 = [SELECT Id, AccountId FROM Contact WHERE Email = 'john.doe@example.com'];
        System.assertEquals(200, insertedContacts1.size(), '200 Contacts should have been inserted.');

        // Verify that each inserted Contact is associated with an Account in CA
        for (Contact c : insertedContacts1) {
            Account relatedAccount = [SELECT BillingState FROM Account WHERE Id = :c.AccountId];
            System.assertEquals('CA', relatedAccount.BillingState, 'Contact should be associated with an Account in CA.');
        }
    }

    @isTest
    static void testExceptionHandling() {
        // Create a test Contact with an invalid email to trigger DML exception
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'invalidemail' // Invalid email to trigger DML exception
        );

        // Create the queueable job
        AddPrimaryContact job = new AddPrimaryContact(testContact, 'CA');

        // Enqueue the job
        Test.startTest();
        System.enqueueJob(job);
        Test.stopTest();

        // Verify that no Contacts have been inserted due to the exception
        List<Contact> insertedContacts2 = [SELECT Id FROM Contact WHERE Email = 'invalidemail'];
        System.assertEquals(0, insertedContacts2.size(), 'No Contacts should have been inserted due to the exception.');

        // Optionally, you can check for specific debug logs if needed
        // Test that System.debug has been called with the expected error message
    }
}