import { api, LightningElement } from 'lwc';
import LightningModal from 'lightning/modal';

export default class CommonModal extends LightningModal {
    label = 'Default Title';
    description = 'Default Description';
    value = '';

    @api options;
    // You can define methods to handle button actions
    handleSave() {
        const radioGroup = this.template.querySelector('lightning-radio-group');
        console.log('radioGroup :>> ', radioGroup);
        this.selectedOption = radioGroup ? radioGroup.value : null;
        console.log('this.selectedOption :>> ', this.selectedOption);
        this.close({ action: 'save', data: this.selectedOption }); // Pass an object containing action type and selected option
    }


    handleCancel() {
        this.close({ action: 'cancel' });
    }
}