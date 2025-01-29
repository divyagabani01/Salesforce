import { LightningElement } from 'lwc';
import Opportunity_Object from '@salesforce/schema/Opportunity';
export default class RecordFrom extends LightningElement {
    objectApiName = Opportunity_Object;
}