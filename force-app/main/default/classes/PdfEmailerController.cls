public class PdfEmailerController {
    public Account account { get; set; }
    public List<Contact> contacts { get; set; }
    public List<Opportunity> opportunities { get; set; }

    public PdfEmailerController(ApexPages.StandardController controller) {
        account = (Account)controller.getRecord();
        contacts = [SELECT Name, Email, Phone FROM Contact WHERE AccountId = :account.Id];
        opportunities = [SELECT Name, StageName, Amount FROM Opportunity WHERE AccountId = :account.Id];
    }

}