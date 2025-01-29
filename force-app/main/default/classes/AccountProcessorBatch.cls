public class AccountProcessorBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Account.Active__c FROM Contact WHERE Account.Active__c = \'No\' OR Account.Active__c IS NULL';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> scope) {
        // Process each batch of records
		List<Contact> contactList =  new List<Contact>();
        for(Contact con : scope){
            con.Description = 'Belongs to inactive account';
			contactList.add(con);
        }
		System.debug('contactList ====>' + contactList);
        // Optionally update or manipulate the records in the database
        update contactList;
    }

	public void finish(Database.BatchableContext BC) {
     
    }
}