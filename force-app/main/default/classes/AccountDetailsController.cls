public class AccountDetailsController {
    public Account acc { get; set; }
    public ContentVersion contentVersion { get; set; }
    public String imageUrl { get; set; }

    public AccountDetailsController() {
        Id accountId = ApexPages.currentPage().getParameters().get('id');
        
        if (accountId != null) {
            // Fetch Account details
            List<Account> accList = [SELECT Name, BillingStreet, BillingCity, BillingState, 
                                             BillingPostalCode, BillingCountry, Phone, Website, Industry 
                                      FROM Account WHERE Id = :accountId LIMIT 1];

            if (!accList.isEmpty()) {
                acc = accList[0];
            } else {
                acc = new Account(); // Assign a blank account to prevent null pointer issues
            }

            // Fetch related ContentVersion (Image)
            List<ContentVersion> contentList = [SELECT Id, ContentDocumentId 
                                                FROM ContentVersion 
                                                WHERE ParentId__c = :accountId 
                                                ORDER BY CreatedDate DESC 
                                                LIMIT 2];

            if (!contentList.isEmpty()) {
                contentVersion = contentList[1];
                imageUrl = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + contentVersion.Id;
            } else {
                imageUrl = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=068GB00000qAEeHYAW'; // Handle case where no image exists
            }
        }
    }
}