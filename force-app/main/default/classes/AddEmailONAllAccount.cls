public class AddEmailONAllAccount {
    public static void getAllAccountAndAddEmail(){
        List<Account> accountList = [SELECT Id, Name,Phone,Account_Email__c, Owner.Email, Owner.Phone FROM Account Where Account_Email__c = null];
	List<Property__c> newPropList = [SELECT Name,Street_Address__c,Price__c,Broker__r.Name FROM Property__c];
        System.debug('newPropList ====> ' +newPropList);
      /*  List<Account> addAccount = new List<Account>();
        System.debug('accountList.size() =====>'+  accountList.size());
        for(Integer i = 1;i <= accountList.size(); i++){
            Account acc = new Account();
            	acc.Account_Email__c = 'divugabani2001+'+i+'@gmail.com';
            if(i > 50 && i<100){
                acc.Phone = '987'+i+'54612'+i;
				
            }else if(i >= 100){
                 acc.Phone = '987'+i+'5461'+i;
            }
            
			acc.Id = accountList[i-1].Id;
            addAccount.add(acc);
        }
        if(!addAccount.isEmpty()){
            update addAccount;
        }*/
    }
}