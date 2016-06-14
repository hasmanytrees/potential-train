/*****************************************************************************************
    Name             : DeleteSBCCommRestServices
    Description      : This REST webservice is used to delete SBC Comm record    
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/


@RestResource(urlMapping='/deleteSBCComm')
global class DeleteSBCCommRestServices
{

    /**
    * Method name  : deleteSBCComm
    * Description  : Use this method to logging in error scenarios as per request being send
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    
    @HttpPost
    global static void deleteSBCComm() {
        RestRequest req = RestContext.request;
        RestContext.response.addHeader('Content-Type', 'application/json');
        List<SBC_communications__c> lstSBCComm=JSONHandlerMethods.deserialize(req.requestBody.toString().trim() ,'DeleteSBCCommProcess');   //De-Serializing input JSON using JSONHandlerMethods
        Set<String> setSBCCommIds=new Set<String>();
        Map<String,String> mapGlobalStatus=new Map<String,String>();
        Map<String,String> mapGlobalSBCId=new Map<String,String>();
        if(lstSBCComm.size()>0){
            for(SBC_Communications__c oSBCVar: lstSBCComm)
            setSBCCommIds.add(oSBCVar.SBC_Global_Id__c);            
            
        }
        lstSBCComm=new List<SBC_communications__c>();
        lstSBCComm=[select Id,SBC_Global_Id__c  from SBC_communications__c where SBC_Global_Id__c IN :setSBCCommIds];
        for(SBC_Communications__c oSBCVar: lstSBCComm)
        mapGlobalSBCId.put(oSBCVar.SBC_Global_Id__c,oSBCVar.Id);
        
        try{
            
            List<Database.DeleteResult> lstSeletedResult=
            Database.delete(lstSBCComm,false);
            
            String sResponse;
            List<Account> lstAccount=new List<Account>();
            for(Database.DeleteResult deleteResult: lstSeletedResult){
                if (deleteResult.isSuccess()) {
                    mapGlobalStatus.put(deleteResult.getId(),'Success');
                    
                    
                    
                }
                else {
                    
                    // Operation failed, so get all errors  
                    for(Database.Error err : deleteResult.getErrors()) {
                        
                        mapGlobalStatus.put(deleteResult.getId(),'Failed');
                        
                        
                    }
                }
            }
            
            for(String sGlobalIdVar: setSBCCommIds){
                
                if(mapGlobalSBCId.get(sGlobalIdVar)!=null){
                    
                    String sSBCCommId=mapGlobalSBCId.get(sGlobalIdVar);
                    Account oAccountVar=new Account();                    
                    oAccountVar.Description =sGlobalIdVar ;
                    oAccountVar.Background__C=mapGlobalStatus.get(sSBCCommId);                    
                    lstAccount.add(oAccountVar);
                    
                }
                else{
                    
                    Account oAccountVar=new Account();
                    oAccountVar.Description =sGlobalIdVar ;
                    oAccountVar.Background__C='Not Found';
                    lstAccount.add(oAccountVar);                    
                } 
            }
            
            if(lstAccount.size()>0){   
                
                Map<String,List<sObject>> mapOutput=new Map<String,List<sObject>>();
                mapOutput.put('SBCCommunicationDeletionResponseGroup',
                lstAccount);
                sResponse=JSONHandlerMethods.serialize
                (mapOutput,'SBCCommunicationDeletionResponseProcess');
                
            }
            else{
                RestContext.response.statusCode = 500 ;
                return;
                
            }
            RestContext.response.statusCode = 200 ;
            RestContext.response.responseBody =  Blob.valueOf(sResponse);
            return;
        }
        catch(Exception ex){       
            
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'
            +ex.getStackTraceString(),
            'deleteSBCComm','Integration','DeleteSBCCommRestServices',
            'Inbound Call',req .requestBody.toString().trim(),
            UserInfo.getUserId(),'deleteSBCComm');
        }
    }
    
}