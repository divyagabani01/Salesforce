public class ContactEmailSender {
		public Static void sendContactCreationEmails(List<Contact> contacts){
        Map<Id,List<Contact>> accountcontactMap = new Map<Id,List<Contact>>();
		System.debug('contacts ======> ' + contacts);
        for(Contact con : contacts){
            if(!accountcontactMap.containsKey(con.AccountId)){
                accountcontactMap.put(con.AccountId,new List<Contact>{con});        
            }else{
                accountcontactMap.get(con.AccountId).add(con);
            }
        }
        
        List<Messaging.SingleEmailMessage> emaillist = new List<Messaging.SingleEmailMessage>();

        for(Account acc : [SELECT Name, Account_Email__c , Owner.Name FROM Account WHERE Id IN : accountcontactMap.KeySet()]){
            if (acc.Account_Email__c == null) {
                System.debug('Account does not have an email address.');
                return;
            }
            system.debug('acoount list' + acc);
            
            for(Contact con : accountcontactMap.get(acc.Id)){
                
                String isOrAre = accountcontactMap.get(acc.Id).Size() == 1 ? 'is' : 'are';
                
                System.debug(' accountcontactMap.get(acc.Id).Size() ==' +  accountcontactMap.get(acc.Id).Size());
                System.debug('isOrAre == ' + isOrAre);
                Date createdDate = con.CreatedDate.date();
                System.debug('Date only: ' + createdDate);
                
                System.debug('Date only ========> ' + createdDate.format());
                
                String emailBody = 'Hii ' + acc.Name + ' ,\n\n' +
                    con.LastName + ' is created on ' + acc.Name + ' by ' + acc.Owner.Name + ' at ' + createdDate.format()  + ' .\n' +
                    'Total  Contact  of your account ' + isOrAre + ' ' + accountcontactMap.get(acc.Id).Size() + ' .\n\n' +
                    'Thank you ,\n' + 'Salesforce Team .';
                System.debug('email Body -- ' +emailBody);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { acc.Account_Email__c });
                email.setSubject('New Contact Created'); 
                email.setPlainTextBody(emailBody);
                emaillist.add(email);
            }
            
        }
        Messaging.sendEmail(emaillist); 

    }
}