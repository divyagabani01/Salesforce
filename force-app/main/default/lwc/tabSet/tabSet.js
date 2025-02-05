import { LightningElement,wire } from 'lwc';


export default class TabSet extends LightningElement {
    // subscription = null;
    // recordId;
    connectedCallback() {
        console.log('this.s ====:>> ',);
    }
    // @wire(MessageContext)
    // messageContext;
    //  // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    //  subscribeToMessageChannel() {
    //     if (!this.subscription) {
    //         this.subscription = subscribe(
    //             this.messageContext,
    //             recordSelected,
    //             (message) => this.handleMessage(message),
    //             { scope: APPLICATION_SCOPE }
    //         );
    //     }
    // }

    // unsubscribeToMessageChannel() {
    //     unsubscribe(this.subscription);
    //     this.subscription = null;
    // }

    // // Handler for message received by component
    // handleMessage(message) {
    //     console.log('message :>> ', message);
    //     this.recordId = message.recordId;
    // }

    // // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    // connectedCallback() {
    //     this.subscribeToMessageChannel();
    //     console.log('this.s :>> ', this.subscription);
    // }

    // disconnectedCallback() {
    //     this.unsubscribeToMessageChannel();
    // }
    
}