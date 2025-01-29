import { LightningElement, api, wire } from 'lwc';
import getProductById from '@salesforce/apex/ProductController.getProductById';

export default class Detail extends LightningElement {
    @api recordId;  // Product ID received from parent component
    product;        // Holds product data
    error;          // Holds error message if any

    connectedCallback() {
        console.log('Record ID:', this.recordId);
    }
    // Use wire to fetch product details when productId changes
    @wire(getProductById, { productId: '$recordId' })
    wiredProduct({ data, error }) {
        if (data) {
            console.log('data :>> ', data);
            this.product = data;
            this.error = undefined;
        } else if (error) {
            this.product = undefined;
            this.error = error;
        }
    }
}