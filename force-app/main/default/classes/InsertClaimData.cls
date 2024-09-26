public with sharing class InsertClaimData {
    @AuraEnabled
    public static string insertClaimDataMethod(Decimal claimAmount, String payerName, String Id, String claimNumber){
        
            System.debug('I am in the Apex class');
            ClaimHeader__x clmhead = new ClaimHeader__x();
            clmhead.ClaimAmount__c = claimAmount;
            clmhead.PayerName__c = payerName;
            clmhead.Id__c = Id;
            clmhead.ClaimNumber__c = claimNumber;
            clmhead.payerId__c = [select Id from Account where name =: payerName limit 1].Id;
            
            Database.SaveResult[] saveResultRecords = new List<Database.SaveResult>();
            saveResultRecords.add(Database.insertImmediate(clmhead));
            for(Database.SaveResult sr : saveResultRecords){
                if(sr.isSuccess()){
                    System.debug('Successfully inserted record in external object');
                    
                }
                else{
                    for(Database.Error err : sr.getErrors()){
                        System.debug('The following error has occured');
                        System.debug(err.getStatusCode()+ ' : ' +err.getMessage()) ;
                        System.debug('fields that affected this error: ' +err.getFields());
                    }
               
            }
               
            }
     
   return 'Success';
}
}