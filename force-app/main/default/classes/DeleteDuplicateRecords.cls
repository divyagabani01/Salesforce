public class DeleteDuplicateRecords {
    public static void removeDuplicateRecords() {
        // Map to track unique accounts by name
        Map<String, Account> uniqueAccounts = new Map<String, Account>();
        
        // Lists to track records to delete
        List<Account> accountsToDelete = new List<Account>();
        List<Opportunity> opportunitiesToDelete = new List<Opportunity>();

        // Query all accounts with their related opportunities
        List<Account> allAccounts = [SELECT Id, Name, (SELECT Id FROM Opportunities) FROM Account];

        // Process accounts to identify duplicates
        for (Account acc : allAccounts) {
            if (!uniqueAccounts.containsKey(acc.Name)) {
                uniqueAccounts.put(acc.Name, acc);
            } else {
                // Collect the duplicate account for deletion
                accountsToDelete.add(acc);

                // Add related opportunities to delete list
                opportunitiesToDelete.addAll(acc.Opportunities);
            }
        }

        // Delete related opportunities
        if (!opportunitiesToDelete.isEmpty()) {
            try {
                delete opportunitiesToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting opportunities: ' + e.getMessage());
            }
        }

        // Delete duplicate accounts
        if (!accountsToDelete.isEmpty()) {
            try {
                delete accountsToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting duplicate accounts: ' + e.getMessage());
            }
        }

        // Additional cleanup: Remove accounts with "(Copy)" in their name
        List<Account> accountsWithCopy = [SELECT Id FROM Account WHERE Name LIKE '%(Copy)%'];
        if (!accountsWithCopy.isEmpty()) {
            try {
                delete accountsWithCopy;
            } catch (DmlException e) {
                System.debug('Error deleting accounts with "(Copy)" in their name: ' + e.getMessage());
            }
        }
    }
}