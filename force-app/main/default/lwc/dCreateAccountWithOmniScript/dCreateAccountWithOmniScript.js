import { LightningElement, track } from 'lwc'; // Include api if you plan to expose properties.
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'omnistudio/omniscriptInternalUtils';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import pubsub from 'omnistudio/pubsub';
import getPicklist from '@salesforce/apex/PicklistHelper.getPicklist';


export default class DCreateAccountWithOmniScript extends OmniscriptBaseMixin(LightningElement) {
    _ns = getNamespaceDotNotation();
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

    // renderedCallback() {
    //     pubsub.register('omniscript_action', {
    //         data: this.handleOmniAction.bind(this),
    //     });
    //     pubsub.register('omniscript_step', {
    //         data: this.handleOmniStepLoadData.bind(this),
    //     });
    // }

    handleOmniAction(data) {
        console.log('handleOmniAction data :>> ', data);
        switch(data.name) {
          case 'SomeNameForAction':
            this.handleSomeNameForAction(data);
            break;
          case 'SomeNameForAction2':
            this.handleSomeNameForAction2(data);
            break;
          default:
            // handle default case
        }
      }
      
      handleSomeNameForAction(data) {
          // perform some logic specific to SomeNameForAction action
          // that has element name = "SomeNameForAction"
      }
      
      handleSomeNameForAction2(data) {
          // perform some logic specific to SomeNameForAction2 action
          // that has element name = "SomeNameForAction2"
      }

      handleOmniStepLoadData(data) {
        console.log('handleOmniStepLoadData data :>> ', data);
        switch(data.name) {
          case 'FirstStep':
            this.handleOmniFirstStepLoadData(data);
            break;
          case 'SecondStep':
            this.handleOmniSecondStepLoadData(data);
            break;
          default:
            // handle default case
        }
      }
      
      handleOmniFirstStepLoadData(data) {
          // perform some logic specific when a Step element which name is
          // FirstStep is loaded
      }
      
      handleOmniSecondStepLoadData(data) {
          // perform some logic specific when a Step element which name is
          // SecondStep is loaded
      }

      handleOmniAction(data) {
        switch(data.type) {
          case 'Integration Procedure Action':
            this.handleIPActionPubsubEvents(data);
            break;
          case 'Remote Action':
            this.handleRemoteActionPubsubEvents(data);
            break;
          default:
            // handle default case
        }
      }
      
      handleIPActionPubsubEvents(data) {

          // perform some logic specific to Integration Procedure Actions
      }
      
      handleRemoteActionPubsubEvents(data) {
          // perform some logic specific to Remote Actions
      }

    async loadPicklistValues(objectName, fieldName) {
        try {
            const data = await getPicklist({ objectName, fieldName });
            // Use the field name as the dynamic key
            this.options = { ...this.options, [fieldName]: data };
            console.log(`Options for==================:`, this.options[fieldName]);
        } catch (error) {
            console.error(`Error fetching picklist values for ${fieldName}:`, error);
            this.error = error;
        }
    }

    handleChange(event) {
        const field = event.target.dataset.field;
        this.field[field] = event.target.value;
    }

    handleEdit(event) {
        this.operation = event.target.dataset.operation;
        this.readOnly = false;
        this.isLabelChanges = true;
    }

    handleCancle(event) {
        this.readOnly = true;
    }

    handleSubmit(event) {
        this.operation = event.target.dataset.operation;
        // Call OmniScript method to submit data
      

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
            console.log('res :>> ', res);
            if (res) {
                const result = res.result.IPResult.Account_1[0];
                setTimeout(() => {       
                    this.dispatchEvent(new CustomEvent('sendaccountdetails', {
                        detail: { ...res.result.IPResult.Account_1[0] }
                    }));
                    
                }, 1000);
                if (result && result.Id) {
                    this.isEdit = true;
                    this.field.Id = result.Id;
                }
                this.omniApplyCallResp(this.field);
                pubsub.register('omniscript_action', {
                    data: this.handleOmniAction.bind(this),
                });
                pubsub.register('omniscript_step', {
                    data: this.handleOmniStepLoadData.bind(this),
                });
                this.isSuccess = res.result.IPResult.Account_1[0].UpsertSuccess;
                if (this.isSuccess) {
                    const label = this.readOnly == false && this.isLabelChanges ? 'Update' : 'Created';
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