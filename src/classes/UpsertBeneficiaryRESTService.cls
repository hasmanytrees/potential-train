/******************************************************************************
Name             : UpsertBeneficiaryRESTService
Description      : This REST webservice is used to insert/update
                Beneficiary Records coming from Salesforce CI                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/08/2015            Created
Sumeet                 23/09/2015            Modified for code re-factoring 
                                            & optimization
******************************************************************************/

@RestResource(urlMapping='/upsertBeneficiary')
global class UpsertBeneficiaryRESTService{

    /**
    * Method name  : upsertBeneficiary
    * Description  : Use this method to insert/update Beneficiary 
    * Return Type  : void
    * Parameter    : JSON
    **/

    @HttpPost
    global static void upsertBeneficiary() 
    {
        RestRequest request = RestContext.request;
        try
        { 
            //Taking URL parameters
            RestContext.response.statusCode = 200; 
            RestContext.response.addHeader('Content-Type', 'application/json');
            List<Account> lstAccount = 
            (List<Account>)JSONHandlerMethods.deserialize
            (request.requestBody.toString().trim() ,'CreateUpdateBeneficiaryProcess');
            
            
            //SOQL Query to get all Contact Related to that Account
            String sRecordtypeId=Utility.getRecordType('Beneficiary','Account');
            List<Account> lstAccountFinal=new  List<Account>();
            for(Account oAccountVar: lstAccount ) {
                
                if((oAccountVar.Status__c!=null )&&(oAccountVar.Status__c.equalsIgnoreCase('Sponsored')))
                oAccountVar.Status__c='Active';
                else if((oAccountVar.Status__c!=null )&&(oAccountVar.Status__c.equalsIgnoreCase('Unsponsored')))
                oAccountVar.Status__c='Inactive';
                oAccountVar.Override_Account_Validation__c=true;
                oAccountVar.recordTypeId=sRecordtypeId;
            }
            
            lstAccountFinal.addAll(lstAccount);  
            upsert lstAccountFinal Compass_Child_Key__c;  
            
            RestContext.response.addHeader('Content-Type', 'application/json');
            // Sending the response back
            //RestContext.response.responseBody = Blob.valueOf(sResponse); // This will be added later as per discussion with client
            
        }
        catch(Exception ex){
            RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration
            ('500',ex.getMessage()+'\n'+ex.getStackTraceString(),
            'UpsertBenificiaryRESTService','Integration','UpsertBenificiaryRESTService'
            ,'Inbound Call',URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/apexrest/'+RestContext.request.requestURI+'?'
            + Utility.retrieveRESTParameters
            (RestContext.request.params.keyset()),
            UserInfo.getUserId(),'UpsertBenificiaryRESTService');
        }  
    }


}