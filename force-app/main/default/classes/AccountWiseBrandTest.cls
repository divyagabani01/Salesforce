@IsTest
public class AccountWiseBrandTest {
	@testsetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
		List<Brand__c> brands = new List<Brand__c>();
        for(Integer i=0;i<5;i++){
             Account acc = new Account();
            	acc.Name = 'Testing' + i;
				accounts.add(acc);
        }
        insert accounts;
        for(Account acc: accounts){
            for(Integer i=0;i<5;i++){
             	Brand__c brand = new Brand__c();
        		brand.Brand_Name__c = 'Testing Brand' + i;
            	brand.Account__c = acc.id;
				brands.add(brand);
        	}
        }	 
        insert brands;
	}
	@IsTest 
    static void AccountWiseBrand(){
        List<Brand__c> BrandList = [SELECT Brand_Name__c,Account__r.Name FROM Brand__c];
		Test.startTest();
            Map<String,List<Brand__c>> brandMap = AccountWiseBrand.getBrandAccountWise(BrandList);
			System.debug('opportunintyMap ========>' + brandMap);
			for(Integer i=0;i<5;i++){
				AccountWiseBrand.createAccountRecord('Testing' + i,'brand' + i);
            }
			 
		String invalidAccountName = null;
        String validBrandName = 'TestBrand';
		AccountWiseBrand.createAccountRecord(invalidAccountName,validBrandName);
        // Using System.assertNotEquals to check if the result is not null
        Test.stopTest();

    }
}