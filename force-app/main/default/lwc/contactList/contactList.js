import { LightningElement, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import { reduceErrors } from 'c/ldsUtils'; // Import reduceErrors from ldsUtils

export default class ContactList extends LightningElement {
    // Define the columns for the lightning-datatable
    columns = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Email', fieldName: 'Email' }
    ];

    // Store the contacts from the Apex method
    contacts;

    // Store any errors that might occur during the wire call
    @track errors;

    // Wire the Apex method to fetch the contacts
    @wire(getContacts)
    wiredContacts({ error, data }) {
        if (data) {
            // Map the data to the correct format for lightning-datatable
            this.contacts = data.map(contact => ({
                ...contact,
                id: contact.Id // Ensure there's an 'id' field for the key-field in lightning-datatable
            }));
        } else if (error) {
            this.errors = error; // Store the error
            console.error('Error fetching contacts:', error);
        }
    }

    // Getter for error handling (to be used in the HTML template)
    get hasError() {
        return this.errors ? true : false;
    }

    // Getter to display a reduced error message using reduceErrors function
    get errors() {
        return this.errors ? reduceErrors(this.errors) : []; // Use reduceErrors to format the error messages
    }
}
