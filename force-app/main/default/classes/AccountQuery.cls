public class AccountQuery {
	@AuraEnabled(cacheable=true)
    public static List<Account> searchAccount(String searchText, Integer pageNumber, Integer pageSize) {
        Integer offset = (pageNumber - 1) * pageSize;
		if (String.isBlank(searchText)) {
            return [ SELECT Id, Name, Phone,Website,Type,Active__c, BillingStreet, BillingCity, BillingState, BillingCountry FROM Account ORDER BY CreatedById DESC
            LIMIT :pageSize
            OFFSET :offset];
        }
        return [
            SELECT Id, Name, Phone,Website,Type, Active__c,BillingStreet, BillingCity, BillingState, BillingCountry
            FROM Account
            WHERE Name LIKE :('%' + searchText + '%')
            ORDER BY CreatedById DESC
            LIMIT :pageSize
            OFFSET :offset
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalSearchAccount(String searchText) {
		if (String.isBlank(searchText)) {
				return [SELECT COUNT() FROM Account];
        }
       return [SELECT COUNT() FROM Account WHERE Name LIKE :('%' + searchText + '%')];
    }
}