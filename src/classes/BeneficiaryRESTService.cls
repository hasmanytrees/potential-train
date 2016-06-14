/******************************************************************************
Name             : BeneficiaryRESTService
Description      : This REST webservice is used to create beneficiary Account 
                from CI            
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/08/2015            Modified for code re-factoring 
                                            & optimization
******************************************************************************/
@RestResource(urlMapping='/beneficiaries')
global class BeneficiaryRESTService{

    /**
    * Method name  : getBeneficiary
    * Description  : Use this method to get new Beneficiary from CI
                    
    *                
    * Return Type  : void
    * Parameter    : Void
    **/  
    @HttpGet
    global static void getBeneficiary() 
    {
        try
        {
            
            String sBeneficiaryId= 
            RestContext.request.params.get(System.Label.BeneficiaryId); 
            RestContext.response.addHeader('Content-Type', 'application/json');
            List<Account> lstBeneficiaryRetrieved=new List<Account>();
            
            //SOQL Query to get all Contact Related to that Account
            if(sBeneficiaryId!=null)
            { 
                lstBeneficiaryRetrieved=[select Id,First_Name__c,Name,Status__c,Birthdate__c,Gender__c,
                BEN_Age__c,Primary_Language__c, Last_Correspondence_Date__c, 
                BEN_Sponsorship_Status__c,BEN_Id__c, BEN_Local_Id__c,Compass_Child_Key__c,
                ICP__c, BEN_Country__c from Account where id = :sBeneficiaryId];
            }
            
            if(lstBeneficiaryRetrieved.size()==0)
            {        
                RestContext.response.statusCode = 200 ;
                return ;
            }
            else
            {
                
                Map<String,List<sObject>> mapOutput= 
                new Map<String,List<sObject>>();
                
                mapOutput.put('BeneficiaryGroup',lstBeneficiaryRetrieved);
                //Getting Final JSON String
                String sResponse=
                JSONHandlerMethods.serialize(mapOutput,
                'BeneficiaryProcess'); 
                sResponse=sResponse.replace('"null"', 'null');
                RestContext.response.addHeader('Content-Type', 'application/json');
                // Sending the response back
                RestContext.response.responseBody = Blob.valueOf(sResponse); 

            }
        }
        catch(Exception ex)
        {
            RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration
            ('500',ex.getMessage()+'\n'+ex.getStackTraceString(),
            'BeneficiaryRESTService','Integration','getBeneficiary'
            ,'Inbound Call',URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/apexrest/'+RestContext.request.requestURI+'?'
            + Utility.retrieveRESTParameters
            (RestContext.request.params.keyset()),
            UserInfo.getUserId(),'getBeneficiary');
            
        }  
    } 
    
}