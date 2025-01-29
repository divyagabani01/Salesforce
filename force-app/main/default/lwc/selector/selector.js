// selector.js
import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';

export default class SelectorComponent extends LightningElement {
    userName;
    name;
    selectedBike;

    // Fetch the current user's name using @wire
    @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] })
    user({ error, data }) {
        if (data) {
            this.userName = data.fields.Name.value;
            this.name = data.fields.Name.value;
        } else if (error) {
            console.error('Error fetching user data: ', error);
        }
    }

    handleBikeChange(event) {
        this.selectedBike = event.target.value;
    }
}