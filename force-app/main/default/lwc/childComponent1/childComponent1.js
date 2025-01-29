import { LightningElement ,track,api} from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'omnistudio/omniscriptInternalUtils';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getPicklist from '@salesforce/apex/PicklistHelper.getPicklist';

export default class ChildComponent1 extends OmniscriptBaseMixin(LightningElement) {
    _ns = getNamespaceDotNotation();

    @api type;

    @track Name = '';
    @track Email = '';
    @track Phone = '';
    @track Type = '';
    @track Industry = '';
    @track Rating = '';
    @track operation = '';

    @track options = {};

    @track typeOptions = [];
    @track industryOptions = [];
    @track ratingOptions = [];

    @track isEdit = false;
    @track isLabelChanges = false;
    @track readOnly = false;


    field = {
        Name: "",
        Email: "",
        Phone: "",
        Type: "",
        Industry: "",
        Rating: "",
        Id: ""
    }

    connectedCallback() {
        // Example: Load picklist values for multiple fields
        this.loadPicklistValues('Account', 'Type');
        this.loadPicklistValues('Account', 'Industry');
        this.loadPicklistValues('Account', 'Rating');
    }

    async loadPicklistValues(objectName, fieldName) {
        try {
            const data = await getPicklist({ objectName, fieldName });
            // Use the field name as the dynamic key
            this.options = { ...this.options, [fieldName]: data };
        } catch (error) {
            console.error(`Error fetching picklist values for ${fieldName}:`, error);
            this.error = error;
        }
    }

    handleChange(event) {
        const field = event.target.dataset.field;
        this.field[field] = event.target.value;
    }

    handleSubmit(event) {
        // Call OmniScript method to submit data
        this.omniApplyCallResp(this.field);

        console.log('type :>> ', type);

        const options = {};
        const params = {
            input: this.field,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "LWC_DCreateAndEditAccount",
            options: options,
        };

        // // Check if fields are valid before submission
        if (!this.validateFields(this.field)) {
            console.error("Validation failed: One or more required fields are missing.");
            this.showToast(
                "Error",
                "Validation failed: One or more required fields are missing.",
                "error"
            );
            return;
        }


        this.omniRemoteCall(params, true).then(res => {
            if (res) {
                const result = res.result.IPResult.result.Account_1[0];
                setTimeout(() => {       
                    this.dispatchEvent(new CustomEvent('sendaccountdetails', {
                        detail: { ...res.result.IPResult.result.Account_1[0] }
                    }));
                    
                }, 1000);
                if (result && result.Id) {
                    this.isEdit = true;
                    this.field.Id = result.Id;
                }
                this.isSuccess = res.result.IPResult.success;
                if (this.isSuccess) {
                    const label = this.Type;
                    this.readOnly = true;
                    if (this.readOnly == false && this.isLabelChanges) {
                        this.Name = "";
                        this.Email = "";
                        this.Phone = "";
                        this.Type = "";
                        this.Rating = "";
                        this.Industry = "";
                        this.isEdit = false;
                    }
                    this.showToast(
                        "Success",
                        `Record "${label}" is Successfully.`,
                        "success"
                    );
                }
            }
        }).catch(error => {
            if (error) {
                console.log('error **********======== :>> ', error);
            }
        });
    }

    // Show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    validateFields(accountData) {
        const requiredFields = ["Name", "Email", "Phone", "Type", "Industry"];

        // Check if any required field is empty or null
        for (const field of requiredFields) {
            if (!accountData[field] || accountData[field].trim() === "") {
                console.error(`Field "${field}" is missing or invalid.`);
                return false; // Stop validation if any field is invalid
            }
        }
        return true; // All fields are valid
    }

}