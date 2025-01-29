import { LightningElement, track, wire, api } from 'lwc';
import searchOpportunity from '@salesforce/apex/GetOpportunities.searchOpportunity';
import getTotalOpportunities from '@salesforce/apex/GetOpportunities.getTotalSearchOpportunities';
import updateOpportunityRecord from '@salesforce/apex/AddDynamicOpportunity.updateOpportunityRecord';
import deleteOpportunityRecord from '@salesforce/apex/AddDynamicOpportunity.deleteOpportunityRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const columns = [
    { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
    { label: 'Amount', fieldName: 'Amount', type: 'number', sortable: true, cellAttributes: { alignment: 'left' } },
    { label: 'Probability', fieldName: 'Probability', type: 'percent', sortable: true, cellAttributes: { class: 'slds-text-align_left' } },
    { label: 'Stage', fieldName: 'StageName', type: 'text', sortable: true },
    { label: 'Close Date', fieldName: 'CloseDate', type: 'date', sortable: true, cellAttributes: { class: 'slds-text-align_center' } },
    {
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Edit', name: 'edit' },
                { label: 'Delete', name: 'delete' },
                { label: 'View', name: 'view' }
            ]
        }
    }
];

export default class OpportunityTable extends LightningElement {
    @track recordData = [];
    @track columns = columns;
    @track searchValue = '';
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalPages = 1;
    @track totalRecords = 0;
    @track pageSizeOptions = [10, 25, 50, 75, 100];
    @track loading = false;
    @track isModalOpen = false;
    @track isEdit = false;
    @track isView = false;
    @track isDelete = false;
    @track isButtonVisible = false;
    @track field = {
        Name: '',
        Amount: '',
        CloseDate: '',
        Probability: '',
        StageName: '',
        Id: ''
    };

    @wire(searchOpportunity, { searchText: '$searchValue', pageNumber: '$pageNumber', pageSize: '$pageSize' })
    searchOpportunity({ error, data }) {
        if (data) {
            console.log('data :>> ', data);
            this.recordData = data;
            this.getTotalOpportunity();

            this.loading = false;
        } else {
            this.error = error;
            console.error('Error retrieving opportunities:', error);
            this.recordData = [];
            this.loading = false;
        }
    }

    getTotalOpportunity() {
        getTotalOpportunities({
            searchText: this.searchValue,
        })
            .then((result) => {
                console.log('Total Record ===== :>> ', result);
                this.totalRecords = result;
                this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            })
            .catch((error) => {
                console.error('Error fetching total accounts:', error);
            });
    }

    handleSearchData(event) {
        this.searchValue = event.detail;
    }

    handleRecordsPerPage(event) {
        this.pageSize = parseInt(event.target.value, 10);
    }

    previousPage() {
        this.pageNumber = Math.max(this.pageNumber - 1, 1);
        this.loading = true;
    }

    nextPage() {
        this.pageNumber = Math.min(this.pageNumber + 1, this.totalPages);
        this.loading = true;
    }

    firstPage() {
        this.pageNumber = 1;
    }

    lastPage() {
        this.pageNumber = this.totalPages;
    }

    get bDisableNext() {
        return this.pageNumber == this.totalPages;
    }

    get bDisablePrev() {
        return this.pageNumber == 1;
    }
    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    handleRowAction(event) {
        console.log('Parent Class event========== :>> ', event.detail);
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log('actionName :>> ', actionName);
        switch (actionName) {
            case 'edit':  // Trigger modal on the edit action
                this.handleOpenModal(row, actionName);  // Pass the row data if needed
                break;
            case 'delete':
                // Handle delete action
                this.handleOpenModal(row, actionName);
                break;
            case 'view':
                this.handleOpenModal(row, actionName);
                break;
            default:
        }
    }

    handleOpenModal(row, actionName) {
        console.log('actionName :>> ', actionName);
        console.log('row :>> ', row);
        this.isModalOpen = true;
        this.recordId = row.Id;
        this.isLoading = true;
        if (actionName === 'edit' || actionName === 'delete' || actionName === 'Active') {
            this.isEditOrDeleteAction = true;
        }
        switch (actionName) {
            case 'edit':  // Trigger modal on the edit action
                this.ModalButtonLabel = 'Update';
                this.ModalTitleLabel = 'Edit';
                this.recordId = row.Id;
                this.field = {
                    Name: row.Name || '',
                    Amount: row.Amount || '',
                    CloseDate: row.CloseDate || '',
                    Probability: row.Probability || '',
                    StageName: row.StageName || '',
                    Id: row.Id
                };
                this.isLoading = false;
                this.isEdit = true;
                this.isButtonVisible = true;
                break;
            case 'view':
                // Handle delete action
                this.isView = true;
                this.ModalButtonLabel = 'View';
                this.ModalTitleLabel = 'View';
                this.recordId = row.Id;
                this.field = {
                    Name: row.Name || '',
                    Amount: row.Amount || '',
                    CloseDate: row.CloseDate || '',
                    Probability: row.Probability || '',
                    StageName: row.StageName || '',
                    Id: row.Id
                };
                this.isLoading = false;
                this.isButtonVisible = false;
                break;
            case 'delete':
                // Handle delete action
                this.ModalButtonLabel = 'Delete';
                this.ModalTitleLabel = 'Delete';
                this.field.Id = row.Id;
                this.isDelete = true;
                this.isButtonVisible = true;
                this.isLoading = false;
                break;
            default:
        }
    }

    async saveChanges(event) {
        // Logic to save the updated account data (can call an Apex method if needed)
        const param = event.target.dataset.id;
        switch (param) {
            case 'Edit':  // Trigger modal on the edit action
                await this.handleUpdateOpportunity();
                this.isEdit = false;
                break;
                case 'Delete':
                // Handle delete action
                this.handleDeleteOpportunity();
                this.isDelete = false;
                break;
            default:
        }
        // Close the modal after saving
        this.isModalOpen = false;
    }

    async handleDeleteOpportunity() {
        const recordId = this.field.Id;

        deleteOpportunityRecord({ opportunityId: recordId })
            .then(() => {
                this.showToast('Success', 'Opportunity deleted', 'success');
                window.location.reload();
                this.isModalOpen = false;
                this.isDelete = false;
                // Refresh the data or handle other post-delete actions
            })
            .catch((error) => {
                this.showToast('Error deleting record', error.body.message, 'error');
            });
    }

    @api async handleUpdateOpportunity() {
        try {
            // Call the Apex method (replace with your actual Apex function call)
            await updateOpportunityRecord({ jsonString: JSON.stringify(this.field) });
            this.showToast('Success', 'Opportunity updated successfully.', 'success');
            window.location.reload(); // Reload page if needed
            this.isModalOpen = false;
            this.isEdit = false;
        } catch (error) {
            // Handle the error properly
            // Show a toast for user-friendly error reporting
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleInputChange(event) {
        console.log('BEFORE this.field :>> ', this.field);
        console.log('event :>> ', event);
        const field = event.target.fieldName;
        const value = event.target.value;
        this.field[field] = value;
        console.log('AFTER this.field :>> ', this.field);
    }

    closeModal() {
        this.isModalOpen = false;
        this.isView = false;
        this.isEdit = false;
        this.isDelete = false;
        this.isActive = false;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        })
        this.dispatchEvent(event);
    }
}