public class UpdateAccountScenarioRecordType {
    public static void getAcoountWiseScenarioRecordTypecount(){
			 // Initialize the map to store Account IDs with another map for RecordType counts
            Map<Id, Map<String, Integer>> AccountWiseScenarioCountMap = new Map<Id, Map<String, Integer>>();

            // Query all scenarios and their related account IDs and record type names
            List<Scenario__c> scenarioList = [SELECT Id, Account__c, RecordType.Name FROM Scenario__c];
            
            // Loop through the scenario records
            for (Scenario__c sce : scenarioList) {
                // Check if the account ID already exists in the map
                if (!AccountWiseScenarioCountMap.containsKey(sce.Account__c)) {
                    // Initialize the inner map for record type counts
                    AccountWiseScenarioCountMap.put(sce.Account__c, new Map<String, Integer>());
                }
            
               // Get the inner map for the current account
                Map<String, Integer> recordTypeCountMap = AccountWiseScenarioCountMap.get(sce.Account__c);
            
                // Check if the record type already exists in the inner map
                if (!recordTypeCountMap.containsKey(sce.RecordType.Name)) {
                    // Initialize the count for this record type
                    recordTypeCountMap.put(sce.RecordType.Name, 1);
                } else {
                    // Increment the count for this record type
                    recordTypeCountMap.put(sce.RecordType.Name, recordTypeCountMap.get(sce.RecordType.Name) + 1);
                }
            }
            System.debug('AccountWiseScenarioCountMap =====> ' + AccountWiseScenarioCountMap);
            // Prepare a set of account IDs to query
            Set<Id> accountIds = AccountWiseScenarioCountMap.keySet();
            
            // Query all relevant accounts
            List<Account> accountList = [SELECT Id, Object_Count__c, Apex_Count__c, Aura_count__c, Lwc_count__c, Trigger_count__c FROM Account WHERE Id IN :accountIds];
            
            // Prepare a list of accounts to update
            List<Account> accountsToUpdate = new List<Account>();
            
            // Loop through the account records
            for (Account acc : accountList) {
                // Get the record type count map for the current account
                Map<String, Integer> recordTypeCountMap = AccountWiseScenarioCountMap.get(acc.Id);
            
                // Update the fields based on the record type counts
                acc.Object_Count__c = recordTypeCountMap.containsKey('Object') ? recordTypeCountMap.get('Object') : 0;
                acc.Apex_Count__c = recordTypeCountMap.containsKey('Apex') ? recordTypeCountMap.get('Apex') : 0;
                acc.Aura_count__c = recordTypeCountMap.containsKey('Aura') ? recordTypeCountMap.get('Aura') : 0;
                acc.Lwc_count__c = recordTypeCountMap.containsKey('Lwc') ? recordTypeCountMap.get('Lwc') : 0;
                acc.Trigger_count__c= recordTypeCountMap.containsKey('Trigger') ? recordTypeCountMap.get('Trigger') : 0;
            
                // Add the account to the list for update
                accountsToUpdate.add(acc);
            }
            
            // Update the accounts
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }

      /*  Map<String,List<String>> AccountWiseScenarioMap = new Map<String,List<String>>();
		Map<String, List<String>> RecordTypeWiseAccountMap = new Map<String, List<String>>();
		List<Scenario__c> scenarioList = [SELECT Id,Account__r.Name,RecordType.Name From Scenario__c];
        
        for(Scenario__c sce : scenarioList){
            if(!AccountWiseScenarioMap.containsKey(sce.Account__r.Name)){
                AccountWiseScenarioMap.put(sce.Account__r.Name,new List<String>{sce.RecordType.Name});
            }else{
                AccountWiseScenarioMap.get(sce.Account__r.Name).add(sce.RecordType.Name);
            }
        }
		System.debug('AccountWiseScenarioMap =====> ' + AccountWiseScenarioMap);

        for(Account acc : [SELECT Id,Name from Account]){
             // Get the inner map for the current account
            if(AccountWiseScenarioMap.containsKey(acc.Name)){
					
                System.debug('AccountWiseScenarioMap =======> ' + AccountWiseScenarioMap.values());

            }
       }*/
// Initialize the map to store Account IDs with another map for RecordType counts
/*Map<Id, Map<String, Integer>> AccountWiseScenarioCountMap = new Map<Id, Map<String, Integer>>();

// Query all scenarios and their related account names and record type names
List<Scenario__c> scenarioList = [SELECT Id, Account__c, RecordType.Name FROM Scenario__c];

// Loop through the scenario records
for (Scenario__c sce : scenarioList) {
    // Check if the account ID already exists in the map
    if (!AccountWiseScenarioCountMap.containsKey(sce.Account__c)) {
        // Initialize the inner map for record type counts
        AccountWiseScenarioCountMap.put(sce.Account__c, new Map<String, Integer>());
    }

    // Get the inner map for the current account
    Map<String, Integer> recordTypeCountMap = AccountWiseScenarioCountMap.get(sce.Account__c);

    // Check if the record type already exists in the inner map
    if (!recordTypeCountMap.containsKey(sce.RecordType.Name)) {
        // Initialize the count for this record type
        recordTypeCountMap.put(sce.RecordType.Name, 1);
    } else {
        // Increment the count for this record type
        recordTypeCountMap.put(sce.RecordType.Name, recordTypeCountMap.get(sce.RecordType.Name) + 1);
    }
}

// Prepare a list of accounts to update
List<Account> accountsToUpdate = new List<Account>();

// Loop through the map to update account fields
for (Id accountId : AccountWiseScenarioCountMap.keySet()) {
    // Query the account by Id
    Account acc = [SELECT Id, Object_Count__c, Apex_Count__c FROM Account WHERE Id = :accountId LIMIT 1];

    // Get the record type count map for the current account
    Map<String, Integer> recordTypeCountMap = AccountWiseScenarioCountMap.get(accountId);

    // Update the fields based on the record type counts
    acc.Object_Count__c = recordTypeCountMap.containsKey('Object') ? recordTypeCountMap.get('Object') : 0;
    acc.Apex_Count__c = recordTypeCountMap.containsKey('Apex') ? recordTypeCountMap.get('Apex') : 0;

    // Add the account to the list for update
    accountsToUpdate.add(acc);
}

// Update the accounts
if (!accountsToUpdate.isEmpty()) {
    update accountsToUpdate;
}

// Debug the map
System.debug('AccountWiseScenarioCountMap =====> ' + accountsToUpdate);
*/
                   
        // Debug the map
    }
}