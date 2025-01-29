import Site from '@salesforce/schema/Account.Site';
import { LightningElement, track } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'omnistudio/omniscriptInternalUtils';

export default class ChildComponent2 extends OmniscriptBaseMixin(LightningElement) {
    _ns = getNamespaceDotNotation();

    @track readOnly = true;

    @track typeOfForm = 'Update';
    
    @track accountList = {
        Name: "",
        Email: "",
        Phone: "",
        Type: "",
        Industry: "",
        Rating: "",
        Id: "",
        Site: ""
    }


    connectedCallback() {
        if (this.omniJsonData?.editDetails) {
            this.accountList = { ...this.omniJsonData.editDetails }; // Clone the object to avoid mutation
            this.accountList.Id = this.omniJsonData.Account?.Id; // Safely assign Id
        }
    }


}