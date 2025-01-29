public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads(String serachName){
		System.debug('Search Name =====> ' + serachName);
		List<List<sObject>> searchList = [FIND :serachName IN ALL FIELDS
                    	RETURNING Lead(FirstName,LastName),Contact(FirstName,LastName)];
		System.debug('searchList =====> ' + searchList);
		return searchList;
	}	
}