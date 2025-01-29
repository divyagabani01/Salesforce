public class ContactSearch {
    public static List<Contact> searchForContacts(String LastName,String mailingPostalCode){
        
		Contact[] con = [SELECT Id,Name from Contact where MailingPostalCode =:mailingPostalCode AND LastName =:LastName];
        System.debug('con ====> ' + con);
		return con;
    }
}