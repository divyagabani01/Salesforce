public class AccountWiseContactList {
	//  retrieve all the account wise contact number list
    public static Map<String,List<String>> getAccountWiseConatctList(List<Contact> contactList){
        Map<String,List<String>> ContactMap = new Map<String,List<String>>();
        for(Contact cons : contactList){

                if(!ContactMap.containsKey(cons.Account.Name)){
                    ContactMap.put(cons.Account.Name, new List<String>{cons.Name});
                }else{
                    ContactMap.get(cons.Account.Name).add(cons.Name);
                }
           
        }
		System.debug('AccountWiseConatctList =======> ' + ContactMap);
        return ContactMap;
    }
}