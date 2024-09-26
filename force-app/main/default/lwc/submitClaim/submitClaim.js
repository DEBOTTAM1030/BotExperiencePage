import { LightningElement, api, track } from 'lwc';
import insertClaimDataMethod from '@salesforce/apex/InsertClaimData.insertClaimDataMethod';

export default class SubmitClaim extends LightningElement {
    @track claimAmount;
    @track payerName;
    Id;
    claimNumber;
    

    handleClaimAmount(event){
     this.claimAmount = event.target.value;
     console.log('Claim Amount: ' + this.claimAmount);
    }

    handlePayerName(event){
        this.payerName = event.target.value;
        console.log('Payer name:' + this.payerName);
    }

    handleClaimSubmit(){
        console.log('Claim Amount: ' + this.claimAmount);
              //validate input
            if(!this.claimAmount || !this.payerName){
                alert("Please enter a claim amount and payer name");
                return;                
            }
            
            //Generate claim Number
            this.Id = this.generateClaimId();
            this.claimNumber = this.generateClaimNumber();

            console.log('Claim number:' + this.claimNumber);

            //Call Apex method to insert data
            insertClaimDataMethod({
                claimAmount : this.claimAmount,
                payerName : this.payerName,
                Id : this.Id,
                claimNumber : this.claimNumber
            }).then(result => {
                // Handle success
                console.log('Record created: ', result);
                alert('Claim record is created');
            })
            .catch(error => {
                // Handle error
                console.error('Error creating record: ', error);
            });

    }

    generateClaimNumber(){
        this.claimNumber = "CLM-" + Math.floor(Math.random() * (9999 - 1000 + 1) + 1000);
        return this.claimNumber;
    }

    generateClaimId(){
        this.Id = Math.floor(Math.random() * (9999 - 1000 + 1) + 1000);
        return this.Id;
    }
}