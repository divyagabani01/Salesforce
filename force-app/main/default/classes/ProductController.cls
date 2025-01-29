public class ProductController {
    @AuraEnabled(cacheable=true)
    public static Product__c getProductById(Id productId) {
        return [SELECT Id, Name, Amount__c, Close_Date__c,Picture_URL__c, Description__c, StageName__c	 FROM Product__c WHERE Id = :productId];
    }
}