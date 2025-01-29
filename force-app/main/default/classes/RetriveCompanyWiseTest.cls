@IsTest
public class RetriveCompanyWiseTest {
	@testSetup
    static void setupTestData() { 
                    // Create a list to hold company records
            List<Company__c> companies = new List<Company__c>();
            
            for (Integer i = 0; i < 2; i++) {
                companies.add(new Company__c(Company_Name__c = 'Company' + i));
            }
            
            insert companies;
            
            List<Car__c> cars = new List<Car__c>();
            
            for (Company__c com : companies) {
                for (Integer i = 0; i < 2; i++) {
                     cars.add(new Car__c(Car_Name__c = 'car' + i, Company_Name__c = com.Id));
                }
            }
            
            insert cars;
	}
	
	@IsTest
    static void RetriveCompanyWise(){
        List<Car__c> CarDetails = [SELECT Car_Name__c,Company_Name__r.Company_Name__c FROM Car__c];
		List<Car__c> CarDetails1 = [SELECT Car_Name__c,Company_Name__r.Company_Name__c FROM Car__c where Car_Name__c = null];
		Test.startTest();
				RetriveCompanyWise.getCompanyWiseCar(CarDetails);
				RetriveCompanyWise.getCompanyWiseCar(CarDetails1);
		Test.stopTest();
    }
}