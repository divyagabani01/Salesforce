public with sharing class ExcelController {
    public Account account { get; set; }
    public List<Contact> contacts { get; set; }
    public List<Opportunity> opportunities { get; set; }

    // Constructor for StandardController
    public ExcelController(ApexPages.StandardController controller) {
        account = (Account)controller.getRecord();
        contacts = [SELECT Name, Email, Phone FROM Contact WHERE AccountId = :account.Id];
        opportunities = [SELECT Name, StageName, Amount FROM Opportunity WHERE AccountId = :account.Id];
    }

    // Static method to generate Excel content
    @AuraEnabled
    public static String generateExcelFile(String accountId) {
        // Fetch related data
        Account account = [SELECT Id FROM Account WHERE Id = :accountId LIMIT 1];
        List<Contact> contacts = [SELECT Name, Email, Phone FROM Contact WHERE AccountId = :account.Id];
        List<Opportunity> opportunities = [SELECT Name, StageName, Amount FROM Opportunity WHERE AccountId = :account.Id];

        // Excel XML content
        String excelContent = '<?xml version="1.0" encoding="UTF-8"?>';
        excelContent += '<?mso-application progid="Excel.Sheet"?>';
        excelContent += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">';
        
        // Contacts Worksheet
        excelContent += '<Worksheet ss:Name="Contacts"><Table>';
        excelContent += '<Row><Cell><Data ss:Type="String">Name</Data></Cell>';
        excelContent += '<Cell><Data ss:Type="String">Email</Data></Cell>';
        excelContent += '<Cell><Data ss:Type="String">Phone</Data></Cell></Row>';
        
        for (Contact c : contacts) {
            excelContent += '<Row>';
            excelContent += '<Cell><Data ss:Type="String">' + c.Name + '</Data></Cell>';
            excelContent += '<Cell><Data ss:Type="String">' + c.Email + '</Data></Cell>';
            excelContent += '<Cell><Data ss:Type="String">' + c.Phone + '</Data></Cell>';
            excelContent += '</Row>';
        }
        excelContent += '</Table></Worksheet>';

        // Opportunities Worksheet
        excelContent += '<Worksheet ss:Name="Opportunities"><Table>';
        excelContent += '<Row><Cell><Data ss:Type="String">Opportunity Name</Data></Cell>';
        excelContent += '<Cell><Data ss:Type="String">Stage</Data></Cell>';
        excelContent += '<Cell><Data ss:Type="Number">Amount</Data></Cell></Row>';
        
        for (Opportunity o : opportunities) {
            excelContent += '<Row>';
            excelContent += '<Cell><Data ss:Type="String">' + o.Name + '</Data></Cell>';
            excelContent += '<Cell><Data ss:Type="String">' + o.StageName + '</Data></Cell>';
            excelContent += '<Cell><Data ss:Type="Number">' + o.Amount + '</Data></Cell>';
            excelContent += '</Row>';
        }
        excelContent += '</Table></Worksheet>';

        excelContent += '</Workbook>';

        // Convert to Blob
        Blob excelBlob = Blob.valueOf(excelContent);
        String fileName = 'Account_Contacts_Opportunities_' + Datetime.now().getTime() + '.xls';

        // Save to ContentVersion
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = fileName;
        contentVersion.PathOnClient = fileName;
        contentVersion.VersionData = excelBlob;
        insert contentVersion;

        // Get the ContentVersion ID for the download link
        ContentVersion cv = [SELECT Id FROM ContentVersion WHERE Title = :fileName ORDER BY CreatedDate DESC LIMIT 1];
        return '/sfc/servlet.shepherd/version/download/' + cv.Id; // Return the download URL
    }
}