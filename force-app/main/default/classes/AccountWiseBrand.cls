public class AccountWiseBrand {
	// retrieve all the account wise brand list
    public static Map<String,List<Brand__c>> getBrandAccountWise(List<Brand__c> BrandList){
        Map<String,List<Brand__c>> brandMap = new Map<String,List<Brand__c>>();
        //List<Brand__c> BrandList = [SELECT 	Brand_Name__c,Account__r.Name FROM Brand__c];
        System.debug('BrandList ========> ' + BrandList);
		for(Brand__c Brands :BrandList ){
            if(!brandMap.containsKey(Brands.Account__r.Name)){
                System.debug('Brands.Account__r.Name' + Brands.Account__r.Name);
                brandMap.put(Brands.Account__r.Name,new List<Brand__c>{Brands});
             }else{
             	 brandMap.get(Brands.Account__r.Name).add(Brands);
			 }
        }
		System.debug('account wise brand list =====> ' + brandMap);
            return brandMap;
    }

	 // Create account and its related Brand Record (values is coming from parameters)
    public static void createAccountRecord(String AccountName,String BrandName){
        try{
            Account acc = new Account();
            acc.Name = accountName;
        	insert acc;    
			System.debug('Account ========>' +  acc);
			Brand__c brand = new Brand__c();
        	brand.Brand_Name__c = BrandName;
            brand.Account__c = acc.id;
			insert brand;
			System.debug('Brand ========>' +  brand);
        }catch(Exception e){
            System.debug('Error ======>' + e.getMessage());
        }
    }

	
}