public class InsertContact {
    public static void createContacts(){
        List<Contact> cons = new List<Contact>();
        for (Integer i = 0; i < 2; i++) {
            Contact contacts = new Contact();
            contacts.LastName = 'Nisha' + generateRandomString(8);
            contacts.AccountId = '001GB00003BrY1iYAF';
            cons.add(contacts);
        }
		System.debug('cons ======> ' + cons);
        if (!cons.isEmpty()) {
            Database.insert(cons);
        }


    }
		// Function to generate a random string of a given length
       Public static String generateRandomString(Integer length) {
                String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
                String randomStr = '';
                Integer charactersLength = characters.length();
                
                for (Integer i = 0; i < length; i++) {
                    Integer randomIndex = Math.floor(Math.random() * charactersLength).intValue();
                    randomStr += characters.substring(randomIndex, randomIndex + 1);
                }
                
                return randomStr;
		}

}