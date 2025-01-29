public class AccountMeargeDuplicatRecord {
        public static Map<String, List<Account>> duplicateAllAccounts(List<Account> accountsList) {
               Map<String, List<Account>> nameToAccountsMap = new Map<String, List<Account>>();
 		
            // Assuming you have a list of accounts called 'accountsList'
            for (Account acc : accountsList) {
                // Check if the map already contains a list for this name
                if (!nameToAccountsMap.containsKey(acc.Name)) {
                    // If not, create a new list and put it in the map
                    nameToAccountsMap.put(acc.Name, new List<Account>());
                }
                // Add the account to the list associated with this name
                nameToAccountsMap.get(acc.Name).add(acc);
            }
            System.debug('nameToAccountsMap ========>' + nameToAccountsMap);
            // Now you can access accounts with the same name from the map
			return nameToAccountsMap;
        }

}