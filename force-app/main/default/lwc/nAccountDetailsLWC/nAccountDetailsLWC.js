import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';

export default class NAccountDetailsLWC extends OmniscriptBaseMixin(LightningElement) {
    @api recordId; // Passed from OmniScript
    accountDetails; // Store account details
    error;

    connectedCallback() {
        // Load data when the step initializes
        this.handleOmniStepLoadData();
    }

    handleOmniStepLoadData() {
        const inputParams = { AccountId: this.recordId };
        this.omniRemoteCall({
            sClassName: 'omnistudio.IntegrationProcedureService',
            sMethodName: 'NAccountwithLWCIP',
            input: JSON.stringify(inputParams),
            options: '{}',
            extra: '{}',
        })
            .then((response) => {
                this.accountDetails = response.result.AccountDetails;
            })
            .catch((err) => {
                this.error = `Error loading data: ${err.message}`;
            });
    }

    handleOmniAction() {
        // Trigger an action programmatically
        this.handleOmniStepLoadData();
    }

    handleIPActionPubsubEvents(event) {
        if (event.detail) {
            const { result, error } = event.detail;
            if (result) {
                this.accountDetails = result.AccountDetails;
            } else if (error) {
                this.error = `Error: ${error.message}`;
            }
        }
    }
}