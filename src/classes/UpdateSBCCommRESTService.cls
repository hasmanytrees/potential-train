/******************************************************************************
Name             : UpdateSBCCommRESTService
Description      : This REST webservice is used to Call to query all SBC Communication Records
                              
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                  29/10/2015            Created
******************************************************************************/

@RestResource(urlMapping='/SBCCommupdate')
global class UpdateSBCCommRESTService{

  
   /**
    * Method name  : updateSBCPhysicalDateReceived
    * Description  : Use this method to update physical Date received on SBC Communications 
                     based on provided updates from Salesforce CI
    *                
    * Return Type  : void
    * Parameter    : JSON
    **/
    
    @HttpPut
    global static void updateSBCPhysicalDateReceived() 
    {
       
          String sSBCId= 
        RestContext.request.params.get('GlobalPartnerSBCId'); 
        RestContext.response.addHeader('Content-Type', 'application/json');
       try{
        if(sSBCId!=null){
        
           List<SBC_Communications__c> lstSBCComm=new List<SBC_Communications__c>();
           lstSBCComm=[select Id,SBC_Global_Id__c from SBC_Communications__c where Name=: sSBCId OR SBC_Global_Id__c=:sSBCId];
           
           for(SBC_Communications__c oSBCComVar: lstSBCComm)
               oSBCComVar.Date_Physical_Received__c=Date.today();
        
           if(lstSBCComm.size()>0){
             update lstSBCComm; 
             RestContext.response.statusCode = 200 ; 
             return;
             }
           else
              RestContext.response.statusCode = 404;   
        }else
            RestContext.response.statusCode = 404; 
       }
       catch(Exception ex){
        
         RestContext.response.statusCode = 500 ; 
            Account oAccount=new Account(Background__c='Failure',Description=ex.getMessage());
            
            Map<String,List<sObject>> mapOutputMsg=new Map<String,List<sObject>>();
            mapOutputMsg.put('CompassMessageGroup',
            new List<Account>{oAccount});
            String sResponse=JSONHandlerMethods.serialize
            (mapOutputMsg,'CompassMessage');
            
            
            RestContext.response.responseBody = Blob.valueOf(sResponse);
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'UpdateSBCCommRESTService','Integration',
            'updateSBCPhysicalDateReceived','Inbound Call',
            RestContext.request.requestBody.toString().trim(),UserInfo.getUserId(),
            'updateSBCPhysicalDateReceived');
       
       }    
    
  
     }
  
    /**
    * Method name  : updateSBCCommunications
    * Description  : Use this method to update SBC Communications 
                     based on provided updates from Salesforce CI
    *                
    * Return Type  : void
    * Parameter    : JSON
    **/
    
    @HttpPost
    global static void updateSBCCommunications() 
    {
        RestRequest request = RestContext.request;
        try
        { 
            //Taking URL parameters            
            RestContext.response.addHeader('Content-Type', 'application/json');
            List<SBC_Communications__c> lstSBCCommunicationRetrieved = new List<SBC_Communications__c>();
            List<SBC_Communications__c> lstSBCCommunicationRetrievedFinal = new List<SBC_Communications__c>();
            lstSBCCommunicationRetrieved = 
            (List<SBC_Communications__c>)JSONHandlerMethods.deserialize
            (request.requestBody.toString().trim() ,'SBCCommInboundUpdateProcess');
            Set<String> setSBCCommIds=new Set<String>();
            Map<String,String> mapGlobalSBCId=new Map<String,String>();
            
            for(SBC_Communications__c oSBCVar: lstSBCCommunicationRetrieved )
            {
                if(oSBCVar.SBC_Global_Id__c!=null && oSBCVar.SBC_Global_Id__c!='')
                setSBCCommIds.add(oSBCVar.SBC_Global_Id__c);
                
            }            
            List<SBC_Communications__c>  lstSBCComm=new List<SBC_communications__c>();
            if(setSBCCommIds.size()>0)
            lstSBCComm=[select Id,SBC_Global_Id__c  from SBC_communications__c 
            where SBC_Global_Id__c IN :setSBCCommIds];
            for(SBC_Communications__c oSBCVar: lstSBCComm)
            mapGlobalSBCId.put(oSBCVar.SBC_Global_Id__c,oSBCVar.Id); 
            
            for(SBC_Communications__c oSBCVar: lstSBCCommunicationRetrieved)
            {                
                if(mapGlobalSBCId.get(oSBCVar.SBC_Global_Id__c)!=null)
                {
                    oSBCVar.Id=mapGlobalSBCId.get(oSBCVar.SBC_Global_Id__c);
                    oSBCVar.Date_Physical_Received__c=System.today();
                    lstSBCCommunicationRetrievedFinal .add(oSBCVar);
                    
                }
            }
            if(lstSBCCommunicationRetrievedFinal.size()>0)
            {
                update lstSBCCommunicationRetrievedFinal ;
                if(lstSBCCommunicationRetrievedFinal.size()<lstSBCCommunicationRetrieved.size())
                RestContext.response.statusCode = 206;
                else 
                RestContext.response.statusCode = 200 ; 
                return;  
            }
            else
            RestContext.response.statusCode = 404 ; 
                        
        }
        catch(Exception ex)
        {
            
            RestContext.response.statusCode = 500 ; 
            Account oAccount=new Account(Background__c='Failure',Description=ex.getMessage());
            
            Map<String,List<sObject>> mapOutputMsg=new Map<String,List<sObject>>();
            mapOutputMsg.put('CompassMessageGroup',
            new List<Account>{oAccount});
            String sResponse=JSONHandlerMethods.serialize
            (mapOutputMsg,'CompassMessage');
            
            
            RestContext.response.responseBody = Blob.valueOf(sResponse);
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'UpdateSBCCommRESTService','Integration',
            'updateSBCCommunications','Inbound Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'updateSBCCommunications');
        }
        
    }
}