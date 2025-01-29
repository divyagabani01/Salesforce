public class OpportunityTriggerHandler {
	 public static void updateAccountOpportunityCounts(Set<Id> accountIds) {
        if (accountIds.isEmpty()) return;

        // Query to get counts
        List<Account> accountsToUpdate = new List<Account>();
        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) opportunityCount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            accountsToUpdate.add(new Account(
                Id = (Id)ar.get('AccountId'),
                Total_Opportunies__c = (Integer)ar.get('opportunityCount')
            ));
        }

        // Update accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}