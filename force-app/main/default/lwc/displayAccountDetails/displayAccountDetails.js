import { LightningElement, api, track, wire } from 'lwc';
import getImageById from '@salesforce/apex/AccountAndImageController.getImageById';
import getAccountDetails from '@salesforce/apex/AccountAndImageController.getAccountDetails';

export default class Detail extends LightningElement {
    @api recordId; // Account ID received from parent component

    @track accountDetails = {}; // Consolidated account details
    @track imageDetails = {};   // Image-related details
    error;                      // Holds error message if any

    // Fetch account details
    @wire(getAccountDetails, { accountId: '$recordId' })
    wiredAccountDetails({ data, error }) {
        if (data) {
            this.accountDetails = { ...this.accountDetails, ...data };
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.error('Error fetching account details:', error);
        }
    }

    // Fetch image details
    @wire(getImageById, { accountId: '$recordId' })
    wiredImageDetails({ data, error }) {
        if (data) {
            console.log('data :>> ', data);
            this.imageDetails = {
                imageurl: data.VersionDataUrl,
                title: data.Title,
            };
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.error('Error fetching image details:', error);
        }
    }

    // Getter to combine image and account details
    get combinedDetails() {
        return { ...this.accountDetails, ...this.imageDetails };
    }

    // Format Birth Date as a readable string
    get formattedBirthDate() {
        return this.accountDetails.BirthofDate__c
            ? new Date(this.accountDetails.BirthofDate__c).toLocaleDateString()
            : 'N/A';
    }

    // Format Active Status (true/false) as Yes/No
    get activeStatus() {
        return this.accountDetails.Active__c ? 'Yes' : 'No';
    }
}
