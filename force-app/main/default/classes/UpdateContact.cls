public class UpdateContact {
    public static void getContact(){
		List<Loan_Application__c> cont = [Select ID,Name,FirstName__c from Loan_Application__c];
        List<Loan_Application__c> contactList = new List<Loan_Application__c>();
        for(Loan_Application__c con :cont){
            for(Integer i=0;i<=300;i++){
                if(con.FirstName__c == 'Nisha'){
                    contactList.add(con);
                }
            }
        }
		System.debug('contactList ===>' + contactList);
        if(!contactList.isEmpty()){
            try{
            	Delete contactList;    
            }catch(DmlException e) {
    			System.debug('The following exception has occurred: ' + e.getMessage());
			}
        }
    }
}