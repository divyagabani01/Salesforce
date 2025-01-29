import { LightningElement, track } from 'lwc';
import getContactAndOpportunityDetails from '@salesforce/apex/InsertDynamicAccountsAndContact.getContactAndOpportunityDetails';

const parentColumns = [
    {
        label: 'Name',
        fieldName: 'Name',
        sortable: true,
        type: 'text',
    },
    {
        label: 'Account Number',
        fieldName: 'AccountNumber',
        sortable: true,
        type: 'text',
    },
    {
        label: 'Site',
        fieldName: 'Site',
        sortable: false,
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'Site' },
            target: '_blank',
        },
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        sortable: true,
        type: 'phone',
    },
    {
        label: 'Rating',
        fieldName: 'Rating',
        sortable: true,
        type: 'text',
    },
    // {
    //     type: 'action',
    //     typeAttributes: {
    //         rowActions: [
    //             { label: 'Edit', name: 'edit' },
    //             { label: 'View', name: 'view' },
    //             { label: 'Delete', name: 'delete' },
    //             { label: 'Active', name: 'Active' }
    //         ]
    //     }
    // }
];

const childColumns = [
    {
        label:'Id',
        fieldName:'Id',
        sortable:true,
        type:'text',
    },
    {
        label: 'Name',
        fieldName: 'Name',
        sortable: true,
        type: 'text',
    },
    {
        label: 'Account Number',
        fieldName: 'AccountNumber',
        sortable: true,
        type: 'text',
    },
    {
        label: 'Site',
        fieldName: 'Site',
        sortable: false,
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'Site' },
            target: '_blank',
        },
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        sortable: true,
        type: 'phone',
    },
    {
        label: 'Rating',
        fieldName: 'Rating',
        sortable: true,
        type: 'text',
    }
];

const contactList = [
    {
        label:'Id',
        fieldName:'Id',
        sortable:true,
        type:'text',
    },
    {
        label: 'Name',
        fieldName: 'Name',
        sortable: true,
        type: 'text',
    },
{
    label:'Email',
    fieldName:'Email',
    sortable:true,
    type:'email'
}
];
export default class TreeGrid extends LightningElement {
    @track gridColumns = parentColumns;
    @track gridData;
    @track gridExpandedRows = [];
    @track gridLoadingState = true;

    // Assuming childrenData will be fetched or constructed here
    childrenData = {};

    connectedCallback() {
        getContactAndOpportunityDetails()
            .then(result => {
                this.gridData = this.processResult(result);
                console.log('this.gridData :>> ', this.gridData);
                this.gridLoadingState = false;
            })
            .catch(error => {
                console.error('Error:', JSON.stringify(error));
                this.gridLoadingState = false;
            });
    }

    processResult(result) {
        return result.map(res => {
            let data = { ...res };
            data._children = [];
            if (res.Contacts && res.Contacts.length > 0) {
                data._children.push({
                    Id: res.Id + '-contacts',
                    Name: 'Contacts',
                    _children: res.Contacts,
                    columns: contactList  // Apply child columns
                });
            }
    
            if (res.Opportunities && res.Opportunities.length > 0) {
                data._children.push({
                    Id: res.Id + '-opportunities',
                    Name: 'Opportunities',
                    _children: res.Opportunities,
                    columns: childColumns  // Apply child columns
                });
            }
    
            if (data._children.length === 0) {
                delete data._children;
            } else {
                this.childrenData[res.Id] = data._children;
            }
            return data;
        });
    }

    handleRowToggle(event) {
        // retrieve the unique identifier of the row being expanded
        const rowName = event.detail.name;

        // does the component have children content for this row already?
        const hasChildrenContent = event.detail.hasChildrenContent;

        if (hasChildrenContent === false) {
            this.gridLoadingState = true;

            // call a method to retrieve the updated data tree that includes the missing children
            this.retrieveUpdatedData(rowName).then((newData) => {
                this.gridData = newData;
                this.gridLoadingState = false;
            });
        }
    }

    retrieveUpdatedData(rowName) {
        return new Promise((resolve) => {
            // mimic server delay
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            window.setTimeout(() => {
                // add children to data
                const updatedData = this.addChildrenToRow(
                    this.gridData,
                    rowName,
                    this.childrenData[rowName]
                );

                resolve(updatedData);
            }, 200);
        });
    }

    addChildrenToRow(data, rowName, children) {
        const newData = data.map((row) => {
            let hasChildrenContent = false;
            if (
                // eslint-disable-next-line no-prototype-builtins
                row.hasOwnProperty('_children') &&
                Array.isArray(row._children) &&
                row._children.length > 0
            ) {
                hasChildrenContent = true;
            }

            if (row.Id === rowName) {
                row._children = children;
                row.columns = childColumns;  // Apply child columns
            } else if (hasChildrenContent) {
                this.addChildrenToRow(row._children, rowName, children);
            }

            return row;
        });

        return newData;
    }
}