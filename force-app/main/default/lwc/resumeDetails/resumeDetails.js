import { LightningElement, api, track } from 'lwc';
import executeLogic from '@salesforce/apex/getResumeAccountLink.executeLogic';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class ResumeDetails extends LightningElement {
    @api recordId; // This will get the current Account ID from the context
    @track resumeUrl; // The URL to display

    // Handler to call the Apex method when the button is clicked
    handleExecuteLogic() {
        console.log('this.recordId :>> ', this.recordId);
        // Call the Apex method to get the Resume URL
        executeLogic({ recordId: this.recordId })
            .then(result => {
                if (result != 'False') {
                    console.log('result :>> ', result);
                    this.resumeUrl = result; // Set the resume URL when the result is returned
                    if (this.resumeUrl) {
                        window.open(this.resumeUrl, '_blank');
                    }
                } else {
                    this.showToast(
                        "Info",
                        'The requested URL could not be found.',
                        "info"
                    );
                }
            }).catch(error => {
                this.showToast(
                    "Info",
                    'The requested URL could not be found.',
                    "info"
                );
                console.error('Error fetching resume URL: ', error);
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}