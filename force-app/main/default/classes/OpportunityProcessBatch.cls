public class OpportunityProcessBatch  implements Database.Batchable<sObject>,Database.Stateful {
	List<Opportunity> OppList = new List<Opportunity>();
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Country__c, StageName, Country_Short_Name__c, Is_Short_Country_Inserted__c FROM Opportunity WHERE Is_Short_Country_Inserted__c = false AND Country__c != null AND StageName = \'Closed Won\'';
        System.debug('query ====>' + query);
        return Database.getQueryLocator(query);
    }

	
    
    public void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        System.debug('scope ====>0' + scope);
        // Process each batch of records
		Map<String, String> countryShortNameMap = getCountryShortNameMap();
        System.debug('countryShortNameMap ====>' + countryShortNameMap);
        for(Opportunity opp : scope){
			opp.Is_Short_Country_Inserted__c = true;
            if(countryShortNameMap.containsKey(opp.Country__c)){
				opp.Country_Short_Name__c = countryShortNameMap.get(opp.Country__c);
            }else{
               opp.Country_Short_Name__c =   opp.Country__c.substring(0, 2).toUpperCase();
            }
            
			OppList.add(opp);
        }
		System.debug('contactList ====>' + OppList);
        // Optionally update or manipulate the records in the database
        update OppList;
    }

	public void finish(Database.BatchableContext BC) {
		List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();	
        List<String> EmailList = new List<String>{'divugabani2001@gmail.com'};
        for(String accEmailStr : EmailList){
          		messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
				email.setSubject('Notify for How many Opportunity Country short name was updated using your mail Id');
                
                String emailBoby ='In Salesforce, '+ OppList.Size()  + ' ' + 'Opportunity Country short name was updated using your mail Id';
                emailBoby += '<br/><b>Thank You<br/>';
                
                email.setHtmlBody(emailBoby);
                List<String> toAddress = new List<String>();
				toAddress.add(accEmailStr); // OwnerEmail
                email.setToAddresses(toAddress);
                
        		emailMessages.add(email);
        }	
		if(!emailMessages.isEmpty()){
            Messaging.sendEmail(emailMessages);
        } 
    }
    
 /*   public void execute(SchedulableContext context) {
        Database.executeBatch(new OpportunityProcessBatch());
    } */
    
    public static Map<String, String> getCountryShortNameMap() {
        Map<String, String> countryShortNameMap = new Map<String, String>();
        List<Country_Code__mdt> countryMetadataList = [
            SELECT MasterLabel, Country_Short_Name__c
            FROM Country_Code__mdt
        ];
        for (Country_Code__mdt countryMetadata : countryMetadataList) {
            countryShortNameMap.put(countryMetadata.MasterLabel, countryMetadata.Country_Short_Name__c);
        }
        return countryShortNameMap;
    }
}