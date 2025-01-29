public class InsertDynamicAccountsAndContact {
    public static void CreateDynaicAccount(String AccountName, String ContactName, String PhoneNumber){
        try{
            Account acc = new Account();
        	acc.Name = AccountName;
        	acc.Phone = PhoneNumber;
			System.debug('Before Inserted Account Record ======> ' + acc);
        	Insert acc;
        	System.debug('After Inserted Account Record ======> ' + acc);
        	createContact(ContactName,acc.Id);
        }catch(DmlException e) {
    		System.debug('The following exception has occurred: ' + e.getMessage());
		}
    }
	
    public static void createContact(String ContactNumber, String AccId){
        try{
            Contact con = new Contact();
        	con.LastName = ContactNumber;
        	con.AccountId = AccId;
        	Insert con;
        	System.debug('Inserted Contact Record ======> ' + con);
        }catch(DmlException e) {
    		System.debug('The following exception has occurred: ' + e.getMessage());
		}
    }
    
	@AuraEnabled
    public static List<Account> getContactAndOpportunityDetails(){
        List<Account> accList = [Select Id,Name,AccountNumber,Site,Rating,Phone,(Select Name,Phone,Birthdate,Email from Contacts),(Select Name,StageName,Country_Short_Name__c from Opportunities) from Account];
        if(!accList.isEmpty()){
            return accList;
        }
           return null;
    }
    
}