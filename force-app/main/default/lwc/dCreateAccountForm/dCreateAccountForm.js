import { LightningElement, track, api } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'omnistudio/omniscriptInternalUtils';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getPicklist from '@salesforce/apex/PicklistHelper.getPicklist';
import { NavigationMixin } from "lightning/navigation";
import pubsub from 'omnistudio/pubsub';

// Prevent certain characters and patterns
const regexSpecialChars = /[#!$%^\`,~()*;'",<>\[\]\{\}]/i;
const regexStrings = /<S*SCRIPT|&APOS;|<S*DOCTYPE/i;

export default class ChildComponent1 extends NavigationMixin(OmniscriptBaseMixin(LightningElement)) {
    _ns = getNamespaceDotNotation();

    // @api type;
    @api isreadonly;



    @track Name = '';
    @track Email = '';
    @track Phone = '';
    @track Type = '';
    @track Industry = '';
    @track Rating = '';
    @track operation = '';
    @track errorMessage = '';

    @track options = {};

    @track typeOptions = [];
    @track industryOptions = [];
    @track ratingOptions = [];

    @track isEdit = false;
    @track isLabelChanges = false;
    @track readOnly = false;


    @track field = {
        Name: "",
        Email: "",
        Phone: "",
        Type: "",
        Industry: "",
        Rating: "",
        Id: "",
        Site: "",
        Address: ""
    }

    @track _type;

    @track _accountlist;
    @api
    set accountlist(value) {
        if (value.Id) {
            this._accountlist = value;
            this.field = this.value;
        }
    }

    get accountlist() {
        return this._accountlist;
    }

    @api
    set type(value) {
        this._type = value;
    }

    get type() {
        return this._type == 'Update';
    }

    get inputClass() {
        return this.errorMessage ? 'slds-has-error' : 'none';
    }

    connectedCallback() {
        // Example: Load picklist values for multiple fields
        if (this.omniJsonData?.editDetails) {
            this.field = { ...this.omniJsonData.editDetails }; // Clone the object to avoid mutation
            this.field.Id = this.omniJsonData.Account?.Id; // Safely assign Id
            if (this.field.Id) {
                this.readOnly = true;
            }
        }
        if (this.isreadonly) {
            this.readOnly = this.isreadonly;
            this.field = this.accountlist;
        }
        this.loadPicklistValues('Account', 'Type');
        this.loadPicklistValues('Account', 'Industry');
        this.loadPicklistValues('Account', 'Rating');
    }

    // // Regex for consecutive special characters
    // handleKeyPress(event) {
    //     const inputValue = event.target.value;
    //     const key = event.key;
    //     console.log('key :>> ', key);

    //     // 1. Define restricted characters (excluding '<SCRIPT'):
    //     const restrictedChars = /[#!%$^`~()*>"']/;

    //     // 2. Define restricted patterns (excluding '<SCRIPT'):
    //     const restrictedPatterns = /<(S\*SCRIPT|S\*DOCTYPE)|>/;

    //     const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;

    //     // 3. Check for restricted characters and patterns (excluding '<SCRIPT'):
    //     if (restrictedChars.test(key) || restrictedPatterns.test(key)) {
    //         this.errorMessage = 'Special characters are not allowed';
    //         // // this logic is for preventing the input of special characters
    //         // event.preventDefault();
    //         return; // Don't allow input
    //     }

    //     // 4. Prevent the first key from being a special character:
    //     const lastChar = inputValue[inputValue.length - 1];
    //     // if (key != '<' && inputValue.length === 0 && (restrictedChars.test(key) || specialChars.test(key))) {
    //     //     event.preventDefault();
    //     //     return; // Don't allow special characters as the first input
    //     // }

    //     // if(key != 'S' && inputValue.length === 1 && lastChar === '<'){ 
    //     //     event.preventDefault();
    //     //     return; // Don't allow 'S' after '<'
    //     // }
    //     // // 5. Check for invalid combinations with '<':
    //     // if (key === '<' &&
    //     //     (inputValue.endsWith('<') ||
    //     //         inputValue.endsWith(' ') && inputValue.slice(-6) === '<SCRIPT') ) {
    //     //     event.preventDefault();
    //     //     return; // Don't allow '<' followed by space and "<SCRIPT>"
    //     // }


    //     // 6. Check for consecutive special characters (excluding '.' and ','):

    //     if (specialChars.test(lastChar) && specialChars.test(key) && !/[0-9a-zA-Z]/.test(key)) {
    //         this.errorMessage = 'Consecutive special characters are not allowed';
    //         // // this logic is for preventing the input of special characters
    //         // event.preventDefault();
    //         return; // Prevent consecutive special characters (except '.' and ',')
    //     }

    //     // 7. Check for repeated '.' or ',':
    //     if ((key === '.' || key === ',') && inputValue.endsWith(key)) {
    //         this.errorMessage = 'Repeated special characters are not allowed';
    //         // // this logic is for preventing the input of special characters
    //         // event.preventDefault();
    //         return; // Prevent repeated '.' or ','
    //     }
    //     // 8. Check for first character being a special character
    //     // Allow first character to be numeric, but prevent special characters
    //     if (inputValue.length === 0) {
    //         if (specialChars.test(key)) {
    //             this.errorMessage = 'The first character cannot be a special character';
    //             // // this logic is for preventing the input of special characters
    //             // event.preventDefault(); // Prevent input
    //             return;
    //         }
    //         if (!/[0-9a-zA-Z]/.test(key)) {
    //             this.errorMessage = 'The first character must be alphanumeric';
    //             // // this logic is for preventing the input of special characters
    //             // event.preventDefault(); // Prevent input
    //             return;
    //         }
    //     }
    //     this.errorMessage = '';

    // }

    // handleKeyPress(event) {
    //     const inputValue = event.target.value;
    //     const key = event.key;

    //     // 1. Define restricted characters (excluding '<SCRIPT'):
    //     const restrictedChars = /[#!%$^`~()*>"']/;

    //     // 2. Define restricted patterns (excluding '<SCRIPT'):
    //     const restrictedPatterns = /<(S\*SCRIPT|S\*DOCTYPE)|>/;

    //     // 3. Check for restricted characters and patterns (excluding '<SCRIPT'):
    //     if (restrictedChars.test(key) || restrictedPatterns.test(key)) {
    //       this.errorMessage = 'Special characters are not allowed.';
    //       event.preventDefault(); // Prevent input
    //       return;
    //     }

    //     // 4. Prevent the first character from being a special character:
    //     if (inputValue.length === 0 && (restrictedChars.test(key) || !/[0-9a-zA-Z]/.test(key))) {
    //       this.errorMessage = 'The first character must be alphanumeric.';
    //       event.preventDefault(); // Prevent input
    //       return;
    //     }

    //     // 5. Check for consecutive special characters (excluding '.' and ','):
    //     const lastChar = inputValue[inputValue.length - 1];
    //     const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;
    //     if (specialChars.test(lastChar) && specialChars.test(key)) {
    //       this.errorMessage = 'Consecutive special characters are not allowed.';
    //       event.preventDefault(); // Prevent input
    //       return;
    //     }

    //     // 6. Check for repeated '.' or ',':
    //     if ((key === '.' || key === ',') && inputValue.endsWith(key)) {
    //       this.errorMessage = 'Repeated "." or "," are not allowed.';
    //       event.preventDefault(); // Prevent input
    //       return;
    //     }

    //     // 7. (Optional) Check for invalid combinations with '<' (commented out):
    //     // if (key === '<' &&
    //     //     (inputValue.endsWith('<') ||
    //     //      (inputValue.endsWith(' ') && inputValue.slice(-6) === '<SCRIPT'))) {
    //     //   event.preventDefault();
    //     //   return; // Don't allow '<' followed by space and "<SCRIPT>"
    //     // }

    //     // Clear error message if no issues are found
    //     this.errorMessage = '';
    //   }
    handleKeyPress(event) {
        const inputValue = event.target.value;
        const key = event.key;
        console.log(key);
        // 1. Define restricted characters (excluding '<SCRIPT'):
        // const restrictedChars = /[#!%$^`~()*>".']/;
        // const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;
        // const lastChar = inputValue[inputValue.length - 1];
        // const notAlphNumeric = /[^a-zA-Z0-9]/g;

        // // 2. Check for restricted characters and patterns (excluding '<SCRIPT'):
        // if (restrictedChars.test(key)) {
        //     this.errorMessage = 'Special characters are not allowed.';
        //     event.preventDefault(); // Prevent input
        //     return;
        // }

        // // 3. Prevent the first character from being a special character:
        // if (inputValue.length === 0 && (restrictedChars.test(key) || !/[0-9a-zA-Z]/.test(key))) {
        //     this.errorMessage = 'The first character must be alphanumeric.';
        //     event.preventDefault(); // Prevent input
        //     return;
        // }
        // console.log('lastChar :>> ', lastChar);
        console.log('key %%%%:>> ', key);
        // // 4. Check for consecutive special characters (excluding '.' and ','):
        // console.log('notAlphNumeric.test(key)===',specialChars.test(lastChar) , specialChars.test(key), notAlphNumeric.test(key));
        // if (specialChars.test(lastChar) && specialChars.test(key)) {
        //     if (notAlphNumeric.test(key)) {
        //         this.errorMessage = 'Consecutive special characters are not allowed.';
        //         console.log('this.errorMessage',this.errorMessage);
        //         console.log('!/[0-9]/.test(key) ^^^^^@@@@:>> ', specialChars.test(lastChar), specialChars.test(key), notAlphNumeric.test(lastChar));
        //         // this.inputValue = inputValue.slice(0, -1); // Remove the last character
        //         event.preventDefault(); // Prevent input
        //         return;
        //     }
        // }


        // // Clear error message if no issues are found
        // this.errorMessage = '';
        // const inputValue = event.target.value;
        // const key = event.key;

        // // Define restricted characters (excluding '<SCRIPT' and '.' ',')
        // const restrictedChars = /[#!%$^`~()*>".']/; // Adjust as per requirements
        // const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;

        // const isNumeric = /[0-9]/.test(key);
        // // Prevent if key matches restricted characters
        // if (restrictedChars.test(key)) {
        //     this.errorMessage = 'Special characters are not allowed.';
        //     event.preventDefault();
        //     return;
        // }

        // // Prevent if the first character is a special character
        // if (inputValue.length === 0 && !/[a-zA-Z0-9]/.test(key)) {
        //     this.errorMessage = 'The first character must be alphanumeric.';
        //     event.preventDefault();
        //     return;
        // }

        // // Prevent consecutive special characters (excluding '.' and ',')
        // const lastChar = inputValue[inputValue.length - 1];
        // console.log('isNumeric :>> ', isNumeric);
        // const alphNumeric = /[a-zA-Z0-9]/i;
        // // console.log('alphNumeric.test(secondLast) && alphNumeric.test(lastChar) :>> ', alphNumeric.test(lastChar) && alphNumeric.test(key));
        // // console.log('specialChars.test(lastChar) && specialChars.test(key) :>> ', specialChars.test(lastChar) , specialChars.test(key) ,'"::::', (alphNumeric.test(lastChar) , alphNumeric.test(key) , isNumeric == false)); 
        // // if (specialChars.test(lastChar) && specialChars.test(key) && (alphNumeric.test(lastChar) && alphNumeric.test(key) && isNumeric == false)) {
        // //     this.errorMessage = 'Consecutive special characters are not allowed.';
        // //     event.preventDefault();
        // //     return;
        // // }
        // console.log('!/[a-zA-Z0-9]/.test(key) :>> ', !/[a-zA-Z0-9]/.test(key));
        // if (specialChars.test(key)) {
        //     if (specialChars.test(lastChar) && !/[a-zA-Z0-9]/.test(key)) {
        //         this.errorMessage = 'Consecutive special characters are not allowed.';
        //     } else {
        //         this.errorMessage = 'Special characters are not allowed.';
        //     }
        //     event.preventDefault();
        //     return;
        // }
        // // Clear error message if no issues are found
        // this.errorMessage = '';
    }



    handleBlur(event) {
        const field = event.target.dataset.field;

        if (field === 'Address') {

            const inputValue = event.target.value;
            const secondLast = inputValue[inputValue.length - 2];
            const lastChar = inputValue[inputValue.length - 1];
            const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;
            const alphNumeric = /[a-zA-Z0-9]/i;

            console.log('secondLast @@@@=====', secondLast);
            console.log(lastChar)
            console.log(specialChars.test(lastChar), (!specialChars.test(secondLast)), alphNumeric.test(secondLast), alphNumeric.test(secondLast), alphNumeric.test(lastChar), this.errorMessage != '')
            if (((specialChars.test(lastChar) && alphNumeric.test(secondLast)) || alphNumeric.test(secondLast) && alphNumeric.test(lastChar)) && this.errorMessage != '') {
                this.errorMessage = '';
            }
        }
    }



    // handleKeyPress(event) {
    //     const inputValue = event.target.value;
    //     const key = event.key;

    //     // 1. Define restricted characters (excluding '<SCRIPT'):
    //     const restrictedChars = /[#!%$^`~()*>"'<.]/;

    //     // 2. Define restricted patterns (excluding '<SCRIPT'):
    //     const restrictedPatterns = /<(S\*SCRIPT|S\*DOCTYPE)|>/;

    //     // 3. Check for restricted characters and patterns (excluding '<SCRIPT'):
    //     if (restrictedChars.test(key) || restrictedPatterns.test(key)) {
    //         event.preventDefault(); // Prevent input
    //         this.errorMessage = ''; // Clear error message immediately
    //         return;
    //     }

    //     const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;
    //     // 4. Prevent the first character from being a special character:
    //     if (inputValue.length === 0 && (restrictedChars.test(key) || (specialChars.test(key))) && !/[0-9a-zA-Z]/.test(key)) {
    //         this.errorMessage = 'The first character must be alphanumeric.';
    //         event.preventDefault(); // Prevent input
    //         return;
    //     }

    //     // 5. Check for consecutive special characters (excluding '.' and ','):
    //     const lastChar = inputValue[inputValue.length - 1];
    //     if (specialChars.test(lastChar) && specialChars.test(key) && !/[0-9a-zA-Z]/.test(key)) {
    //         this.errorMessage = 'Consecutive special characters are not allowed (except ".", ",").';
    //         event.preventDefault(); // Prevent input
    //         return;
    //     }

    //     // 6. Check for repeated '.' or ',':
    //     if ((key === '.' || key === ',') && inputValue.endsWith(key)) {
    //         this.errorMessage = 'Repeated "." or "," are not allowed.';
    //         event.preventDefault(); // Prevent input
    //         this.inputValue = inputValue.slice(0, -1); // Remove the last character
    //         return;
    //     }

    //     // Clear error message if no issues are found
    //     this.errorMessage = '';
    // }

    // handleKeyUp(event) {
    //     const field = event.target.dataset.field;
    //     if (field === 'Name') {
    //         const inputValue = event.target.value;
    //         const thirdLast = inputValue[inputValue.length];
    //         const secondLast = inputValue[inputValue.length - 2];
    //         const lastChar = inputValue[inputValue.length - 1];
    //         const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;
    //         console.log('object :>> ', specialChars.test(lastChar), !specialChars.test(secondLast), !specialChars.test(thirdLast), this.errorMessage != '');
    //         if (specialChars.test(lastChar) && !specialChars.test(secondLast) && !thirdLast && this.errorMessage != '') {
    //            this.errorMessage = '';
    //         }
    //         // for (let i = 0; i < inputValue.length - 1; i++) {
    //         //     const currentChar = inputValue[i];
    //         //     const nextChar = inputValue[i + 1];
    //         //     const specialChars = /[!@#$%^&*()_+={}\[\]\\|\/;<>`~'-:"?.,]/;

    //         //     if (specialChars.test(currentChar) && specialChars.test(nextChar) && currentChar !== '.' && currentChar !== ',') {
    //         //       this.errorMessage = 'Consecutive special characters are not allowed (except ".", ",").';
    //         //       return; // Prevent consecutive special characters (except '.' and ',')
    //         //     }
    //         //   }
    //     }
    // }

    renderedCallback() {
        pubsub.register('omniscript_action', {
            data: this.handleOmniAction.bind(this),
        });
        pubsub.register('omniscript_step', {
            data: this.handleOmniStepLoadData.bind(this),
        });
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
        let inputValue = event.target.value;
        if (field === 'Phone') {

            // Allow only numeric input and limit to 10 digits
            inputValue = inputValue.replace(/\D/g, ''); // Remove non-digit characters

            // If the input length is greater than 10, slice it to 10 digits
            if (inputValue.length > 10) {
                inputValue = inputValue.slice(0, 10); // Limit to 10 digits
            }

            // Set the input value with the valid numeric value
            event.target.value = inputValue;
            // Disable further input if 10 digits have been entered
            if (inputValue.length === 10) {
                event.preventDefault();
            }
        }
        console.log('field :>> ', field);
        // if (field === 'Name') {
        //     if (inputValue.length === 0) {
        //         this.errorMessage = ' ';
        //     }

        //     event.target.value = inputValue;
        //     const secondChar = inputValue[inputValue.length - 2];
        //     const lastChar = inputValue[inputValue.length - 1];
        //     // const specialChars = /[!@#$%^&*()_+={};
        //     console.log("lastChar@@@@@",lastChar);
        //     console.log('secondChar :>> ', secondChar);
        //     // 1. Define restricted characters (excluding '<SCRIPT'):
        //     const restrictedChars = /[#!%$^`~()*>".']/;
        //     // const specialChars = /[\!@#$%^&*()_+={}\[\]\\|\/;<>`~'\-:"?,.]/g;
        //     const specialChars = /^(?!.*[#!%$^~()<>*&'<\\s*SCRIPT\\b|S*DOCTYPE|'']).(?!.[!@#$%^&(),.?':;\"|`~<>{}\\]\\[\\-]{2}).$/;
        //     // const lastChar = inputValue[inputValue.length - 1];
        //     const notAlphNumeric = /[^a-zA-Z0-9]/g;

        //     // 2. Check for restricted characters and patterns (excluding '<SCRIPT'):
        //     if (restrictedChars.test(lastChar)) {
        //         this.errorMessage = 'Special characters are not allowed.';
        //         event.preventDefault(); // Prevent input
        //         return;
        //     }
        //     console.log('inputValue.length === 0 && (specialChars.test(lastChar) || notAlphNumeric.test(lastChar)) :>> ', inputValue.length , (specialChars.test(lastChar) , notAlphNumeric.test(lastChar)));
        //     // 3. Prevent the first character from being a special character:
        //     if (inputValue.length === 1 && (specialChars.test(lastChar) || notAlphNumeric.test(lastChar))) {
        //         this.errorMessage = 'The first character must be alphanumeric.';
        //         event.preventDefault(); // Prevent input
        //         return;
        //     }
        //     console.log('lastChar @@====:>> ', lastChar);
        //     // console.log('key :>> ', key);
        //     // // 4. Check for consecutive special characters (excluding '.' and ','):
        //     console.log('notAlphNumeric.test(key) %%%===',specialChars.test(lastChar) , specialChars.test(secondChar), notAlphNumeric.test(lastChar));
        //     console.log('specialChars.test(secondChar) =====:>> ', specialChars.test(secondChar));
        //     if (specialChars.test(lastChar) && specialChars.test(secondChar)) {
        //         console.log('notAlphNumeric.test(lastChar) ========:>> ', notAlphNumeric.test(lastChar));
        //         if (notAlphNumeric.test(lastChar)) {
        //             this.errorMessage = 'Consecutive special characters are not allowed.';
        //             console.log('this.errorMessage',this.errorMessage);
        //             console.log('!/[0-9]/.test(key) ^^^^^@@@@:>> ', specialChars.test(lastChar) , specialChars.test(secondChar), notAlphNumeric.test(lastChar));
        //             // this.inputValue = inputValue.slice(0, -1); // Remove the last character
        //             event.preventDefault(); // Prevent input
        //             return;
        //         }
        //     }


        //     // // Clear error message if no issues are found
        //     this.errorMessage = '';
        // }
        if (field === 'Name') {
            const restrictedChars = /[#!%$^`~()*>".']/; // Restricted characters
            const specialChars = /^(?!.[#!%$^~()<>&'<\\s*SCRIPT\\b|S*DOCTYPE|'']).(?!.*[!@#$%^&(),.?':;\"|`~<>{}\\]\\[\\-]{2}).$/;
            const notAlphanumeric = /[^a-zA-Z0-9]/g; // Non-alphanumeric characters
        
            const inputValue = event.target.value;
            const lastChar = inputValue[inputValue.length - 1];
            const secondLastChar = inputValue[inputValue.length - 2];
        
            console.log("lastChar: ===", lastChar);
            console.log("secondLastChar: ", secondLastChar);
        
            // 1. Handle empty input
            if (inputValue.length === 0) {
                this.errorMessage = ' ';
                return;
            }
        
            // 2. Prevent restricted characters
            if (restrictedChars.test(lastChar)) {
                this.errorMessage = 'Special characters are not allowed.';
                event.preventDefault();
                return;
            }
        
            // 3. Prevent the first character from being a special character
            if (inputValue.length === 1 && notAlphanumeric.test(lastChar)) {
                this.errorMessage = 'The first character must be alphanumeric.';
                event.preventDefault();
                return;
            }
        
            // 4. Prevent consecutive special characters
            if (notAlphanumeric.test(lastChar) && notAlphanumeric.test(secondLastChar)) {
                this.errorMessage = 'Consecutive special characters are not allowed.';
                event.preventDefault();
                return;
            }
        
            // 5. Clear error message if input is valid
            this.errorMessage = '';
            event.target.value = inputValue; // Update the input value
        }
        this.field[field] = inputValue;
        if (!this.type) {
            this.dispatchEvent(new CustomEvent('sendaccountdetails', {
                detail: { ...this.field }
            }));
        }
    }

    handleOmniAction(data) {
        console.log('handleOmniAction data :>> ', data);
        switch (data.name) {
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
        switch (data.name) {
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
        switch (data.type) {
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

    handleSubmit() {
        // Call OmniScript method to submit data
        if (this.type) {
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
                    this.isSuccess = res.result.IPResult.Account_1[0].UpsertSuccess;
                    if (this.isSuccess) {
                        this.readOnly = true;
                        this.showToast(
                            "Success",
                            `The record has been updated successfully.`,
                            "success"
                        );
                        this.field = { ...res.result.IPResult.Account_1[0] }
                        this.field.Email = res.result.IPResult.Account_1[0].Eamil_Address__c;
                        this.omniApplyCallResp(this.field);
                        // const newLocal = "standard__recordPage";
                        // this[NavigationMixin.Navigate]({
                        //     type: newLocal,
                        //     attributes: {
                        //         recordId: this.field.Id, // Record ID for navigation
                        //         objectApiName: 'Account', // Optional: specify the object API name
                        //         actionName: 'view' // Navigate to the record's detail page
                        //     },
                        // });
                    }
                }
            }).catch(error => {
                if (error) {
                    console.error('error **********======== :>> ', error);
                }
            });
        }
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

    blockNonNumeric(event) {
        // Prevent the default action if the key pressed is not a number
        const charCode = event.charCode || event.keyCode;
        if (charCode < 48 || charCode > 57) {
            event.preventDefault(); // Block any character that is not a number (0-9)
        }
    }

    validatePhone(event) {
        const phoneValue = event.target.value;
        const phoneRegex = /^\d{10}$/; // Regex for 10 digits

        if (!phoneRegex.test(phoneValue)) {
            // If invalid, show an error message
            event.target.setCustomValidity('Please enter a valid 10-digit phone number.');
        } else {
            event.target.setCustomValidity(''); // Clear error message if valid
        }

        event.target.reportValidity(); // Trigger the browser's built-in validation
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