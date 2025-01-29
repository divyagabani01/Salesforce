import { LightningElement ,wire,track} from 'lwc';
import getAccountList from '@salesforce/apex/WireDemoForGetAccounts.getAccounts';

const columns = [{
     label: 'Account Name',
     fieldName: 'Name',
     type: 'text'
},{
     label: 'Type',
     fieldName: 'Type',
     type: 'text'
},{
     label: 'Phone',
     fieldName: 'Phone',
     type: 'phone'
},{
     label: 'Website',
     fieldName: 'Website',
     type: 'url'
},{
     label: 'Owner',
     fieldName: 'Owner',
     type: 'text'
}]
export default class WireDecoratorsDemo extends LightningElement {
    @track columns = columns;
    @track data = [];
    height = '200px';
    @track error;
    @wire(getAccountList)
    wiredAccounts({data, error}) {
        if(data) {
            this.data = data;
        } else if(error) {
            this.error = error;
        }
    }
}