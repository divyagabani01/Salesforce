import { LightningElement, track, wire } from 'lwc';
import searchAccountApex from '@salesforce/apex/AccountQuery.searchAccount';
import getTotalSearchAccount from '@salesforce/apex/AccountQuery.getTotalSearchAccount';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'BillingStreet', fieldName: 'BillingStreet', type: 'text' },
    { label: 'BillingCity', fieldName: 'BillingCity', type: 'text' },
    { label: 'BillingState', fieldName: 'BillingState', type: 'text' },
    { label: 'BillingCountry', fieldName: 'BillingCountry', type: 'text' },
];

export default class SearchableAccountName extends LightningElement {
    @track recordData = [];
    @track columns = columns;
    @track searchValue = '';
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalPages = 1;
    @track totalRecords = 0;
    @track pageSizeOptions = [10, 25, 50, 75, 100];
    @track loading = false;

    // Wire to get accounts for the current page
    @wire(searchAccountApex, { searchText: '$searchValue', pageNumber: '$pageNumber', pageSize: '$pageSize' })
    wiredsearchAccount({ error, data }) {
        if (data) {
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
        //this.pageSize=event.target.value;
        //  this.pageSize = event.detail.value; // Set the new page size
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
}