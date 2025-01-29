public class DailyBasedSendMailToAccountOwnerBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
    Map<String,Integer> AccountMap = new Map<String,Integer>(); 
    Map<String,String> AccountVarifyOrNot = new Map<String,String>();
	public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name,Phone,Account_Email__c, Owner.Email, Owner.Phone FROM Account';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        // Process each batch of records
		List<Account> AccountList =  new List<Account>();
        for(Account acc : scope){
			System.debug('Email and Phone is Exist ====>' + acc.Account_Email__c + acc.Owner.Phone);
			 String emailRegex = '^[a-zA-Z0-9._|\\\\%⌗~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
            if(!AccountVarifyOrNot.containsKey(acc.Account_Email__c)){
                if(acc.Account_Email__c != null && Pattern.matches(emailRegex, acc.Account_Email__c) && acc.Phone != null && Pattern.matches('^[0-9]{10}$', acc.Phone)){
                    AccountVarifyOrNot.put(acc.Account_Email__c,'and your email has been verified');
                }else{
                    if(acc.Account_Email__c == null){
                     AccountVarifyOrNot.put(acc.Account_Email__c,'but your email has not been verified.');   
                    }else if(acc.Phone == null){
                        AccountVarifyOrNot.put(acc.Account_Email__c,'and your email has been verified but Not found your phone number.');   
                    }
                     
                }
            }else{
               
                if(acc.Account_Email__c != null && Pattern.matches(emailRegex, acc.Account_Email__c) && acc.Phone != null && Pattern.matches('^[0-9]{10}$', acc.Phone)){
                    AccountVarifyOrNot.put(acc.Account_Email__c,'and your email has been verified');
                }else{
                     if(acc.Account_Email__c == null){
                     AccountVarifyOrNot.put(acc.Account_Email__c,'but your email has not been verified.');   
                    }else if(acc.Phone == null){
                        AccountVarifyOrNot.put(acc.Account_Email__c,'and your email has been verified but Not found your phone number.');   
                    }
                }
            }
            if(!AccountMap.containsKey(acc.Owner.Email)){
                AccountMap.put(acc.Owner.Email,1);
            }else{
                AccountMap.put(acc.Owner.Email,AccountMap.get(acc.Owner.Email)+1);
            }
        }
    }

	public void finish(Database.BatchableContext BC) {
	  	List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();	
        for(String accEmailStr : AccountMap.keySet()){
          		messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
				email.setSubject('Notify for How many account was created using your mail Id');
                
                String emailBoby ='In Salesforce, '+ AccountMap.get(accEmailStr) + ' ' + 'Accounts were created using your email ID.';
                emailBoby += '<b>Thank You<br/>';
                
                email.setHtmlBody(emailBoby);
                List<String> toAddress = new List<String>();
				toAddress.add(accEmailStr); // OwnerEmail
                email.setToAddresses(toAddress);

                
                List<String> bccAddress = new List<String>();
                bccaddress.add('072.gabani.divya@gmail.com');
                email.setBccAddresses(bccAddress);
				// Add email to emailMessages list
        		emailMessages.add(email);
        }
		for(String accEmailStr : AccountVarifyOrNot.keySet()){
          		messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
				email.setSubject('Notify for Your Account is verified or not');
                
                String emailBoby ='In Salesforce, Accounts were created using your email ID, ' + AccountVarifyOrNot.get(accEmailStr);
                emailBoby += '<b>Thank You<br/>';
                
                email.setHtmlBody(emailBoby);
                List<String> toAddress = new List<String>();
				toAddress.add(accEmailStr); // OwnerEmail
                email.setToAddresses(toAddress);

				// Add email to emailMessages list
        		emailMessages.add(email);
        }
		System.debug('emailMessages ====>' + emailMessages);
		 if(!emailMessages.isEmpty()){
            Messaging.sendEmail(emailMessages);
        }
    }
	// Execute method for scheduling the batch job
    public void execute(SchedulableContext context) {
        Database.executeBatch(new DailyBasedSendMailToAccountOwnerBatch());
    }
}