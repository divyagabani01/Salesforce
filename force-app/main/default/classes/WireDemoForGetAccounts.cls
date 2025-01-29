public class WireDemoForGetAccounts {
	@AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        List<Account> accountDetails = [Select Id,Name,Type,Phone,Website,Active__c from Account ORDER BY LastModifiedDate DESC];
        return accountDetails;
    }
    
}