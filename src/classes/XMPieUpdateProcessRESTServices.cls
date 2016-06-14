/*******************************************************************************
    Name             : XMPieUpdateProcessRESTServices
    Description      : This REST class is used to upsert communication record 
    related to account from XMPie
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                            & optimization
Shanu                   8/10/2015            Changes made for INC0067270                                           
******************************************************************************/

@RestResource(urlMapping='/XMPieUpdateProcess')
global with Sharing class XMPieUpdateProcessRESTServices
{
    
    @HttpPost
    global static void manageCommunication() {
        RestRequest request = RestContext.request;
        RestContext.response.addHeader('Content-Type', 'application/json');
        try{  
            // Getting input using JSONHandlerMethods
            List<sObject> lstSObject=
            JSONHandlerMethods.deserialize
            (request.requestBody.toString().trim() ,'XMPieUpdateProcess'); 
            Map<Account,List<Communication__c>> mapRecordCommunication=
            new Map<Account,List<Communication__c>>();
            // Getting object type for Account
            Schema.sObjectType accountSObj=(new Account()).getSObjectType();
            // Getting object type for Contact
            Schema.sObjectType contactSObj=(new Contact()).getSObjectType();
            Set<String> setEmail=new Set<String>();
            // Getting object type for Communication
            Schema.sObjectType communicationSObj=
            (new communication__c()).getSObjectType();  
            List<Communication__c> lstCommunication=
            new List<Communication__c> ();
            list<Communication__c> lstSplitCampaignCommunication=
            new List<Communication__c> ();
            Map<String,Communication__c> mapCommunication = 
            new Map<String,Communication__c>();
            Set<Id> setContactId=new Set<Id>();
            
            
            for(sObject oSObjVar: lstSObject){
                
                if(oSObjVar.getSObjectType()==communicationSObj){
                    
                    //Getting for Communication
                    Communication__c oCommVar=new Communication__c();
                    oCommVar=(Communication__c) oSObjVar;
                    
                    // Mapping values based on Entity token in JSON
                    if((oCommVar.Entity__c== System.Label.User)||(oCommVar.Contact__c.getSObjectType()==new USer().getSObjectType()))
                    continue;
                    
                    if(oCommVar.Entity__c== System.Label.Account){
                        oCommVar.Account__c=oCommVar.Contact__c;
                        oCommVar.Contact__c = null ;
                    }
                    
                    else if(oCommVar.Entity__c== System.Label.Lead){
                        oCommVar.Lead__c=oCommVar.Contact__c;
                        oCommVar.Contact__c = null ;
                    }                       
                    
                    if(oCommVar.Entity__c == System.Label.Contact){
                        oCommVar.Contact__c = oCommVar.Contact__c;
                    }                    
                    
                    if(( oCommVar.Phone_Number__c!=null)
                            &&(oCommVar.Phone_Number__c.contains('#'))) {
                        
                        
                        for(String sCampaignIdVar:oCommVar.Phone_Number__c.split
                        ('#')){
                            Communication__c oCommNewVar=new Communication__c();
                            oCommNewVar= oCommVar.clone();  
                            oCommNewVar.Campaign__c=sCampaignIdVar;
                            oCommNewVar.XMPie_Unique_Id__c=oCommNewVar.Job_Id__c+''
                            +oCommNewVar.Recipient_Id__c+''+sCampaignIdVar;
                            // Shanu - Added for INC0067270
                            oCommNewVar.Phone_Number__c=null;
                            mapCommunication.put
                            (oCommNewVar.XMPie_Unique_Id__c, oCommNewVar) ; 
                        }
                        
                    }
                    else{
                        oCommVar.Campaign__c=oCommVar.Phone_Number__c;
                        oCommVar.XMPie_Unique_Id__c=
                        oCommVar.Job_Id__c+''+oCommVar.Recipient_Id__c;
                        mapCommunication.put
                        (oCommVar.XMPie_Unique_Id__c, oCommVar) ; 
                    }
                    oCommVar.Phone_Number__c=null;
                    //Getting Emails with Failed status 
                    
                    if((oCommVar.Status__c!=null)
                            &&(oCommVar.Status__c.toUpperCase() == 
                                System.Label.failed.toUpperCase()))
                    setEmail.add(oCommVar.Email__c);
                    
                    //Getting Account Details for failed one.
                    if(oCommVar.Account__c!=null)
                    setContactId.add(oCommVar.Account__c);
                    
                    if(oCommVar.Email__c!=null
                            &&oCommVar.Email__c.contains(System.label.SMSEmail)){
                        oCommVar.Medium__c=System.label.SMS;
                        if((oCommVar.Status__c!=null)&&
                                (oCommVar.Status__c.contains(System.label.EmailSent.split(' ')[0]))&&
                                (oCommVar.Status__c.contains(System.label.EmailSent.split(' ')[1])))
                        oCommVar.Status__c=System.Label.TextDataSent;
                    }
                    else
                    oCommVar.Medium__c=System.label.Email;
                    
                    
                }            
            }
            
            if( mapCommunication <> NULL )
            lstCommunication = mapCommunication.values();
            //Upserting communication record
            //upsert lstCommunication XMPie_Unique_Id__c;  
            
            List<Database.UpsertResult> lstUpsertResult=
            Database.upsert(lstCommunication,Communication__c.Fields.XMPie_Unique_Id__c,false);
            String sErrorMsg='Error: ';
            String sResponseStr='';
            
            boolean bIsError=false;
            Integer iIndex=0;
            for(Database.UpsertResult upsertResult: lstUpsertResult){
                if (upsertResult.isSuccess()) {
                    // Operation was successful, 
                    //so get the ID of the record that was processed
                    
                    
                }
                else {
                    
                    // Operation failed, so get all errors  
                    
                    for(Database.Error err : upsertResult.getErrors()) {
                        //Code changes made for INC0067081
                        sErrorMsg = sErrorMsg + lstCommunication[iIndex].XMPie_Unique_Id__c+ '-'+err.getMessage()+';';
                        bIsError=true;
                       /*
                        RestContext.response.statusCode = 500 ;
                        Account oAccountVar=new Account();
                        //oAccountVar.Description =lstCommunication[iIndex].XMPie_Unique_Id__c;
                        oAccountVar.Description =lstCommunication[iIndex].XMPie_Unique_Id__c+err.getMessage();
                        oAccountVar.Site='Failed';
                        
                        Map<String,List<sObject>> mapOutput=new Map<String,List<sObject>>();
                        mapOutput.put('XMPieErrorMessageSendingGroup',
                        new List<Account>{oAccountVar});
                        String sResponse=JSONHandlerMethods.serialize
                        (mapOutput,'XMPieErrorSendingMessage');
                        RestContext.response.responseBody =  Blob.valueOf(sResponse);*/
                        
                        /*
                        sErrorMsg+='Comm Record Id :'+upsertResult.getId()+' \n Message:'+ err.getMessage()
                        +'\n===============\n';                 
                        sResponseStr+='Comm Record Id :'+lstCommunication[iIndex].XMPie_Unique_Id__c+',\n Status : Failed,\n';
                        bIsError=true;
                        */
                    }
                  //  return;
                    
                }  
                iIndex++;
                
            } 
            if(bIsError){
                try
                {
                    //Changes made for INC0067081
                    RestContext.response.statusCode = 500 ;
                    Account oAccountVar=new Account();
                    oAccountVar.Description =sErrorMsg;
                    oAccountVar.Site='Failed';
                    
                    Map<String,List<sObject>> mapOutput=new Map<String,List<sObject>>();
                    mapOutput.put('XMPieErrorMessageSendingGroup',
                    new List<Account>{oAccountVar});
                    String sResponse=JSONHandlerMethods.serialize
                    (mapOutput,'XMPieErrorSendingMessage');
                    RestContext.response.responseBody =  Blob.valueOf(sResponse);
                    if(sErrorMsg.length()>131071){
                        sErrorMsg = sErrorMsg.substring(0,131071);
                    }
                    Utility.insertErrorLogIntegration('500',sErrorMsg
                    ,'Integration','XMPieUpdateProcessRESTServices','manageCommunication',
                    'Inbound Call',request.requestBody.toString().trim(),
                    UserInfo.getUserId(),'manageCommunication');
                    return;
                }
                catch(Exception ex)
                {
                    //Error occured during Log Insertion.
                    //Probable Reason:
                    //1. Message String is too large or
                    //2. Overall record limit 
                    return;
                }
            }
            if((setEmail.size()==0)&&(setContactId.size()==0)&&(!bIsError)){
                //If Status not 'Failed' or Entity is not Account
                RestContext.response.responseBody =  
                Blob.valueOf(System.Label.Records_Updated);
                return;
                
            }
            List<Account> lstAccount=new  List<Account>();  
            //Getting Account based on specified Email
            lstAccount=[select Id,Undeliverable_Invalid__c,Business_Email__c,
            Personal_Email__c,Work_Email__c from Account 
            where (Business_Email__c IN :setEmail
            OR Personal_Email__c IN :setEmail OR Work_Email__c IN :setEmail) 
            AND Id IN :setContactId  ];
            
            
            
            
            for(String emailStr: setEmail){
                
                for(Account oAccountVar: lstAccount){
                    // Checking for Email type in Account
                    if((oAccountVar.Business_Email__c==emailStr)){
                        if(oAccountVar.Undeliverable_Invalid__c!=null){ 
                            if(!oAccountVar.Undeliverable_Invalid__c.contains
                                    (System.Label.Business_Email))
                            oAccountVar.Undeliverable_Invalid__c=
                            oAccountVar.Undeliverable_Invalid__c+';'
                            + System.Label.Business_Email;
                        }
                        else
                        oAccountVar.Undeliverable_Invalid__c=
                        System.Label.Business_Email;
                    }
                    
                    else if((oAccountVar.Personal_Email__c==emailStr)){
                        if(oAccountVar.Undeliverable_Invalid__c!=null){ 
                            if(!oAccountVar.Undeliverable_Invalid__c.contains
                                    (System.Label.Personal_Email))
                            oAccountVar.Undeliverable_Invalid__c=
                            oAccountVar.Undeliverable_Invalid__c+';' 
                            + System.Label.Personal_Email;
                        }
                        else
                        oAccountVar.Undeliverable_Invalid__c= 
                        System.Label.Personal_Email;
                    }
                    
                    else if((oAccountVar.Work_Email__c==emailStr)){
                        if(oAccountVar.Undeliverable_Invalid__c!=null){ 
                            if(!oAccountVar.Undeliverable_Invalid__c.contains
                                    (System.Label.Work_Email))
                            oAccountVar.Undeliverable_Invalid__c=
                            oAccountVar.Undeliverable_Invalid__c+
                            ';'+ System.Label.Work_Email;
                        }
                        else
                        oAccountVar.Undeliverable_Invalid__c=
                        System.Label.Work_Email;
                    }
                    
                    
                }
                
            }
            //Updating Undeliverable_Invalid__cfield with matched email type
            
            if(lstAccount.size()>0)  
            update lstAccount;
            if(!bIsError ){ 
            RestContext.response.responseBody =  
            Blob.valueOf(System.Label.Records_Updated);
            
            }
            else{
             RestContext.response.responseBody =  
            Blob.valueOf(sResponseStr);
            RestContext.response.StatusCode=500;
            
            }
            
        }
        catch(Exception ex){
               RestContext.response.statusCode = 500 ;
            Account oAccountVar=new Account();
            oAccountVar.Background__c=ex.getTypeName();
            oAccountVar.Description=System.label.ErrorOccuredInXMPie;
            Map<String,List<sObject>> mapOutput=new Map<String,List<sObject>>();
            mapOutput.put('XMPieErrorMessageGroup',
            new List<Account>{oAccountVar});
            String sResponse=JSONHandlerMethods.serialize
            (mapOutput,'XMPieErrorMessage');
            RestContext.response.responseBody =  Blob.valueOf(sResponse);
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'
            +ex.getStackTraceString(),
            'manageCommunication','Integration','XMPieUpdateProcessRESTServices',
            'Inbound Call',request.requestBody.toString().trim(),
            UserInfo.getUserId(),'manageCommunication');
             
             return;
        }
        
        
    }


}