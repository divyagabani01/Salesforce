import { LightningElement,track } from 'lwc';
const columnDefinitions = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text'
    },

    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone'
    },

    {
        label: 'BillingStreet',
        fieldName: 'BillingStreet',
        type: 'text'
    },
    {
        label: 'BillingCity',
        fieldName: 'BillingCity',
        type: 'text'
    }
];
export default class SerachableAccountTable extends LightningElement {
    @track Name = '';
    @track Data = [];
    @track Column = columnDefinitions;
}