public class AccountAndImageController {
    @AuraEnabled(cacheable=true)
    public static ContentVersion getImageById(Id accountId) {
        ContentVersion contentVersion = [Select Id,Title,VersionData,ContentDocumentId,ContentUrl,VersionDataUrl from ContentVersion where ParentId__c =: accountId Limit 1];
        return contentVersion;
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountDetails(Id accountId) {
        return [Select Id, Name, Phone, BirthofDate__c, Active__c, Account_Email__c, Type, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry from Account where Id =: accountId];
    }
}