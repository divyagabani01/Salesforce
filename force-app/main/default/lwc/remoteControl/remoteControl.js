import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import COUNT_UPDATED_CHANNEL from '@salesforce/messageChannel/Count_Updated__c';

export default class RemoteControl extends LightningElement {
    @wire(MessageContext)
    messageContext;
    COUNT = 0;
    @api i = 0; // Counter variable
    isRunning = false; // Flag to prevent multiple executions

    handleOperation(operator, constant) {
        if (this.isRunning) {
            console.log('Function is already running, skipping...');
            return;
        }
    
        this.isRunning = true;
    
        if (this.i === 0) {
            const payload = {
                operator,
                constant
            };
            publish(this.messageContext, COUNT_UPDATED_CHANNEL, payload);
            console.log(`calling ${operator}`);
        }
    
        this.i += 1;
    
        setTimeout(() => {
            this.isRunning = false;
            this.i = 0;
            console.log('this.i :>> ', this.i);
        });
    }
    
    @api
    handleIncrement() {
        this.handleOperation('add', 1);
    }
    
    @api
    handleDecrement() {
        this.handleOperation('subtract', 1);
    }
    
    @api
    handleMultiply() {
        this.handleOperation('multiply', 2);
    }
    
}