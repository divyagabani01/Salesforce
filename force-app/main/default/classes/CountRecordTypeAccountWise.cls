public class CountRecordTypeAccountWise {
    public static void getRecordTypeWiseCount(List<Scenario__c> scc){
        	Map<Id, List<String>> RecordTypeWiseAccount = new Map<Id, List<String>>();
        Map<Id,Map<String,Integer>> CountAccountWiseRecordType = new Map<Id,Map<String,Integer>>();
		List<Account> UpdateAccountList = new List<Account>();
        //List<Scenario__c> scc = [SELECT Id, Account__r.Id, RecordType.Name FROM Scenario__c];
        for (Scenario__c sce : scc) {
            // Get the Account Id and RecordType Id
            Id accountId = sce.Account__r.Id;
            String recordTypeId = sce.RecordType.Name;
        
            // Check if the map already contains the RecordType Id as a key
            if (!RecordTypeWiseAccount.containsKey(sce.Account__r.Id)) {
                // If not, initialize the list for this RecordType Id
                RecordTypeWiseAccount.put(sce.Account__r.Id, new List<String>{sce.RecordType.Name});
            }else{
                  // Add the Account Id to the list for the specific RecordType Id
            		RecordTypeWiseAccount.get(sce.Account__r.Id).add(sce.RecordType.Name);
            }
        	
            
            if(!CountAccountWiseRecordType.containsKey(sce.Account__r.Id)){
                CountAccountWiseRecordType.put(sce.Account__r.Id,new Map<String,Integer>());
            }
            if(!CountAccountWiseRecordType.get(sce.Account__r.Id).containsKey(sce.RecordType.Name)){
                CountAccountWiseRecordType.get(sce.Account__r.Id).put(sce.RecordType.Name,0);
            }
			CountAccountWiseRecordType.get(sce.Account__r.Id).put(sce.RecordType.Name,CountAccountWiseRecordType.get(sce.Account__r.Id).get(sce.RecordType.Name) + 1 );
            
				
        }
        // Optionally, debug the final map
        System.debug('RecordTypeWiseAccount =======' + RecordTypeWiseAccount);
		System.debug('CountAccountWiseRecordType =======' + CountAccountWiseRecordType);
			
		List<Account> acc = [Select Id,Apex_count__c,Aura_count__c,Lwc_count__c,Object_count__c,Trigger_count__c From Account where Id =:CountAccountWiseRecordType.keySet()];
        for(Account ac : acc){
            ac.Apex_count__c = CountAccountWiseRecordType.get(ac.Id).get('Apex') != null ? CountAccountWiseRecordType.get(ac.Id).get('Apex') : 0;
			ac.Aura_count__c = CountAccountWiseRecordType.get(ac.Id).get('Aura') != null ? CountAccountWiseRecordType.get(ac.Id).get('Aura') : 0;
			ac.Lwc_count__c = CountAccountWiseRecordType.get(ac.Id).get('Lwc') != null ? CountAccountWiseRecordType.get(ac.Id).get('Lwc') : 0;
			ac.Object_count__c = CountAccountWiseRecordType.get(ac.Id).get('Object') != null ? CountAccountWiseRecordType.get(ac.Id).get('Object') : 0;
			ac.Trigger_count__c = CountAccountWiseRecordType.get(ac.Id).get('Trigger') != null ? CountAccountWiseRecordType.get(ac.Id).get('Trigger') : 0;
			UpdateAccountList.add(ac);
        }
        if(!UpdateAccountList.isEmpty()){
            update UpdateAccountList;
        }
        // Aggregate the count of each Scenario type for the accounts
       // List<AggregateResult> results = [SELECT RecordType.Name,COUNT(Id)  FROM Scenario__c  GROUP BY  RecordType.Name];
		//	System.debug('results ======> ' + results);
  // Fetch all RecordTypes for Scenario__c object
      /*  Map<Id, String> recordTypeMap = new Map<Id, String>();
        for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Scenario__c']) {
            recordTypeMap.put(rt.Id, rt.Name);
        }

        // Aggregate the count of each Scenario type for the accounts
        List<AggregateResult> results = [
            SELECT Account__c, COUNT(Id) , RecordTypeId
            FROM Scenario__c
            WHERE Account__c != null
            GROUP BY Account__c, RecordTypeId
        ];

        // Create a map to hold the counts
        Map<Id, Map<String, Integer>> accountScenarioCounts = new Map<Id, Map<String, Integer>>();
        for (AggregateResult result : results) {
            Id accountId = (Id) result.get('Account__c');
            Id recordTypeId = (Id) result.get('RecordTypeId');
            Integer count = ((Long) result.get('count')).intValue();
            String recordTypeName = recordTypeMap.get(recordTypeId);

            if (!accountScenarioCounts.containsKey(accountId)) {
                accountScenarioCounts.put(accountId, new Map<String, Integer>());
            }
            accountScenarioCounts.get(accountId).put(recordTypeName, count);
        }

        // List to hold the accounts to be updated
        List<Account> accountsToUpdate = new List<Account>();

        // Iterate through the accounts and update the counts
        for (Id accountId : accountScenarioCounts.keySet()) {
            Account accountToUpdate = new Account(Id = accountId);
            Map<String, Integer> scenarioCounts = accountScenarioCounts.get(accountId);

            accountToUpdate.Apex_Count__c = scenarioCounts.containsKey('Apex') ? scenarioCounts.get('Apex') : 0;
            accountToUpdate.Trigger_Count__c = scenarioCounts.containsKey('Trigger') ? scenarioCounts.get('Trigger') : 0;
            accountToUpdate.Object_Count__c = scenarioCounts.containsKey('Object') ? scenarioCounts.get('Object') : 0;
            accountToUpdate.Aura_Count__c = scenarioCounts.containsKey('Aura') ? scenarioCounts.get('Aura') : 0;
            accountToUpdate.Lwc_Count__c = scenarioCounts.containsKey('Lwc') ? scenarioCounts.get('Lwc') : 0;

            accountsToUpdate.add(accountToUpdate);
        }

        // Update the accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }*/

	
	}
}