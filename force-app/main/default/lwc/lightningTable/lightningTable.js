import { api, LightningElement, track } from 'lwc';

export default class LightningTable extends LightningElement {
    @track searchValue = '';
    @track _tableData = [];
    @track columns = [];
    @track loading = false;

    @api
    set loading(value) {
        this.loading = value;// Recalculate pagination when data changes
    }

    get loading() {
        return this.loading;
    }
    @api
    set tabledata(value) {
        this._tableData = value;// Recalculate pagination when data changes
    }

    get tabledata() {
        return this._tableData;
    }

    @api
    set columns(value) {
        this.columns = value;
    }

    get columns() {
        return this.columns;
    }

    handleChange(event) {
        this.searchValue = event.target.value;
        this.dispatchEvent(new CustomEvent('updatevalue', {
            detail: this.searchValue
        }));
    }

    handleRowAction(event) {
        console.log('Event details:', event);
        console.log('Action name:', event.detail.action.name);
    
        // Extract relevant details
        const actionName = event.detail.action.name;
        const rowData = event.detail.row;
    
        // Dispatch a structured custom event with only the necessary data
        this.dispatchEvent(new CustomEvent('handlerowaction', {
            detail: event.detail
        }));
    }
    
    handleInputChange(event) {
        console.log('BEFORE this.field :>> ', this.field);
        console.log('event :>> ', event);
        const field = event.target.fieldName;
        const value = event.target.value;
        this.field[field] = value;
        console.log('AFTER this.field :>> ', this.field);
    }



    // handleRecordsPerPage(event) {
    //     this.pageSize = parseInt(event.target.value, 10);
    //     this.pageNumber = 1; // Reset to first page on page size change
    //     this.paginationHelper();
    // }

    // previousPage() {
    //     if (this.pageNumber > 1) {
    //         this.pageNumber -= 1;
    //         this.paginationHelper();
    //     }
    // }

    // nextPage() {
    //     if (this.pageNumber < this.totalPages) {
    //         this.pageNumber += 1;
    //         this.paginationHelper();
    //     }
    // }

    // firstPage() {
    //     this.pageNumber = 1;
    //     this.paginationHelper();
    // }

    // lastPage() {
    //     this.pageNumber = this.totalPages;
    //     this.paginationHelper();
    // }

    // paginationHelper() {
    //     this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    //     if (this.pageNumber < 1) {
    //         this.pageNumber = 1;
    //     } else if (this.pageNumber > this.totalPages) {
    //         this.pageNumber = this.totalPages;
    //     }
    //     this.recordsToDisplay = this.tabledata.slice(
    //         (this.pageNumber - 1) * this.pageSize,
    //         this.pageNumber * this.pageSize
    //     );
    // }

    get hasData() {
        return this.tabledata && this.tabledata.length > 0;
    }

    // get disableFirst() {
    //     return this.pageNumber <= 1;
    // }

    // get disableLast() {
    //     return this.pageNumber >= this.totalPages;
    // }
}