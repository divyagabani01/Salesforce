import { LightningElement, track, wire, api } from 'lwc';
import searchAccountApex from '@salesforce/apex/AccountQuery.searchAccount';
import getTotalSearchAccount from '@salesforce/apex/AccountQuery.getTotalSearchAccount';
import updateAccountRecord from '@salesforce/apex/AddDynamicContacts.updateAccountRecord';
import deleteAccountRecord from '@salesforce/apex/AddDynamicContacts.deleteAccountRecord';
import ActiveAccount from '@salesforce/apex/AddDynamicContacts.ActiveAccount';
import { publish } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    {
        label: 'Account Name',
        fieldName: 'Name',
        type: 'text'
    }, {
        label: 'Type',
        fieldName: 'Type',
        type: 'text'
    }, {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone'
    }, {
        label: 'Website',
        fieldName: 'Website',
        type: 'url'
    },
    {
        label: 'Active',
        fieldName: 'Active__c',
        type: 'text'
    },
    {
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Edit', name: 'edit' },
                { label: 'View', name: 'view' },
                { label: 'Delete', name: 'delete' },
                { label: 'Active', name: 'Active' }
            ]
        }
    }
]

export default class DataTable extends LightningElement {
    @track Name = '';
    @track recordId = '';
    @track recordData = [];
    @track ModalButtonLabel = '';
    @track ModalTitleLabel = '';
    @track columns = columns;
    @track error;
    @track isModalOpen = false;
    @track isEdit = false;
    @track isDelete = false;
    @track isView = false;
    @track isActive = false;
    @track isLoading = true;
    @track isEditOrDeleteAction = false;
    @track field = {
        Name: '',
        Type: '',
        Phone: '',
        Website: '',
        Id: '',
        Active__c: ''
    };
    @track searchValue = '';
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalPages = 1;
    @track totalRecords = 0;
    @track pageSizeOptions = [10, 25, 50, 75, 100];
    // This method is triggered when the form has finished loading
  
    @wire(searchAccountApex, { searchText: '$searchValue', pageNumber: '$pageNumber', pageSize: '$pageSize' })
    wiredsearchAccount({ error, data }) {
        if (data) {
            console.log('data INWIRE SEARCH =====:>> ', data);
            this.recordData = data;
            this.getTotalAccount();
            this.loading = false;
        } else if (error) {
            this.recordData = [];
            this.loading = false;
            console.error('Error retrieving accounts:', error);
        }
    }



    // Handle search input
    handleSearch(event) {
        this.searchValue = event.detail.value.toString();
        if (this.searchValue.length > 3) {
            this.pageNumber = 1;
        } else if (this.searchValue.length === 0) {
            this.pageNumber = 1;
        }
    };

    getTotalAccount() {
        getTotalSearchAccount({
            searchText: this.searchValue,
        })
            .then((result) => {
                this.totalRecords = result;
                this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
                console.log('result Total :>> ', result);
            })
            .catch((error) => {
                console.error('Error fetching total accounts:', error);
            });

    }

    // Handle click on first page button
    firstPage() {
        if (this.pageNumber > 1)
            this.pageNumber = 1;

    }

    // Handle click on previous page button
    previousPage() {
        if (this.pageNumber > 1)
            this.pageNumber -= 1;

    }

    // Handle click on next page button
    nextPage() {
        if (this.pageNumber < this.totalPages)
            this.pageNumber += 1;

    }

    // Handle click on last page button
    lastPage() {
        if (this.pageNumber < this.totalPages)
            this.pageNumber = this.totalPages;

    }

    // Handle records per page change
    handleRecordsPerPage(event) {
        if (event.target.value <= this.totalRecords)
            this.pageSize = event.target.value;
        else
            this.pageSize = this.totalRecords;
        this.pageNumber = 1; // Reset to the first page whenever the page size changes
    }

    // Disable pagination buttons based on page number
    get bDisableFirst() {
        return this.pageNumber === 1;
    }

    get bDisableLast() {
        return this.pageNumber === this.totalPages;
    }

    get bDisablePrev() {
        return this.pageNumber === 1;
    }

    get hasData() {
        return this.recordData.length > 0;
    }


    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
     
        switch (actionName) {
            case 'edit':  // Trigger modal on the edit action
                this.handleOpenModal(row, actionName);  // Pass the row data if needed
                break;
            case 'delete':
                // Handle delete action
                this.handleOpenModal(row, actionName);
                break;
            case 'Active':
                this.handleOpenModal(row, actionName);
                break;
            case 'view':
                this.handleOpenModal(row, actionName);
                break;
            default:
        }
    }

    handleInputChange(event) {
        const field = event.target.fieldName;
        const value = event.target.value;
        this.field[field] = value;
    }

    closeModal() {
        this.isModalOpen = false;
        this.isView = false;
        this.isEdit = false;
        this.isDelete = false;
        this.isActive = false;
    }

    handleOpenModal(row, actionName) {
        this.isModalOpen = true;
        this.recordId = row.Id;
        this.isLoading = true;
        if(actionName === 'edit' || actionName === 'delete' || actionName === 'Active'){
            this.isEditOrDeleteAction = true;
        }
        switch (actionName) {
            case 'edit':  // Trigger modal on the edit action
                this.ModalButtonLabel = 'Update';
                this.ModalTitleLabel = 'Edit';
                this.recordId = row.Id;
                this.field = {
                    Name: row.Name || '',
                    Type: row.Type || '',
                    Phone: row.Phone || '',
                    Website: row.Website || '',
                    Active__c: row.Active__c || '',
                    Id: row.Id
                };
                this.isLoading = false;
                this.isEdit = true;
                break;
            case 'delete':
                // Handle delete action
                this.ModalButtonLabel = 'Delete';
                this.ModalTitleLabel = 'Delete';
                this.field.Id = row.Id;
                this.isDelete = true;
                this.isLoading = false;
                break;
            case 'view':
                // Handle delete action
                this.isView = true;
                this.ModalButtonLabel = 'View';
                this.ModalTitleLabel = 'View';
                this.recordId = row.Id;
                this.field = {
                    Name: row.Name || '',
                    Type: row.Type || '',
                    Phone: row.Phone || '',
                    Website: row.Website || '',
                    Active__c: row.Active__c || '',
                    Id: row.Id
                };
                this.isLoading = false;
                break;
            case 'Active':
                this.ModalButtonLabel = 'Active';
                this.ModalTitleLabel = 'Active';
                this.field.Id = row.Id;
                this.isActive = true;
                this.isLoading = false;
                break;
            default:
        }
    }

    // Respond to UI event by publishing message
    handleContactSelect(event) {
        const payload = { recordId: event.target.contact.Id };

        publish(this.messageContext, recordSelected, payload);
    }

    async saveChanges(event) {
        // Logic to save the updated account data (can call an Apex method if needed)
        const param = event.target.dataset.id;
        switch (param) {
            case 'Edit':  // Trigger modal on the edit action
                await this.handleUpdateAccount();
                this.isEdit = false;
                break;
            case 'Delete':
                // Handle delete action
                this.isDelete = false;
                this.handleDeleteAccount();
                break;
            case 'Active':
                this.isActive = false;
                this.handleActiveAccount('Yes', 'Account Activate');
                break;
            default:
        }
        // Close the modal after saving
        this.isModalOpen = false;
    }

    @api async handleUpdateAccount() {

        try {
            this.field.Active = this.field.Active__c;
            // Call the Apex method (replace with your actual Apex function call)
            await updateAccountRecord({ jsonString: JSON.stringify(this.field) });
            this.showToast('Success', 'Account updated successfully.', 'success');
            window.location.reload(); // Reload page if needed
            this.isModalOpen = false;
            this.isEdit = false;
        } catch (error) {
            // Handle the error properly
            // Show a toast for user-friendly error reporting
            this.showToast('Error', error.body.message, 'error');
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        })
        this.dispatchEvent(event);
    }

    async handleDeleteAccount() {
        const recordId = this.field.Id;

        deleteAccountRecord({ accountId: recordId })
            .then(() => {
                this.showToast('Success', 'Account deleted', 'success');
                window.location.reload();
                this.isModalOpen = false;
                this.isDelete = false;
                // Refresh the data or handle other post-delete actions
            })
            .catch((error) => {
                this.showToast('Error deleting record', error.body.message, 'error');
            });
    }

    deactiveAccount() {
        if (this.isActive) {
            this.handleActiveAccount('No', 'Account Deactivate');
            this.isActive = false;
        }
    }

    async handleActiveAccount(isActive, msg) {
        const recordId = this.field.Id;
        console.log('Active recordId :>> ', recordId);
        ActiveAccount({ accountId: recordId, Active: isActive })
            .then(() => {
                this.showToast('Success', msg, 'success');
                window.location.reload();
                this.isModalOpen = false;
                this.isActive = false;
                // Refresh the data or handle other post-delete actions
            })
            .catch((error) => {
                this.showToast('Error deleting record', error.body.message, 'error');
            });
    }

}