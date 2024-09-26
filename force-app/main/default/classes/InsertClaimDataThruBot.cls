public with sharing class InsertClaimDataThruBot {

    public class ClaimInput{
        @invocableVariable(label='Input PayerName')
        public string payerName;

        @invocableVariable(label='Input ClaimAmount')
        public decimal claimAmount;
    }

    @InvocableMethod(label='Submit Claim')
    public static List<String> insertClaimDataMethod(List<ClaimInput> clmInpList){
            System.debug('I am in the Apex class');
            List<String> claimNumList = new List<String>();
            for(ClaimInput cI : clmInpList){
                UUID randomUUID = UUID.randomUUID();
                String id = randomUUID.toString();
                String claimNumber = 'CLM-' + id;


                ClaimHeader__x clmhead = new ClaimHeader__x();
                clmhead.ClaimAmount__c = cI.claimAmount;
                clmhead.PayerName__c = cI.payerName;
                clmhead.Id__c = id;
                clmhead.ClaimNumber__c = claimNumber;
                clmhead.ClaimStatus__c = 'Draft';
                clmhead.SubmittedOn__c = System.now();
                clmhead.payerId__c = [select Id from Account where name =: cI.payerName limit 1].Id;
                System.debug('The submitted date :' +clmhead.SubmittedOn__c);
                
                Database.SaveResult[] saveResultRecords = new List<Database.SaveResult>();
                saveResultRecords.add(Database.insertImmediate(clmhead));
                for(Database.SaveResult sr : saveResultRecords){
                    if(sr.isSuccess()){
                        System.debug('Successfully inserted record in external object');
                        claimNumList.add(claimNumber);
                    }
                    else{
                        for(Database.Error err : sr.getErrors()){
                            System.debug('The following error has occured');
                            System.debug(err.getStatusCode()+ ' : ' +err.getMessage()) ;
                            System.debug('fields that affected this error: ' +err.getFields());
                        }
                   
                }
                   
                }

                

            }
            return claimNumList;
     

}
}