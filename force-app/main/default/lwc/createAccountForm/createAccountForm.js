import { LightningElement, api, track } from 'lwc';
import InsertAccountRecord from '@salesforce/apex/AddDynamicContacts.InsertAccountRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPicklist from '@salesforce/apex/PicklistHelper.getPicklist';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateAccountForm extends NavigationMixin(LightningElement) {
    @track field = {
        Name: '',
        Phone: '',
        BillingStreet: '',
        BillingCity: '',
        BillingState: '',
        BillingPostalCode: '',
        BillingCountry: '',
        Email: '',
        IsActive: '',
        BirthDate: '',
        Type: '',
        files: []
    };

    @track options = {};
    @track previewUrls = [];
    @track suggestions = [];
    @api objectApiName;

    @track searchTerm = '';
    @track recordId = '';
    @track birthDateError = '';

    fileIdCounter = 0;
    @track isDragging = false;

    connectedCallback() {
        this.loadPicklistValues('Account', 'Type');
    }

    async loadPicklistValues(objectName, fieldName) {
        try {
            const data = await getPicklist({ objectName, fieldName });
            this.options = { ...this.options, [fieldName]: data };
        } catch (error) {
            console.error(`Error fetching picklist values for ${fieldName}:`, error);
        }
    }

    changeHandler(event) {
        const field = event.target.dataset.id;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;
        if (field === 'BirthDate') {
            const today = new Date();
            const selectedDate = new Date(value);
            const age = today.getFullYear() - selectedDate.getFullYear();
            const monthDiff = today.getMonth() - selectedDate.getMonth();
            const dayDiff = today.getDate() - selectedDate.getDate();
            if (age < 18 || (age === 18 && (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)))) {
                this.birthDateError = 'You must be at least 18 years old.';
            } else {
                this.birthDateError = '';
            }
        }
        this.field = { ...this.field, [field]: value };
    }

    validateFields() {
        const requiredFields = ['Name', 'Phone', 'Email', 'Type'];
        for (const field of requiredFields) {
            if (!this.field[field] || this.field[field].trim() === '') {
                console.error(`Field "${field}" is missing or invalid.`);
                return false;
            }
        }
        return true;
    }

    async handleSubmit(event) {
        if (!this.validateFields()) {
            this.showToast('Error', 'Validation failed: One or more required fields are missing.', 'error');
            return;
        }
        try {
            const result = await InsertAccountRecord({ jsonString: JSON.stringify(this.field) });
            if (result) {
                this.showToast('Success', 'Account created successfully.', 'success');
                this.recordId = result.Id;
                this.redirectToAccount(result.Id);
            }
        } catch (error) {
            this.showToast('Error', 'There was an issue creating the account.', 'error');
        }
    }

    redirectToAccount(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    handleFileSelect(event) {
        const selectedFiles = event.target.files;
        this.processFiles(selectedFiles);
    }

    async processFiles(fileList) {
        const uploadedFiles = await Promise.all(
            Array.from(fileList).map(async (file) => {
                const fileId = `file-${++this.fileIdCounter}`;
                const previewUrl = URL.createObjectURL(file);
                const base64Data = await this.convertBlobToBase64(file);
                return { id: fileId, name: file.name, size: file.size, type: file.type, previewUrl, base64Data };
            })
        );
        this.field.files = [...this.field.files, ...uploadedFiles];
    }

    convertBlobToBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onloadend = () => resolve(reader.result.split(',')[1]);
            reader.onerror = () => reject('Failed to read file');
            reader.readAsDataURL(file);
        });
    }

    handleRemoveFile(event) {
        const fileId = event.target.dataset.id;
        this.field.files = this.field.files.filter((file) => file.id !== fileId);
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(event);
    }
}
