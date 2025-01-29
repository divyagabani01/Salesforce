import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class ContactCreator extends LightningElement {
    // Defining the fields to be included in the form
    fields = [FIRST_NAME_FIELD, LAST_NAME_FIELD, EMAIL_FIELD];

    handleSuccess(event) {
        // Get the ID of the newly created contact
        const contactId = event.detail.id;
        // Show the success toast message
        const toastEvent = new ShowToastEvent({
            title: 'Contact Created',
            message: `Contact ID: ${contactId}`,
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
    }
}
