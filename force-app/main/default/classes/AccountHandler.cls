public class AccountHandler {
	    public static void insertAccount(Integer num){
       Integer counter = 1;
       List<Account>  addAccounts = new List<Account>();
        while(counter <= num){
			Account store = new Account();
			store.Name = 'Acme Incs' + counter;
            store.AccountNumber = 'A000'+counter;
			addAccounts.add(store);
            counter++;
        }
 		System.debug('Size of Account List: ' + addAccounts.size() );
        System.debug('Elements in Account List: ' + addAccounts);
        //insert all of the accounts in the list
        insert addAccounts;
    }
   /* public static Account insertNewAccount(Map<String, Object> fieldValues){
        try{

			// Define the map with field names and values
          /*  Map<String, Object> fieldValues = new Map<String, Object>();
            fieldValues.put('Name', 'SFDC Computing');
            fieldValues.put('Phone', '(415)555-1212');
            fieldValues.put('NumberOfEmployees', 50);
            fieldValues.put('BillingCity', 'San Francisco'); 
             // Create an instance of Account dynamically
            Account dynamicAccount = new Account();
            System.debug('fieldValues ========> ' + fieldValues);
            // Set field values using the map
            for (String fieldName : fieldValues.keySet()) {
				System.debug('fieldName =====> ' + fieldName);
                dynamicAccount.put(fieldName, fieldValues.get(fieldName));

            }
			System.debug('Dynamic Account =======>  ' + dynamicAccount);
            // Insert the account record
            insert dynamicAccount;
            
            // Return the created account
            return dynamicAccount;

           /* Account acct = new Account(Name = accName,);
            // Insert the account by using DML
			insert acct;
			return acct; 
        }catch (DmlException e) {
    		System.debug('A DML exception has occurred: ' +
                e.getMessage());
			return null;
		}
    } */


}