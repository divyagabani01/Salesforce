public class AddPrimaryContact implements Queueable {
    private Contact contactToInsert;
    private String stateAbbreviation;

    // Constructor
    public AddPrimaryContact(Contact contact, String state) {
        this.contactToInsert = contact;
        this.stateAbbreviation = state;
    }

    // Execute method
    public void execute(QueueableContext context) {
        // Query for up to 200 Accounts with the specified BillingState
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :stateAbbreviation LIMIT 200];

        // List to hold Contacts to be inserted
        List<Contact> contactsToInsert = new List<Contact>();

        // Iterate over the Accounts and prepare the Contact records
        for (Account acct : accounts) {
            // Clone the contact and associate it with the current Account
            Contact newContact = contactToInsert.clone(false, false, false, false);
            newContact.AccountId = acct.Id;
            contactsToInsert.add(newContact);
        }

        // Insert the Contacts
        if (!contactsToInsert.isEmpty()) {
            try {
                insert contactsToInsert;
            } catch (DmlException e) {
                // Handle exception if needed
                System.debug('Error inserting contacts: ' + e.getMessage());
            }
        }
    }
}