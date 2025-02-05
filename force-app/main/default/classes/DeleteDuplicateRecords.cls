/*public class DeleteDuplicateRecords {

		public static void removeDuplicates() {
                // Query all accounts
                List<Account> allAccounts = [SELECT Id, Name FROM Account];
        
                // Create a map to store unique account names
                Map<String, Account> uniqueNamesMap = new Map<String, Account>();
        
                // Iterate through all accounts
                for (Account acc : allAccounts) {
                    // Check if the account name already exists in the map
                    if (!uniqueNamesMap.containsKey(acc.Name)) {
                        // If not, add it to the map
                        uniqueNamesMap.put(acc.Name, acc);
                    }
                }
        
                // Retrieve the unique accounts from the map
                List<Account> uniqueAccounts = new List<Account>(uniqueNamesMap.values());
        
                // Delete duplicate accounts
                List<Account> duplicateAccounts = new List<Account>();
                for (Account acc : allAccounts) {
                    if (!uniqueAccounts.contains(acc)) {
                        duplicateAccounts.add(acc);
                    }
                }
        
                // Delete duplicate accounts
                if (!duplicateAccounts.isEmpty()) {
                    delete duplicateAccounts;
                }
   		 }

	
/* public static void checkAndDeleteDuplicateNames() {
        // Query all Account records
        List<Account> allAccounts = [SELECT Id, Name FROM Account];
        
        // Iterate over the records and check for duplicates
        for (Integer i = 0; i < allAccounts.size(); i++) {
            Account currentAccount = allAccounts[i];
            String currentName = currentAccount.Name;
            
            // Check if there are any other records with the same name after the current one
            for (Integer j = i + 1; j < allAccounts.size(); j++) {
                Account nextAccount = allAccounts[j];
                if (nextAccount.Name == currentName) {
                    // If a duplicate is found, delete it
					System.debug('nextAccount ====> ' + nextAccount);
                    delete nextAccount;
                }
            }
        }
    } */
  /*public static void checkAndDeleteDuplicateNames() {
    // Query all Account records
    List<Account> allAccounts = [SELECT Id, Name FROM Account];
    
    // Set to store encountered names
    Set<String> encounteredNames = new Set<String>();
    
    // List to store duplicate account records
    List<Account> duplicatesToDelete = new List<Account>();
    
    // Iterate over the records and check for duplicates
    for (Account acc : allAccounts) {
        String currentName = acc.Name;
        // Check if the current name has been encountered before	
        if (encounteredNames.contains(currentName)) {
            // If a duplicate is found, add it to the list for deletion
            duplicatesToDelete.add(acc);
        } else {
            // Add the current name to the set
            encounteredNames.add(currentName);
        }
    }
    
    // Delete duplicate accounts outside of the loop
    if (!duplicatesToDelete.isEmpty()) {
        delete duplicatesToDelete;
    }
}
} */
public class DeleteDuplicateRecords {

        public static void handleDuplicateAccountNames() {
        // Query to get all account records
       /* List<Account> allAccounts = [SELECT Id, Name FROM Account];

        // Map to track accounts by name
        Map<String, List<Account>> accountMap = new Map<String, List<Account>>();

        // Iterate through all accounts and populate the map
        for (Account acc : allAccounts) {
            String key = acc.Name;
            if (!accountMap.containsKey(key)) {
                accountMap.put(key, new List<Account>());
            }
            accountMap.get(key).add(acc);
        }

        List<Account> accountsToUpdate = new List<Account>();

        // Iterate through the map to find and update duplicate accounts
        for (String key : accountMap.keySet()) {
            List<Account> accounts = accountMap.get(key);
            if (accounts.size() > 1) {
                for (Integer i = 1; i < accounts.size(); i++) {
                    Account duplicateAccount = accounts[i];
                    duplicateAccount.Name = duplicateAccount.Name + ' (copy)';
                    accountsToUpdate.add(duplicateAccount);
                }
            }
        }

        // Update the duplicate accounts with the new name
       
 		if (accountsToUpdate.size() > 0) {
            try {
                //update accountsToUpdate;
				delete accountsToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating accounts: ' + e.getMessage());
            }
        }*/
	/*
     // Query to get all account records
        List<Account> allAccounts = [SELECT Id, Name, (SELECT Id FROM Energy_Audits__r) FROM Account];

        // Lists to track duplicate accounts and associated energy audits to delete
        List<Account> accountsToDelete = new List<Account>();
        List<Energy_Audit__c> energyAuditsToDelete = new List<Energy_Audit__c>();

        // Iterate through all accounts and identify duplicate accounts
        for (Account acc : allAccounts) {
            // Check if the account has energy audits
            if (!acc.Energy_Audits__r.isEmpty()) {
                // If energy audits exist, add them to the energyAuditsToDelete list
                energyAuditsToDelete.addAll(acc.Energy_Audits__r);
            } else {
                // If no energy audits exist, mark the account for deletion
                accountsToDelete.add(acc);
            }
        }

        // Delete the energy audits associated with the accounts
        if (!energyAuditsToDelete.isEmpty()) {
            try {
                delete energyAuditsToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting energy audits: ' + e.getMessage());
            }
        }

        // Delete the duplicate accounts
        if (!accountsToDelete.isEmpty()) {
            try {
                delete accountsToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting accounts: ' + e.getMessage());
            }
        }*/
    }
    
    //Remove the duplicate records when duplicate records didn't standard records 
    public static void removeDuplicatesRecords(){
        Map<String,Account> uniqueRecordsMap = new Map<String,Account>();
        Map<String,List<Account>> duplicateRecordsMap = new Map<String,List<Account>>();
        List<Account> deleteRecordsList = new List<Account>();
        List<Opportunity> opportunitiesToDeleteList = new List<Opportunity>();
        List<Energy_Audit__c> energyAuditsToDeleteList = new List<Energy_Audit__c>();
        for(Account acc: [Select Id,Name, (SELECT Id FROM Opportunities), (SELECT Id FROM Energy_Audits__r)  from Account]){
            if(!uniqueRecordsMap.containsKey(acc.name)){
                uniqueRecordsMap.put(acc.name,acc);
            }else{
                if(!duplicateRecordsMap.containsKey(acc.name)){
                    duplicateRecordsMap.put(acc.name,new List<Account>{acc});
                }else{
                    duplicateRecordsMap.get(acc.name).add(acc);
                }
				 // Delete associated opportunities and energy audits
                  opportunitiesToDeleteList.addAll(acc.Opportunities);
                  energyAuditsToDeleteList.addAll(acc.Energy_Audits__r);
            }
        }
		System.debug('opportunitiesToDeleteList ======>' + opportunitiesToDeleteList);
		// Delete related opportunities
        if (!opportunitiesToDeleteList.isEmpty()) {
            try {
                delete opportunitiesToDeleteList;
            } catch (DmlException e) {
                System.debug('Error deleting opportunities: ' + e.getMessage());
            }
        }

        // Delete related energy audits
        if (!energyAuditsToDeleteList.isEmpty()) {
            try {
                delete energyAuditsToDeleteList;
            } catch (DmlException e) {
                System.debug('Error deleting energy audits: ' + e.getMessage());
            }
        }

        for(List<Account> acct : duplicateRecordsMap.values()){
            for(Account acc: acct){
                deleteRecordsList.add(acc);
            }
        }
        try{
        	delete deleteRecordsList;    
        }catch(Exception e){
            System.debug('Error Message =====> ' + e.getMessage());
        }
        
    }

    public static void removeDuplicates() {
     // Query accounts containing "(Copy)" in their name
        List<Account> accountsToDelete = [SELECT Id FROM Account WHERE Name LIKE '%(Copy) (Copy)%'];

        // Delete accounts containing "(Copy)" in their name
        if (!accountsToDelete.isEmpty()) {
            delete accountsToDelete;
        }
    }

	public static void removeDuplicateAndCopyAccountRecords() {
        // Query to get all account records with related opportunities and energy audits
        List<Account> allAccounts = [SELECT Id, Name, (SELECT Id FROM Opportunities), (SELECT Id FROM Energy_Audits__r) FROM Account WHERE Name LIKE '%(Copy)%'];

        // Lists to track duplicate accounts and related opportunities and energy audits to delete
        List<Account> accountsToDelete = new List<Account>();
        List<Opportunity> opportunitiesToDelete = new List<Opportunity>();
        List<Energy_Audit__c> energyAuditsToDelete = new List<Energy_Audit__c>();

        // Iterate through the accounts to identify and delete duplicate accounts and related opportunities and energy audits
        for (Account acc : allAccounts) {
            // Delete associated opportunities and energy audits
            opportunitiesToDelete.addAll(acc.Opportunities);
            energyAuditsToDelete.addAll(acc.Energy_Audits__r);

            // Mark the account for deletion
            accountsToDelete.add(acc);
        }

        // Delete related opportunities
        if (!opportunitiesToDelete.isEmpty()) {
            try {
                delete opportunitiesToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting opportunities: ' + e.getMessage());
            }
        }

        // Delete related energy audits
        if (!energyAuditsToDelete.isEmpty()) {
            try {
                delete energyAuditsToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting energy audits: ' + e.getMessage());
            }
        }

        // Delete the duplicate accounts
        if (!accountsToDelete.isEmpty()) {
            try {
                delete accountsToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting accounts: ' + e.getMessage());
            }
        }

        // Query and delete all account records whose names include '(copy)'
        List<Account> accountsCopyToDelete = [SELECT Id FROM Account WHERE Name LIKE '%(Copy)%'];
        if (!accountsCopyToDelete.isEmpty()) {
            try {
                delete accountsCopyToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting accounts with (Copy) in name: ' + e.getMessage());
            }
        }
    }

}