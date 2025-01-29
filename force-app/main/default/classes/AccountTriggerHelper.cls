public class AccountTriggerHelper {
	public static void updateAccountCounts(Set<Id> accountIds,String type) {
        if (accountIds.isEmpty()) return;
		Map<Id, Integer> contactCounts = new Map<Id, Integer>();
		Map<Id, Integer> opportunityCounts = new Map<Id, Integer>();
        List<Account> accountsToUpdate = new List<Account>();
            if(type == 'Contact'){
                  // Query to get contact counts
           
                for (AggregateResult ar : [
                    SELECT AccountId, COUNT(Id) contactCount
                    FROM Contact
                    WHERE AccountId IN :accountIds
                    GROUP BY AccountId
                ]) {
                    contactCounts.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
                }
			for (Id accountId : accountIds) {
                    Account acc = new Account(Id = accountId);
                    acc.Contact_Count__c = contactCounts.containsKey(accountId) ? contactCounts.get(accountId) : 0;
                    accountsToUpdate.add(acc);
                }
            }else{
		   System.debug('type ====>' + type);
                // Query to get opportunity counts
                   
                    for (AggregateResult ar : [
                        SELECT AccountId, COUNT(Id) opportunityCount
                        FROM Opportunity
                        WHERE AccountId IN :accountIds
                        GROUP BY AccountId
                    ]) {
                        opportunityCounts.put((Id)ar.get('AccountId'), (Integer)ar.get('opportunityCount'));
                    }

		 // Perform the aggregate query to get the total amounts
        List<AggregateResult> results = [SELECT AccountId, SUM(Amount) totalAmount 
                                         FROM Opportunity 
                                         WHERE AccountId IN :accountIds 
                                         GROUP BY AccountId];
            
                     for (AggregateResult ar : results) {
                        Id accountId = (Id) ar.get('AccountId');
                        Decimal totalAmount = (Decimal) ar.get('totalAmount');
            
                        // Create a new Account record with the Id and the calculated values
                        Account acc = new Account(Id = accountId);
                        acc.Total_Opportunies__c = opportunityCounts.containsKey(accountId) ? opportunityCounts.get(accountId) : 0;
                        acc.Total_Amount__c = totalAmount;
                        accountsToUpdate.add(acc);
                    }

       		 System.debug('accountsToUpdate====' + accountsToUpdate);
       
       
  			  }
             // Update accounts
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
    }
}