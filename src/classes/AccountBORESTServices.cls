/******************************************************************************
Name             : AccountBORESTServices
Description      : This REST webservice is used to Call to query all Account 
                   and related Contact for that Volunteer till that Time                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
******************************************************************************/
@RestResource(urlMapping='/getAccount')
global class AccountBORESTServices{

    @HttpGet
    global static void getAccountBO() {
     try{ 
        //Taking URL parameters
        String sAccountId= 
        RestContext.request.params.get(System.Label.personid); 
        RestContext.response.addHeader('Content-Type', 'application/json');
        List<Account> lstAccountRetrieved=new List<Account>();
        
        //SOQL Query to get all Contact Related to that Account
        if(sAccountId!=null)
        { 
            lstAccountRetrieved=[select Id,Type,Name,Legacy_Partner_Id__c ,
            Legacy_Supporter_Id__c from Account where Legacy_Partner_Id__c =:sAccountId 
            OR Legacy_Supporter_Id__c =:sAccountId];
        }
       
        if(lstAccountRetrieved.size()==0){        
            RestContext.response.statusCode = 200 ;
            return ;
        }
        else{
           
            Map<String,List<sObject>> mapOutput= 
            new Map<String,List<sObject>>();
            for(Account oAccountVar: lstAccountRetrieved){
                
                
                if(oAccountVar.Type==System.Label.AccountType_Individual){
                    //For Account Type is Individual
                    oAccountVar.Type=System.label.Person;                    
                }
                else{
                    //For Account Type is not Individual
                    //Organization
                    oAccountVar.Type=System.Label.AccountType_Organization;                    
                }
                
            }
            mapOutput.put('AccountBOResponseProcessGroup',lstAccountRetrieved);
            //Getting Final JSON String
            String sResponse=
            JSONHandlerMethods.serialize(mapOutput,
            System.Label.AccountBOResponseProcess); 
          
            RestContext.response.addHeader('Content-Type', 'application/json');
             // Sending the response back
            RestContext.response.responseBody = Blob.valueOf(sResponse); 

        }
      }
      catch(Exception ex){
             RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration
            ('500',ex.getMessage()+'\n'+ex.getStackTraceString(),
            'AccountBORESTServices','Integration','AccountBORESTServices'
            ,'Inbound Call',URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/apexrest/'+RestContext.request.requestURI+'?'
            + Utility.retrieveRESTParameters
            (RestContext.request.params.keyset()),
            UserInfo.getUserId(),'getAccountBO');
      }  
    }


}