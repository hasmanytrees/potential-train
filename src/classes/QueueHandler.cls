global class QueueHandler implements System.Queueable, Database.AllowsCallouts
{
    
    private String sMethodName;
    private String sObjectName;
    private Set<id> lstObjRecordIds;
    
    public QueueHandler(String sMethodName, String sObjectName, Set<id> lstObjRecordIds)
    {
        this.sMethodName=sMethodName;
        this.sObjectName=sObjectName;
        this.lstObjRecordIds=lstObjRecordIds;
    }
    
    
    public void execute(System.QueueableContext objContext)
    {
        List<Id> lstErrorId=new List<Id>();
        lstErrorId.addAll(lstObjRecordIds);
        retransmitTransaction(sMethodName,sObjectName,lstErrorId);
    }
   
    webservice static String retransmitTransaction(String sMethodNameVar, String sObjectNameVar, List<id> lstObjRecordIdsVar){
        
        // Convert to schema.sObjectType
        //Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);
        Map<Id,Error_Log__c> mapErrorLog=new Map<Id,Error_Log__c>();
        // Create an instance of that type
        String sStatus='';
        Set<String> setErrorLogStatus=new Set<String>();
        
            List<Error_Log__c> lstErroLogsToUpdate = new List<Error_Log__c>();
            
            for(Error_Log__c oErrorLogVar : [select id,Urgency__c,Impact__c, Integration_Name__c,Error_Category__c, New_Instance__c, Endpoint_URL__c, Method__c, IsRepeatEnabled__c, Method_Causing_Error__c, Number_Of_Iterations__c, JSON__c from Error_Log__c where id in :lstObjRecordIdsVar and IsRepeatEnabled__c=true order by lastModifiedDate asc])
            { 
              
                try
                {
                if((oErrorLogVar.Method__c!=null ) && (oErrorLogVar.Endpoint_URL__c!=null) && (oErrorLogVar.JSON__c!=null)){
                    HttpRequest req = new HttpRequest(); 
                    
                    //Set HTTPRequest Method
                    req.setMethod(oErrorLogVar.Method__c);
                    
                    //Set HTTPRequest header properties
                    req.setHeader('content-type', 'application/json');
                    req.setEndpoint(oErrorLogVar.Endpoint_URL__c);
                    //req.setHeader('Date',getDateString()); 
                    req.setTimeout(120000);
                    req.setHeader('Authorization',new MasheryOAuthGenerator().generateMasheryOAuth());
                    //Set the HTTPRequest body 
                    if(oErrorLogVar.Method__c <> 'GET')   
                    req.setBody(oErrorLogVar.JSON__c);    
                    Http http = new Http();
                    //Execute web service call here     
                    HTTPResponse res = http.send(req);  
                    if(res.getStatusCode() == 200 || res.getStatusCode() == 201)
                    {
                        if(oErrorLogVar.Integration_Name__c == 'SBCCommitment'){
                        SBCCommunicationTriggerHelper.callFromErrorLog(res, oErrorLogVar.New_Instance__c);
                         oErrorLogVar.Error_Category__c='CommitmentXmpie';
                        }
                        else if(oErrorLogVar.Integration_Name__c == 'S2BCI'){
                        SBCCommunicationTriggerHelper.populateSBCCommunicationValues(res);
                           oErrorLogVar.Error_Category__c='S2B';
                        
                        }
                        
                        
                         else if(oErrorLogVar.Integration_Name__c == 'XMpie'){
                        
                           oErrorLogVar.Error_Category__c='XMPieIntegration';
                        
                        }
                        
                        oErrorLogVar.IsRepeatEnabled__c = false; 
                       
                        sStatus='Success';
                                   
                    }
                    else
                    {
                       
                        if(oErrorLogVar.Integration_Name__c == 'SBCCommitment'){
                     
                         oErrorLogVar.Error_Category__c='CommitmentXmpie';
                        }
                        else if(oErrorLogVar.Integration_Name__c == 'S2BCI'){
                       
                           oErrorLogVar.Error_Category__c='S2B';
                        
                        }
                         
                        else if(oErrorLogVar.Integration_Name__c == 'XMPieIntegration'){
                        
                           oErrorLogVar.Error_Category__c='XMPieIntegration';
                        
                        }
                        else if(oErrorLogVar.Integration_Name__c == 'MasheryFailure')
                        {
                            oErrorLogVar.Error_Category__c='Mashery Failure';
                        }
                        oErrorLogVar.Number_Of_Iterations__c = oErrorLogVar.Number_Of_Iterations__c + 1; 
                        
                        sStatus='Failed';   
                    }
                    
                    lstErroLogsToUpdate.add(oErrorLogVar);
                    setErrorLogStatus.add(oErrorLogVar.Error_Category__c);
                    mapErrorLog.put(oErrorLogVar.Id,oErrorLogVar);                    
               
               }
               }
               catch(Exception ex)
               {
                   if(oErrorLogVar.Integration_Name__c == 'SBCCommitment'){
                     
                         oErrorLogVar.Error_Category__c='CommitmentXmpie';
                        }
                        else if(oErrorLogVar.Integration_Name__c == 'S2BCI'){
                       
                           oErrorLogVar.Error_Category__c='S2B';
                        
                        }
                         
                        else if(oErrorLogVar.Integration_Name__c == 'XMPieIntegration'){
                        
                           oErrorLogVar.Error_Category__c='XMPieIntegration';
                        
                        }
                        else if(oErrorLogVar.Integration_Name__c == 'MasheryFailure')
                        {
                            oErrorLogVar.Error_Category__c='Mashery Failure';
                        }
                        oErrorLogVar.Number_Of_Iterations__c = oErrorLogVar.Number_Of_Iterations__c + 1; 
                        
                        sStatus='Failed';
                       lstErroLogsToUpdate.add(oErrorLogVar);
                    setErrorLogStatus.add(oErrorLogVar.Error_Category__c);
                    mapErrorLog.put(oErrorLogVar.Id,oErrorLogVar); 
               }           
            }
            List<Error_Log__c> lstErrorLogWithCase=new  List<Error_Log__c>();
            
            Map<String,boolean> mapLastServicerequest=new  Map<String,boolean> ();
            
            lstErrorLogWithCase=[select Id,Error_Category__c from Error_Log__c 
                                                    where Error_Category__c IN :setErrorLogStatus and Is_Escalated__c=true
                                                    and CreatedDate=TODAY];
            
          
         for( Error_Log__c oErrorLogVar: lstErroLogsToUpdate){
          
          if(lstErrorLogWithCase.size()>0){
          
           Integer iCheck=0;
           for(Error_Log__c oErrorLogTmpVar: lstErrorLogWithCase){
            
                if(oErrorLogVar.Error_Category__c==oErrorLogTmpVar.Error_Category__c){
                  mapLastServicerequest.put(oErrorLogVar.Error_Category__c,true);
                  iCheck++;
                  }
                 
              }
              if(iCheck==0)
                  mapLastServicerequest.put(oErrorLogVar.Error_Category__c,false);
            }
            else{
            
                 mapLastServicerequest.put(oErrorLogVar.Error_Category__c,false);
            
            
            }
          }  
            
            
           for(Error_Log__c oErrorLogVar :  lstErroLogsToUpdate){ 
           
           if(oErrorLogVar.Error_Category__c!=null){
            
             oErrorLogVar.Urgency__c= Error_Log_Repeats__c.getValues(oErrorLogVar .Integration_Name__c).Urgency__c;
             
             oErrorLogVar.Impact__c= Error_Log_Repeats__c.getValues(oErrorLogVar .Integration_Name__c).Impact__c;
           
           }
           
           
           
           
           if(( Error_Log_Repeats__c.getValues(oErrorLogVar .Integration_Name__c).Maximum_Iterations__c 
                                           <= oErrorLogVar .Number_Of_Iterations__c) 
                                           && (oErrorLogVar.Error_Category__c)!=null 
                                           && (mapLastServicerequest.get(oErrorLogVar.Error_Category__c)==false)
                                           && (oErrorLogVar.IsRepeatEnabled__c=true)){
             oErrorLogVar.IsRepeatEnabled__c = false; 
               
               lstErrorLogWithCase.add(oErrorLogVar );
            }
           
           
         }  
        //    user oUserVar=[select Id,Email from User where Username=:System.label.ErrorLogUserId];
        Id templateId = [select id, name from EmailTemplate where developername = : 'Create_Case_In_Servicenow'].id;
        Id checkWhatId = [select id from Contact where id = :Label.ErrorLogServiceNowContact].id;
        List<Messaging.SingleEmailMessage> mails = 
        new List<Messaging.SingleEmailMessage>();
         for (Error_Log__c oErrorLogVar: lstErrorLogWithCase) {
                       
                          // Step 1: Create a new Email
                          Messaging.SingleEmailMessage mail = 
                          new Messaging.SingleEmailMessage();
                        //mail.setTemplateId(templateId);
                        mail.setSaveAsActivity(false);
                        
                         mail.setWhatId(oErrorLogVar.id);
                          // Step 2: Set list of people who should get the email
                         mail.setTargetObjectId(checkWhatId);
                         List<String> lstToAddressString = new List<String>();
                         lstToAddressString.add(System.label.ErrorLogUserId);
                          mail.setToAddresses(lstToAddressString);
                          // Step 3: Set who the email is sent from
                          //mail.setReplyTo(UserInfo.getUserEmail());
                          mail.setSenderDisplayName(UserInfo.getName());
                        
                          // (Optional) Set list of people who should be CC'ed
                        
                          mail.setTemplateId(templateId);
                          //mail.setWhatId(oErrorLogVar.Id);


                     
                        
                          // Step 5. Add your email to the master list
                          mails.add(mail);
                          Messaging.sendEmail(mails);
                      
       }

           for(Error_Log__c oErrorLogVar: lstErrorLogWithCase){
           
               if(mapErrorLog.get(oErrorLogVar.Id)!=null){
                 mapErrorLog.get(oErrorLogVar.Id).Is_Escalated__c=true;
              
              oErrorLogVar.IsRepeatEnabled__c=false;
              
              
              }
            }
       
            if(mapErrorLog.values().size() > 0){
               
               for(Error_Log__c oErrorLogVar :lstErrorLogWithCase){
                  if(mapErrorLog.get(oErrorLogVar.Id)!=null)
                       mapErrorLog.put(oErrorLogVar.Id,oErrorLogVar );
               
               
               }
                     
               
               update mapErrorLog.values();
               
               
               
               }
            
          
        return sStatus;
      
    }
   
    
}