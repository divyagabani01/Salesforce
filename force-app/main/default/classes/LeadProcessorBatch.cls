public class LeadProcessorBatch implements Database.Batchable<sObject> {
	public List<String> emailAddresses =  new List<String>();
	public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query to select the records you want to process
        String query = 'SELECT Id, Name,Email,LeadSource FROM Lead';
        return Database.getQueryLocator(query);
    }	
	
	public void execute(Database.BatchableContext BC, List<Lead> scope) {
        // Process each batch of records
        for (Lead lead : scope) {
				lead.LeadSource = 'Dreamforce';
            if(lead.Email !=  null){
                emailAddresses.add(lead.Email);
            }
            	
        }	
        // Optionally update or manipulate the records in the database
        update scope;
    }
	public void finish(Database.BatchableContext BC) {
        for (String emailAddress : emailAddresses) {
            // Create a new Email instance
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            // Set the recipient
            email.setToAddresses(new String[] {emailAddress});
            
            // Set the subject
            email.setSubject('Default Subject');
            
            // Set the email body
            email.setPlainTextBody('This is a default email body.');
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
}