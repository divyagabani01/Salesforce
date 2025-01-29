public class ProductAndProductLineItemHelper {
    public static void getProduct(set<Id> oppId){
    List<Opportunity> oppList = [SELECT 
    Id, 
    Name, 
    AccountId, 
    CloseDate, 
    StageName, 
    Amount, 
    Description,
    (SELECT 
        Id, 
        Quantity, 
        UnitPrice, 
        ProductCode, 
        Description,
		Name
    FROM OpportunityLineItems) 
FROM Opportunity 
WHERE Id = :oppId
];

	List<Product__c> ProductList = new List<Product__c>();
	List<Product_Line_Item__c> ProductLineItemList= new List<Product_Line_Item__c>();
        for(Opportunity opp: oppList){
            Product__c product = new Product__c();
            product.Name = opp.Name;
            product.Close_Date__c = opp.CloseDate;
            product.StageName__c = opp.StageName;
            product.Amount__c = opp.Amount;
            product.Description__c = opp.Description;
			product.Opportunity__c = opp.Id;
			ProductList.add(product);
			for (OpportunityLineItem oli : opp.OpportunityLineItems) {
                    Product_Line_Item__c Product_Line_Item = new Product_Line_Item__c();
                    Product_Line_Item.Name__c = oli.Name;
                	Product_Line_Item.Quantity__c = oli.Quantity;
					Product_Line_Item.Sales_Price__c= oli.UnitPrice;
                	Product_Line_Item.Product_Code__c = oli.ProductCode;
					Product_Line_Item.Description__c= oli.Description;
					Product_Line_Item.Opportunity__c = opp.Id;
                	ProductLineItemList.add(Product_Line_Item);
             }	
        }
        if(!ProductList.isEmpty()){
            insert ProductList;
        }
        if(!ProductLineItemList.isEmpty()){
            insert ProductLineItemList;
        }
    }
}