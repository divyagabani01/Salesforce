public class RetriveCompanyWise {
	// Retrieve company wise car record
    public static Map<String,List<String>> getCompanyWiseCar(List<Car__c> CarDetails){
        Map<String,List<String>> CarNamesMap =  new Map<String, List<String>>();
        
        for(Car__c Cars :CarDetails ){
            if(!CarNamesMap.containsKey(Cars.Company_Name__r.Company_Name__c)){
                System.debug('' + Cars.Car_Name__c);
                CarNamesMap.put(Cars.Company_Name__r.Company_Name__c,new List<String>{Cars.Car_Name__c});
             }else{
             	 CarNamesMap.get(Cars.Company_Name__r.Company_Name__c).add(Cars.Car_Name__c)          ;
			 }
        }
		System.debug('CarNames ====> ' + CarNamesMap);
        if(!CarNamesMap.isEmpty()){
            return CarNamesMap;
        }
		return null;
    }
}