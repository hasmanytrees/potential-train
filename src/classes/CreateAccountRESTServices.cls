/******************************************************************************
    Name             : CreateAccountRESTServices
    Description      : This REST webservice is used to Call to query all Slot 
                       for that Volunteer till that Time.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                         optimization
Apurva                 12/10/2015        Changes made for INC0066920   
*****************************************************************************/
@RestResource(urlMapping='/createAccount')
global class CreateAccountRESTServices
{
    //Constructor
    @HttpPost
    global static void  createAccount() {
        RestRequest request = RestContext.request;
        try{
            
            RestContext.response.statusCode = 200; 
            
            List<Account> lstAccount = 
            (List<Account>)JSONHandlerMethods.deserialize
            (request.requestBody.toString().trim() ,'SupporterProcess');
            List<Account> lstAccountFinal=new List<Account>();
            Map<String,Account> mapLegacyIdAccount=new Map<String,Account>();
            for(sObject oSObjVar: lstAccount){
                oSObjVar.put('dupcheck__dc3DisableDuplicateCheck__c',true);
                //Ignoring dupe check
                lstAccountFinal.add((Account)oSObjVar);
                if(oSObjVar.get('Legacy_Supporter_Id__c')!=null)
                mapLegacyIdAccount.put(String.valueOF(oSObjVar.get('Legacy_Supporter_Id__c')),(Account)oSObjVar);
            }

            Utility.bRecursive=true;
            try{
              
               List<Account> lstAccountEmailCheck=new List<Account>();
               lstAccountEmailCheck=[select Id,Undeliverable_Invalid__c,Legacy_Supporter_Id__c from Account where Legacy_Supporter_Id__c IN :mapLegacyIdAccount.keySet()];
               
               for(Account oAccountVar: lstAccountEmailCheck){
                
                  String sUndeliveredEmailType='';  
                  Set<String> setFinalEmailType=new Set<String>();
                  if(mapLegacyIdAccount.get(oAccountVar.Legacy_Supporter_Id__c)!=null){
                     Set<String> setInvalidEmailTypePresent=new Set<String>();
                     Set<String> setInvalidEmailTypeNew=new Set<String>();
                     
                     if(oAccountVar.Undeliverable_Invalid__c!=null && oAccountVar.Undeliverable_Invalid__c.Contains(';'))
                                setFinalEmailType.addAll(oAccountVar.Undeliverable_Invalid__c.split(';'));
                      else if(oAccountVar.Undeliverable_Invalid__c!=null)
                            setFinalEmailType.add(oAccountVar.Undeliverable_Invalid__c);   
                      
                     if(mapLegacyIdAccount.get(oAccountVar.Legacy_Supporter_Id__c).Undeliverable_Invalid__c!=null && 
                     mapLegacyIdAccount.get(oAccountVar.Legacy_Supporter_Id__c).Undeliverable_Invalid__c.contains(';')) 
                                setFinalEmailType.addAll(mapLegacyIdAccount.get(oAccountVar.Legacy_Supporter_Id__c).Undeliverable_Invalid__c.split(';'));
                       else if(mapLegacyIdAccount.get(oAccountVar.Legacy_Supporter_Id__c).Undeliverable_Invalid__c!=null)
                            setFinalEmailType.add(mapLegacyIdAccount.get(oAccountVar.Legacy_Supporter_Id__c).Undeliverable_Invalid__c); 
                       
                       
                  
                  }
                for(String sEmailType: setFinalEmailType)
                  sUndeliveredEmailType+=sEmailType+';';
              
              if(sUndeliveredEmailType!=''){    
               sUndeliveredEmailType=sUndeliveredEmailType.subStringbeforeLast(';');
                  
               mapLegacyIdAccount.get(oAccountVar.Legacy_Supporter_Id__c).Undeliverable_Invalid__c=sUndeliveredEmailType;
               
               }
               
               }
               
               
               //Apurva - INC0066920
               // upsert lstAccountFinal Legacy_Supporter_Id__c; 
                //Upserting record from Compass based on legacy Id
                boolean bIsError=false;
                String ErrorMsg = 'Internal Server Error:';
                Integer iIndex=0;
                List<Database.UpsertResult> lstUpsertResult=
                Database.upsert(lstAccountFinal,Account.Legacy_Supporter_Id__c,false);
                for(Database.UpsertResult upsertResult: lstUpsertResult){
                    if (upsertResult.isSuccess()) {
                        // Operation was successful, 
                        //so get the ID of the record that was processed
                    }
                    else{
                        //Operation was unsuccessful
                        bIsError = true;
                        for(Database.Error err : upsertResult.getErrors()) {
                        system.debug('>>>'+err );
                           ErrorMsg = ErrorMsg +' '+lstAccountFinal[iIndex].legacy_supporter_id__c +'-'+err.getMessage() + ';';
                        }
                    }
                    iIndex++;
                 }   
                 if(bIsError){
                    RestContext.response.statusCode = 500 ;
                    Account oAccount=new Account(Background__c='Failure',Description=ErrorMsg);
                    Map<String,List<sObject>> mapOutput= new Map<String,List<sObject>>();
                    mapOutput.put('XMPieErrorMessageGroup',new List<Account>{oAccount});
                    String sResponse=JSONHandlerMethods.serialize(mapOutput,
                    'XMPieErrorMessage'); 
                    RestContext.response.responseBody = Blob.valueOf
                    (sResponse);
                    //Apurva -Utility.insertErrorLogIntegration added for INC0066920
                    if(ErrorMsg.length()> 101372){
                        ErrorMsg = ErrorMsg.substring(0,101372);
                    }
                    Utility.insertErrorLogIntegration('500',ErrorMsg,'CreateAccountRESTServices','Integration',
                    'CreateAccountRESTServices','Inbound Call',
                    request.requestBody.toString().trim(),UserInfo.getUserId(),
                    'createAccount');
        
                    return;
                 }
                 //Changes end here
                
            }
            catch(Exception ex){
                RestContext.response.statusCode = 500 ;
                 Account oAccount=new Account(Background__c='Failure',Description='Internal Server Error'+ex.getMessage()+'!!!'+ex.getLineNumber());
                Map<String,List<sObject>> mapOutput= new Map<String,List<sObject>>();
                mapOutput.put('XMPieErrorMessageGroup',new List<Account>{oAccount});
                String sResponse=JSONHandlerMethods.serialize(mapOutput,
                'XMPieErrorMessage'); 
                RestContext.response.responseBody = Blob.valueOf
                (sResponse);
                system.debug('>>>'+ex);
                //Apurva -Utility.insertErrorLogIntegration added for INC0066920
                Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
                ex.getStackTraceString(),'CreateAccountRESTServices','Integration',
                'CreateAccountRESTServices','Inbound Call',
                request.requestBody.toString().trim(),UserInfo.getUserId(),
                'createAccount');
    
                return;
            }
            
           Map<String,List<sObject>> mapOutput= new Map<String,List<sObject>>();
            mapOutput.put('SuporterProcessResponse',lstAccount);
            String sResponse=JSONHandlerMethods.serialize(mapOutput,
            'SupporterResponse');
            
           
            RestContext.response.responseBody = Blob.valueOf(sResponse);
        }
        catch(Exception ex){
            
            RestContext.response.statusCode = 500 ; 
            Account oAccount=new Account(Background__c='Failure',Description='Internal Server Error');
            
            Map<String,List<sObject>> mapOutputMsg=new Map<String,List<sObject>>();
            mapOutputMsg.put('CompassMessageGroup',
            new List<Account>{oAccount});
            String sResponse=JSONHandlerMethods.serialize
            (mapOutputMsg,'CompassMessage');
            system.debug('>>>'+ex);
            
            RestContext.response.responseBody = Blob.valueOf(sResponse);
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'CreateAccountRESTServices','Integration',
            'CreateAccountRESTServices','Inbound Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'createAccount');
        } 
    }
    

}