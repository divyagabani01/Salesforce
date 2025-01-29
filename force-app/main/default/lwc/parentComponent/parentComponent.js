import { LightningElement } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import MY_MESSAGE_CHANNEL from '@salesforce/messagechannel/count_updated__c';

export default class ParentComponent extends LightningElement {
     @wire(MessageContext)
        messageContext;
        COUNT = 0;
        @api i = 0; // Counter variable
        isRunning = false; // Flag to prevent multiple executions
    
        handleOperation(messageToSend, sourceSystem) {
            if (this.isRunning) {
                console.log('Function is already running, skipping...');
                return;
            }
        
            this.isRunning = true;
        
            if (this.i === 0) {
                const payload = {
                    messageToSend,
                    sourceSystem
                };
                publish(this.messageContext, MY_MESSAGE_CHANNEL, payload);
                console.log(`calling ${messageToSend}`);
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