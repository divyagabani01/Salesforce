import { LightningElement, track } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'omnistudio/omniscriptInternalUtils';
import { ShowToastEvent } from "lightning/platformShowToastEvent";


export default class APIConnection extends OmniscriptBaseMixin(LightningElement) {
    _ns = getNamespaceDotNotation();

    @track field = {
        title: '',
        userId: 3
    }


    handleSubmit() {
        const options = {};
        console.log('field :>> ', this.field);
        const params = {
            input: JSON.stringify(this.field),
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "REST_TESTINGAPI",
            options: options,
        };

        // // // Check if fields are valid before submission
        // if (!this.validateFields(this.field)) {
        //     console.error("Validation failed: One or more required fields are missing.");
        //     this.showToast(
        //         "Error",
        //         "Validation failed: One or more required fields are missing.",
        //         "error"
        //     );
        //     return;
        // }


        this.omniRemoteCall(params, true).then(res => {
            if (res) {
                console.log('res :>> ', res);
                this.isSuccess = res.result.IPResult;
                console.log('this.isSuccess :>> ', this.isSuccess);
                // if (this.isSuccess) {
                //     this.readOnly = true;
                //     this.showToast(
                //         "Success",
                //         `The record has been updated successfully.`,
                //         "success"
                //     );
                //     console.log('res.result :>> ', res.result.IPResult);
                //     // this.field = { ...res.result.IPResult.Account_1[0] }
                //     // this.field.Email = res.result.IPResult.Account_1[0].Eamil_Address__c;
                //     // this.omniApplyCallResp(this.field);
                //     // const newLocal = "standard__recordPage";
                //     // this[NavigationMixin.Navigate]({
                //     //     type: newLocal,
                //     //     attributes: {
                //     //         recordId: this.field.Id, // Record ID for navigation
                //     //         objectApiName: 'Account', // Optional: specify the object API name
                //     //         actionName: 'view' // Navigate to the record's detail page
                //     //     },
                //     // });
                // }
            }
        }).catch(error => {
            if (error) {
                console.error('error **********======== :>> ', error);
            }
        });
    }

    handleChange(event) {
        const field = event.target.dataset.id;
        console.log('event.target.dataset :>> ', event.target.dataset);
        let inputValue = event.target.value;
        this.field[field] = inputValue;
    }

    // validateFields(accountData) {
    //     const requiredFields = ["title", "userId"];

    //     // Check if any required field is empty or null
    //     for (const field of requiredFields) {
    //         if (!accountData[field] || accountData[field]=== "") {
    //             console.error(`Field "${field}" is missing or invalid.`);
    //             return false; // Stop validation if any field is invalid
    //         }
    //     }
    //     return true; // All fields are valid
    // }

    // Show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}