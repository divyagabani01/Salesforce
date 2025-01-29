public class ContactTriggerHandler {
	 public static void updateAccountContactCounts(Set<Id> accountIds) {
        if (accountIds.isEmpty()) return;

        // Query to get counts
        List<Account> accountsToUpdate = new List<Account>();
        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
		System.debug('ar =======>' +  ar);
            accountsToUpdate.add(new Account(
                Id = (Id)ar.get('AccountId'),
                Contact_Count__c = (Integer)ar.get('contactCount')
            ));
        }

        // Update accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}