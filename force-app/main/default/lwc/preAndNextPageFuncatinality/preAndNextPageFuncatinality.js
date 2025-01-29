import { LightningElement, track, api } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getNamespaceDotNotation } from 'omnistudio/omniscriptInternalUtils';
import Site from '@salesforce/schema/Account.Site';

export default class PreAndNextPageFunctionality extends OmniscriptBaseMixin(LightningElement) {
    _ns = getNamespaceDotNotation();


    @track typeOfForm = 'Create';

    @track isreadonly = false;
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
            this.accountList = { ...this.omniJsonData.Account }; // Clone the object to avoid mutation
            this.accountList.Id = this.omniJsonData.Account?.Id; // Safely assign Id
            if (this.accountList.Id) {
                this.isreadonly = true;
            }
        }
    }

    getAccountDetails(event) {
        this.accountList = event.detail;
    }

    // Handle click on the Next button
    handleNextStep() {
        if (this.typeOfForm == 'Create' && this.accountList.Id == "") {

            this.submitAccount(this.accountList);

        } else {
            this.omniApplyCallResp({ "Account": this.accountList });
            this.omniNextStep();
        }

    }

    submitAccount(accountList) {
        const options = {};
        const params = {
            input: accountList,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "LWC_DCreateAndEditAccount",
            options: options,
        };

        // // Check if fields are valid before submission
        if (!this.validateFields(accountList)) {
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
                const result = res.result.IPResult.Account_1[0];
                if (result && result.Id) {
                    this.isEdit = true;
                    this.accountList.Id = result.Id;
                }
                this.omniApplyCallResp({ "Account": accountList });
                this.isSuccess = res.result.IPResult.Account_1[0].UpsertSuccess;
                if (this.isSuccess) {
                    this.showToast(
                        "Success",
                        `The record has been created successfully.`,
                        "success"
                    );
                    this.omniNextStep();  // Navigate to the target step
                }
            }
        }).catch(error => {
            if (error) {
                console.error('error **********======== :>> ', error);
            }
        });
    }

    // Handle click on the Previous button
    handlePreviousStep() {
        this.omniPrevStep();  // Navigate back to the previous step
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
                return false; // Stop validation if any field is invalid
            }
        }
        return true; // All fields are valid
    }
}