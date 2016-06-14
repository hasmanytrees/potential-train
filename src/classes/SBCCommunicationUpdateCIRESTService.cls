/*******************************************************************************
Name             : SBCCommunicationUpdateCIRESTService
Description      : REST Class invoked to update SBC records incoming 
                from Salesforce CI
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               28/08/2015            Created
Sumeet                 23/09/2015            Modified for code re-factoring 
                                            & optimization
*******************************************************************************/


@RestResource(urlMapping='/updateSBCCommunicationCI')
global class SBCCommunicationUpdateCIRESTService{

    /**
    * Method name  : updateSBCCommunications
    * Description  : Use this method to update SBC Communication 
    *                based on the incoming from CI
    * Return Type  : void
    * Body Parameter    : JSON
    **/
    
    @HttpPost
    global static void updateSBCCommunications() {
        RestRequest request = RestContext.request;
        try{ 
            //Taking URL parameters
            RestContext.response.addHeader('Content-Type', 'application/json');
            Set<String > setAccounts=new Set<String>();
            Set<String> setSBCName=new Set<String>();
            List<Id> lstInappropriateSupporters = new List<Id>();
            Map<String,SBC_communications__c> mapSBCCommName=new Map<String,SBC_communications__c>();
            Map<String,String> mapCIUSAStatusValues = new Map<String,String>();
            for(CI_To_USA_Integration_Value_Mapping__c oMapVar : CI_To_USA_Integration_Value_Mapping__c.getAll().values())
            {
                String sUniqueKey = oMapVar.CI_Value__c + '' + oMapVar.Direction_c__c;
                mapCIUSAStatusValues.put(sUniqueKey, oMapVar.US_Value__c);
            }
            List<SBCCommunicationDetailsList.SBCCommunicationUpdateDetailsUpdateFromCI > lstSBCCommWrp = 
            ( (SBCCommunicationDetailsList.SBCCommunicationDetailsUpdateCI)JSON.deserialize
            (request.requestBody.toString().trim() ,SBCCommunicationDetailsList.SBCCommunicationDetailsUpdateCI.class)).CommunicationUpdates;
            
            
            if(lstSBCCommWrp!=null && lstSBCCommWrp.size()>0){
                
                for(SBCCommunicationDetailsList.SBCCommunicationUpdateDetailsUpdateFromCI sbcVar:  lstSBCCommWrp ){
                    
                  if(sbcVar.Supporter_GlobalId!=null)
                    setAccounts.add(sbcVar.Supporter_GlobalId);
                    if(sbcVar.Supporter_CompassConstituentId!=null)
                    setAccounts.add(sbcVar.Supporter_CompassConstituentId);
                     if(sbcVar.Beneficiary_LocalId!=null)
                    setAccounts.add(sbcVar.Beneficiary_LocalId);
                    if(sbcVar.Beneficiary_GlobalId!=null)
                    setAccounts.add(sbcVar.Beneficiary_GlobalId);
                    if(sbcVar.GlobalPartnerSBCId !=null)
                      setSBCName.add(sbcVar.GlobalPartnerSBCId);   
                } 
                List<Account> lstAccount=new List<Account>();
                List<SBC_communications__c> lstSBCCommFinalWithoutGId=new List<SBC_communications__c>();
                List<SBC_communications__c> lstSBCCommFinalWithGId=new List<SBC_communications__c>();
                List<Correspondence_Delivery_Preference_Map__c> lstDelPref=new   List<Correspondence_Delivery_Preference_Map__c>();
                lstDelPref=Correspondence_Delivery_Preference_Map__c.getAll().values();         
                lstAccount=[select Id,Do_Not_Contact__c,Do_Not_Email__c,Inappropriate_Correspondence__c,Preferred_Email__c,C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,
                Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,
                Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
                Special_Handling__c,Preferred_Name__c,Global_ID__c,BEN_Local_Id__c,BEN_Id__c,
                Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
                Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c from Account where 
                Global_Id__c IN : setAccounts OR Legacy_Supporter_Id__c IN : setAccounts OR BEN_Id__c IN : setAccounts OR BEN_Local_Id__c IN : setAccounts];
                List<SBC_communications__c> lstCommunicationVar=new List<SBC_communications__c> ();
                
                if(setSBCName.size()>0){
                  lstCommunicationVar=[select Id,name from SBC_communications__c where Name IN :setSBCName];
                
                 for(SBC_communications__c oSBCVar: lstCommunicationVar)
                      mapSBCCommName.put(oSBCVar.Name,oSBCVar);
                    
                }
                
                
                Map<String,Account> mapAccount=new Map<String,Account>();
                Map<String,Account> mapAccountId=new Map<String,Account>();
                for(Account oAccountVar: lstAccount){
                    
                    if((oAccountVar.RecordTypeId==Utility.getRecordtype('Supporter','Account'))||((oAccountVar.RecordTypeId==Utility.getRecordtype('Partner','Account')))){
                        mapAccount.put(oAccountVar.Legacy_Supporter_Id__c,oAccountVar);
                        mapAccountId.put(oAccountVar.Id,oAccountVar);
                        mapAccount.put(oAccountVar.Global_Id__c ,oAccountVar);
                    }
                    else if(oAccountVar.RecordTypeId==Utility.getRecordtype('Beneficiary','Account')){
                        mapAccount.put(oAccountVar.Compass_Child_Key__c,oAccountVar);
                        mapAccount.put(oAccountVar.BEN_Local_Id__c ,oAccountVar);
                        mapAccount.put(oAccountVar.BEN_Id__c ,oAccountVar);
                    }
                    
                }
                for(SBCCommunicationDetailsList.SBCCommunicationUpdateDetailsUpdateFromCI  svcVar: lstSBCCommWrp ){
                    SBC_communications__c oSBCVar=new SBC_communications__c();
                    String TransactionId = '';
                    oSBCVar.Final_Letter_URL__c=svcVar.FinalLetterURL;
                    
                    oSBCVar.SBC_Global_Id__c=svcVar.CompassionSBCId;
                    
                    String sDirection ='';
                    if(svcVar.Direction!=null && svcVar.Direction.startsWith('Supporter'))
                    sDirection = 'Supporter To Beneficiary';
                    else
                    sDirection = 'Beneficiary To Supporter';
                    String sKey = svcVar.SBCGlobalStatus+ '' + sDirection;
                    
                    if(svcVar.ReasonForRework!=null)
                       oSBCVar.Communication_Issue_Description__c=svcVar.ReasonForRework;
                    
                    
                    
                  if( svcVar.Internal_Perceptive_TransactionId!=null)
                    oSBCVar.Transaction_ID__c=svcVar.Internal_Perceptive_TransactionId ;
                    
                    oSBCVar.Read__c=false;
                     if(oSBCVar.Status__c!=null && oSBCVar.Status__c.equalsIgnoreCase('Cancelled'))
                          oSBCVar.Communication_Issue_Source__c='Communication Cancelled by Field';
                    
                    if((mapAccount.get(svcVar.Supporter_CompassConstituentId)!=null) 
                            || (mapAccount.get(svcVar.Supporter_GlobalId)!=null))
                    {
                        if(mapAccount.get(svcVar.Supporter_CompassConstituentId)!=null)
                        {
                            oSBCVar.Supporter__c=(mapAccount.get(svcVar.Supporter_CompassConstituentId)).Id;
                        }
                        else
                        {
                            oSBCVar.Supporter__c=(mapAccount.get(svcVar.Supporter_GlobalId)).Id; 
                        }
                    }
                    
                    if((svcVar.ReasonForRework <> null && svcVar.ReasonForRework <> '' && svcVar.ReasonForRework <> 'none' ) || (svcVar.SBCGlobalStatus.toLowerCase() == 'content issues found'))
                    {
                        oSBCVar.Status__c = 'Exception';
                        oSBCVar.Exception_Reason__c = 'Past Communication Issues';     
                    }
                    else
                    {
                        oSBCVar.Status__c = mapCIUSAStatusValues.get(sKey);
                    }
                    
                    if(mapAccount.get(svcVar.Beneficiary_LocalId)!=null)
                    oSBCVar.Beneficiary__c=(mapAccount.get(svcVar.Beneficiary_LocalId)).Id;
                    else if(mapAccount.get(svcVar.Beneficiary_GlobalId)!=null)
                    oSBCVar.Beneficiary__c=(mapAccount.get(svcVar.Beneficiary_GlobalId)).Id;
                    
                    if((svcVar.SBCTypes!=null)&&(svcVar.SBCTypes.size()>0))
                    {
                        for(String sCommTypeVar: svcVar.SBCTypes)
                        {
                            if(sCommTypeVar!=null && sCommTypeVar.equalsIgnoreCase('Final Thank You'))
                            oSBCVar.Final_Letter__c=true;
                        }
                        
                        
                    }
                    if(svcVar.Direction.startsWith('Supporter'))
                    oSBCVar.recordtypeId=Utility.getRecordType('Supporter To Beneficiary','SBC_communications__c');
                    else
                    oSBCVar.recordtypeId=Utility.getRecordType('Beneficiary To Supporter','SBC_communications__c');
                    if(mapSBCCommName.get(svcVar.GlobalPartnerSBCId )!=null){
                       oSBCVar.Id= mapSBCCommName.get(svcVar.GlobalPartnerSBCId ).Id;
                          lstSBCCommFinalWithGId.add(oSBCVar);
                       
                       }
                    else
                      lstSBCCommFinalWithoutGId.add(oSBCVar);
                   // lstSBCCommFinal.add(oSBCVar);
                    
                }
                
                List<SBC_communications__c> lstSBCCommFinal=new List<SBC_communications__c>();
                if(lstSBCCommFinalWithoutGId.size()> 0){
                    upsert lstSBCCommFinalWithoutGId SBC_Global_Id__c;
                    lstSBCCommFinal.addAll(lstSBCCommFinalWithoutGId );
                    
                    }
                 if(lstSBCCommFinalWithGId.size()> 0){
                    update lstSBCCommFinalWithGId;
                    lstSBCCommFinal.addAll(lstSBCCommFinalWithGId);
                    
                    }
                 
                 if(lstSBCCommFinal.size()>0){
                    Set<Id> setSBCId=new Set<Id>();
                    for(SBC_Communications__c  oSBCVar:lstSBCCommFinal  )
                    setSBCId.add(oSBCVar.Id);
                    lstSBCCommFinal=[select Id,Name,Status__c, Exception_Reason__c, SBC_Global_Id__c from SBC_Communications__c where Id IN :setSBCId];
                    for(SBC_Communications__c oSBCVar: lstSBCCommFinal)
                    {
                    oSBCVar.Communication_Source__c=oSBCVar.Name;
                    if(oSBCVar.Status__c == 'Exception')
                    {
                        lstInappropriateSupporters.add(oSBCVar.Supporter__c);
                    }
                    
                    }
                    if(!lstInappropriateSupporters.isEmpty())
                    {
                        List<Account> lstInappropriateAccount = [select id, Inappropriate_Correspondence__c from Account where id in :lstInappropriateSupporters];
                        for(Account accVar:lstInappropriateAccount)
                        {
                            if(accVar.Inappropriate_Correspondence__c <> null)
                            {
                                accVar.Inappropriate_Correspondence__c = accVar.Inappropriate_Correspondence__c + 1;
                            }
                            else
                            {
                                accVar.Inappropriate_Correspondence__c = 1;
                            }
                        }
                        update lstInappropriateAccount;
                    }
                    Map<String,List<sObject>> mapOutput= 
                    new Map<String,List<sObject>>();
                    
                    mapOutput.put('SBCCommGlobalIdCIUpdateFieldGroup',lstSBCCommFinal);
                    //Getting Final JSON String
                    String sResponse=
                    JSONHandlerMethods.serialize(mapOutput,
                    'SBCCommGlobalIdCIUpdateFieldProcess'); 
                    sResponse=sResponse.replace('"null"', 'null');
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    //RestContext.response.statusCode = 404; 
                    // Sending the response back
                    RestContext.response.responseBody = Blob.valueOf(sResponse); 
                    
                    return;  
                }
                else
                RestContext.response.statusCode = 404 ; 
                
            }    
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
            ex.getStackTraceString(),'SBCCommunicationRESTService','Integration',
            'updateSBCCommunications','Inbound Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'updateSBCCommunications');
        }
    }
}