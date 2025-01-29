import { LightningElement, api } from 'lwc';
import commonModal from "c/commonModal";

export default class LifecycleExample extends LightningElement {

    @api recordId;

    // Constructor
    // This is the first method to be called when the component is created.
    constructor() {
        super(); // Always call super() first to ensure the element is initialized properly.
        console.log('LifecycleExample: Constructor');
    }

    // connectedCallback
    // This method is called when the component is inserted into the DOM.
    connectedCallback() {
        console.log('LifecycleExample: Connected Callback');
        // Perform setup operations such as fetching data or initializing variables.
        if (this.recordId) {
            console.log('Record ID is available:', this.recordId);
            // You might fetch record data here.
        }
    }

    // renderedCallback
    // This method is called each time the component is rendered.
    renderedCallback() {
        console.log('LifecycleExample: Rendered Callback');
        // Perform post-render actions such as manipulating the DOM or setting up third-party libraries.
    }

    // disconnectedCallback
    // This method is called when the component is removed from the DOM.
    disconnectedCallback() {
        console.log('LifecycleExample: Disconnected Callback');
        // Perform cleanup operations such as removing event listeners.
    }

    async handleOpenModal() {
        try {
            let details= {
                data: [
                    { id: 1, label: 'Option 1',value : 'Option 1',
                      checked:'true'
                     },
                    { id: 2, label: 'Option 2',value : 'Option 2',
                        checked:'true' },
                    { id: 3, label: 'Option 3',value : 'Option 3',
                        checked:'true' },
                ],
                title: 'Edit',
                mode: 'Edit',
                label: 'Edit',
                variant: 'brand'
            };
            const modal = await commonModal.open({
                label: 'Modal Title',
                description: 'Modal Title with brief description',
                size: 'large',
                options: details

            });
            console.log('modal :>> ', JSON.stringify(modal));
            const data = JSON.stringify(modal);
            console.log('data :>> ', data.data);
            // if (modal.action === 'save') {
            //     console.log('Selected Option:', modal.selectedOption);
            // } else if (result.action === 'cancel') {
            //     console.log('Modal was canceled.');
            // }

        } catch (error) {
            console.error('Error opening modal:', error);
        }
    }


    // Error Boundary
    // This method catches errors in the component tree below this component.
    errorCallback(error, stack) {
        console.log('LifecycleExample: Error Callback');
        console.error('Error:', error);
        console.error('Stack:', stack);
    }

}