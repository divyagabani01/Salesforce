import { LightningElement, track, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import COUNT_UPDATED_CHANNEL from '@salesforce/messageChannel/Count_Updated__c';

export default class Counts extends LightningElement {
    @track counter = 0;
    @track priorCount = 0;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        console.log('calling connectedCallback');
        if (!this.subscription) {
            this.subscribeToMessageChannel();
        }
    }

    subscribeToMessageChannel() {
        // Create a unique identifier for this subscription
        const subscriptionId = `subscription_${Math.random().toString(36).substring(2, 15)}`;
        console.log('subscriptionId:', subscriptionId);
        // Store the subscription in a Map to track it
        // this.subscriptions = this.subscriptions || new Map();
        console.log('this.subscription :>> ', this.subscription);
        if (!this.subscription) { // Check for existing subscription
            this.subscription = subscribe(
                this.messageContext,
                COUNT_UPDATED_CHANNEL,
                (message) => this.handleMessage(message)
            );
        }
    }

    handleMessage(message) {
        this.priorCount = this.counter;
        console.log('message :>> ', message);
        console.log(' message.constant :>> ',  message.constant);
        switch (message.operator) {
            case 'add':
                console.log('calling add from child');
                this.counter += message.constant;
                break;
            case 'subtract':
                console.log('calling subtract from child');
                this.counter -= message.constant;
                break;
            case 'multiply':
                console.log('calling multiply from child',this.counter);
                this.counter *= message.constant;
                console.log('After calling multiply from child',this.counter);
                break;
            default:
                console.warn('Invalid operator:', message.operator);
        }
    }

    disconnectedCallback() {
        // Unsubscribe from all stored subscriptions
        console.log('calling disconnectedCallback');
        if (this.subscriptions) {
            this.subscriptions.forEach((subscription) => {
                subscription.unsubscribe();
            });
        }
    }
}