public class SearchAccountName {
    	@AuraEnabled
   		public static List<Account> writeSearchAccountName(String searchText) {
			System.debug('searchText ======>' + searchText);
            String searchPattern = searchText + '*';
            List<List<SObject>> searchResults = [FIND :searchPattern IN ALL FIELDS RETURNING Account(Id, Name, Phone, BillingStreet, BillingCity)];
            List<Account> acc = (List<Account>) searchResults[0];
            System.debug('Account =========>' + acc);
            return acc;
        }

 
}