import { LightningElement,track } from 'lwc';

export default class TrackDecoratorsDemo extends LightningElement {
    @track fullName = {firstName:"",lastName:""};
    userFullName = '';
    isSubmit = false;

    changeHandler(event){
        const field = event.target.name;
        const value = event.target.value;
        this.fullName[field] = value;
        this.userFullName = this.fullName.firstName +' ' +this.fullName.lastName;
        console.log(this.fullName);
    }

    handleSubmit(){

        if(this.fullName.firstName != ''){
            this.isSubmit = true;
        }else{
            this.isSubmit = false
        }
    }

}