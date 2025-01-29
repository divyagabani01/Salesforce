public class UpdateLoanApplicationQueueable implements Queueable {
    private List<Id> loanApplicationIds;

    public UpdateLoanApplicationQueueable(List<Id> appIds) {
        this.loanApplicationIds = appIds;
    }

    public void execute(QueueableContext context) {
        List<Loan_Application__c> loanApplicationsToUpdate = new List<Loan_Application__c>();

        // Fetch fresh copies of Loan_Application__c records using IDs
        List<Loan_Application__c> loanApplications = [SELECT Id, Sequence_Namber__c, Loan_Application_Number__c FROM Loan_Application__c WHERE Id IN :loanApplicationIds];

        for (Loan_Application__c loanApp : loanApplications) {
            if (loanApp.Loan_Application_Number__c == null) {
                String financialYear = getFinancialYear();
                String newLoanNumber = 'APL' + financialYear + String.valueOf(loanApp.Sequence_Namber__c);
                System.debug('New Loan Number for ' + loanApp.Id + ': ' + newLoanNumber);
                loanApp.Loan_Application_Number__c = newLoanNumber;
                loanApplicationsToUpdate.add(loanApp);
            }
        }

        if (!loanApplicationsToUpdate.isEmpty()) {
            // Update the cloned records in a separate transaction
            try {
                update loanApplicationsToUpdate;
            } catch (Exception e) {
                System.debug('Error updating records: ' + e.getMessage());
                // Handle any errors or exceptions here
            }
        }
    }

    public static String getFinancialYear() {
        Integer currentYear = Date.today().year();
        Integer startYear;
        Integer endYear;

        if (Date.today().month() >= 4) {
            startYear = currentYear;
            endYear = currentYear + 1;
        } else {
            startYear = currentYear - 1;
            endYear = currentYear;
        }

        return String.valueOf(startYear).substring(2) + String.valueOf(endYear).substring(2);
    }
}