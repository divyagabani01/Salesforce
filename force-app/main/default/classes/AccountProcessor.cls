public class AccountProcessor {
	@future
    public static void countContacts(Set<Id> accountId){
        Map<Id,Integer> CountContactAccount = new Map<Id,Integer>();
        for(Contact con : [Select Id,AccountId from Contact where AccountId IN :accountId]){
            if(!CountContactAccount.containsKey(con.AccountId)){
                CountContactAccount.put(con.AccountId,1);
            }else{
                CountContactAccount.put(con.AccountId, CountContactAccount.get(con.AccountId) + 1);
            }
        }
		List<Account> account = new List<Account>(); 
        for(Id accId : CountContactAccount.keySet()){
            Account acc = new Account();
            acc.Id = accId;
            acc.Number_Of_Contacts__c =  CountContactAccount.get(accId);
			account.add(acc);
        }
        if(!account.isEmpty()){
            update account;
        }
    }
}