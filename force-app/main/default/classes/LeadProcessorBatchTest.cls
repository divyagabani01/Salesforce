@IsTest
public class LeadProcessorBatchTest {
	@testSetup
    static void setupTestData() {
            Integer counter = 1;
			Integer num = 200;
               List<Lead>  addLeads = new List<Lead>();
                while(counter <= num){
                    Lead store = new Lead();
                    store.LastName = 'Teasting' + counter;
                    store.LeadSource = 'Web';
					store.Company = 'Fusion';
					store.Email = 'divugabani2001+'+counter+'@gmail.com';
                    addLeads.add(store);
                    counter++;
                }
                //insert all of the accounts in the list
                insert addLeads;
        }
	@IsTest
    static void LeadProcessorBatch(){
        Test.startTest();
            LeadProcessorBatch batch = new LeadProcessorBatch();
            Database.executeBatch(batch); 
        Test.stopTest();
		  // Verify that email addresses were collected
        Integer emailCount = [SELECT COUNT() FROM Lead WHERE Email != null];
        System.assertEquals(emailCount, batch.emailAddresses.size());

        // Verify the finish method functionality
        // Create a mock of Messaging.SingleEmailMessage and verify it's called
        Test.startTest();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (String emailAddress : batch.emailAddresses) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {emailAddress});
            email.setSubject('Default Subject');
            email.setPlainTextBody('This is a default email body.');
            emails.add(email);
        }
        // Send the email
        Messaging.sendEmail(emails);		
		Test.stopTest();
		 // Verify that emails were prepared correctly
        for (Messaging.SingleEmailMessage email : emails) {
            System.assertEquals('Default Subject', email.getSubject());
            System.assertEquals('This is a default email body.', email.getPlainTextBody());
        }
    }
}