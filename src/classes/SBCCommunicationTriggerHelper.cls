/*******************************************************************************
Name             : SBCCommunicationTriggerHelper
Description      : Trigger Helper class used to make HTTP Callouts 
                based on SBCCommunication DML Operations
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 30/10/2014            Created
*******************************************************************************/

public with Sharing class SBCCommunicationTriggerHelper
{
    
    /**
    * Method name  : retrieveOnlyCommitmentDetails
    * Description  : This method is called to retrieve 
                    Commitment Details from Compass
    *                
    * Return Type  : void
    * Parameter    : Set<Id>, Set<Id>
    **/ 
    
    @future(callout=true)
    public static void retrieveOnlyCommitmentDetails(Set<String> setBeneficiaryId,Set<Id> setSBCCommunication)
    {
        String sQuery = Utility.retrieveAllFieldsDynamicallyFromObjectForSOQL('SBC_Communications__c');
        
        if(sQuery <> null && sQuery <> '')
        sQuery = sQuery + ' where id in :setSBCCommunication';
        List<SBC_Communications__c> lstSBCCommRecords = Database.query(String.escapeSingleQuotes(sQuery));
        
        if(!lstSBCCommRecords.isEmpty() || !setBeneficiaryId.isEmpty())
        {
            Map<String, String> mapBeneficiaries = new Map<String, String>();
            for(SBC_Communications__c sbcCom : lstSBCCommRecords)
            {mapBeneficiaries.put(sbcCom.Beneficiary__r.Compass_Child_Key__c,sbcCom.Supporter__r.Legacy_Supporter_Id__c);}
            findCommitmentDetails(setBeneficiaryId, lstSBCCommRecords, mapBeneficiaries);
        }
        
    }
    
    /**
    * Method name  : sendDirectlyToCI
    * Description  : This method is called to send
    *                 complete SBC Record directly to Salesforce CI
    * Return Type  : void
    * Parameter    : Set<Id>
    **/ 
    
    @future(callout=true)
    public static void sendDirectlyToCI(Set<Id> setSBCCommunication)
    {
        String sQuery = Utility.retrieveAllFieldsDynamicallyFromObjectForSOQL('SBC_Communications__c');
        if(sQuery <> null && sQuery <> '')
        sQuery = sQuery + ' where id in :setSBCCommunication';
        List<SBC_Communications__c> lstSBCCommunications =  Database.query(String.escapeSingleQuotes(sQuery));
        getGlobalIdFromCI(lstSBCCommunications);
    }
    
    /**
    * Method name  : sendSBCToXMPie
    * Description  : This method is called to send
    *                complete SBC Record to XMPIE
    * Return Type  : void
    * Parameter    : Set<Id>
    **/ 
    
    @future(callout=true)
    public static void sendSBCToXMPie(Set<Id> setSBCCommunication)
    {
        String sQuery = Utility.retrieveAllFieldsDynamicallyFromObjectForSOQL('SBC_Communications__c');
        if(sQuery <> null && sQuery <> '')
        sQuery = sQuery + ' where id in :setSBCCommunication';
        List<SBC_Communications__c> lstSBCCommunications =  Database.query(String.escapeSingleQuotes(sQuery));
        sendEmailForSBC(lstSBCCommunications);
  
    }
    
    /**
    * Method name  : findCommitmentDetails
    * Description  : This method is called to retrieve 
                     Commitment Details from Compass
    *                
    * Return Type  : void
    * Parameter    : Set<Id>
    **/ 
    
    public static void findCommitmentDetails(Set<String> commitmentId, List<SBC_Communications__c> lstSBCCommunications, Map<String, String> mapBeneficiaries)
    {
        Map<SBC_Communications__c, String> mapSBCCommunication = new Map<SBC_Communications__c, String>();
        List<SBC_Communications__c> lstFinalSBCCommunication = new List<SBC_Communications__c>();
        Set<String> lstBeneficiaries = new Set<String>();
        Http http = new Http();
        String sCorrespondence ='';
        // Instantiate a new HTTP request, specify the method (GET) as well 
        //as the endpoint
        HttpRequest request = new HttpRequest();
        Integration_Endpoints__c oConnector = 
        Integration_Endpoints__c.getAll().get('Commitment Endpoint URL'); 
        request.setMethod('GET');
        List<String> lstId = new List<String>();
        lstId.addAll(commitmentId);
        String sURL = oConnector.Endpoint_URL__c+lstId[0]+oConnector.Authorization_Code__c;        
        //String sURL = ''+lstId[0]+'';
        request.setEndpoint(sURL);
        request.setTimeout(120000); 
        
        try{
        // Send the request, and return a response
        request.setHeader('Authorization',
            new MasheryOAuthGenerator().generateMasheryOAuth());
        
            Utility.bToCheckSupporterStatus=false;
            //Adding authorization Header
            HttpResponse response = http.send(request);
            if(response.getStatus()=='OK')
            {
                updateSBCWithCommitment(response, mapBeneficiaries, lstSBCCommunications);
            }
            else
            {
                Set<Id> setSBCIds = new Set<Id>();
                for(SBC_Communications__c oSBCVar: lstSBCCommunications)
                setSBCIds.add(oSBCVar.id);
                Utility.insertErrorLogIntegration3
                ('500',response.getStatus()+'\n'+response.getStatusCode()+'\n'+response.getBody(),
                'SBCCommunicationTriggerHelper','Integration','findCommitmentDetails'
                ,'Inbound Call',request.getBody(),
                UserInfo.getUserId(),'SBCCommitment', String.valueOf(setSBCIds),sURL,'GET');
                
                
                
            }
            }
            catch(Exception ex)
            {
               /* Set<Id> setSBCIds = new Set<Id>();
                for(SBC_Communications__c oSBCVar: lstSBCCommunications)
                    setSBCIds.add(oSBCVar.id);
                    
                Utility.insertErrorLogIntegration3
                ('500','Mashery Authorization Failed',
                'SBCCommunicationTriggerHelper','Integration','MasheryFailure'
                ,'Inbound Call',String.valueOf(lstId[0]),
                UserInfo.getUserId(),'SBCCommitment', String.valueOf(setSBCIds),sURL,'GET');
                */
                
                Set<Id> setSBCIds = new Set<Id>();
                for(SBC_Communications__c oSBCVar: lstSBCCommunications)
                setSBCIds.add(oSBCVar.id);
                Utility.insertErrorLogIntegration3
                ('500','Mashery Authorization Failed',
                'SBCCommunicationTriggerHelper','Integration','findCommitmentDetails'
                ,'Inbound Call',request.getBody(),
                UserInfo.getUserId(),'SBCCommitment', String.valueOf(setSBCIds),sURL,'GET');
            }
            
        
    }
    
    /**
    * Method name  : callFromErrorLog
    * Description  : This method is called from error log
    *                for updating SBC Communications Object
    * Return Type  : void
    * Parameter    : HTTPResponse, String
    **/
    public static void callFromErrorLog(HTTPResponse response, String sNewInstancesId)
    {
        String sQuery = Utility.retrieveAllFieldsDynamicallyFromObjectForSOQL('SBC_Communications__c');
        
        
        if(sQuery <> null && sQuery <> '')
        sQuery = sQuery + ' where id in :sNewInstancesId';
        List<SBC_Communications__c> lstSBCCommRecords = Database.query(String.escapeSingleQuotes(sQuery));
        
        if(!lstSBCCommRecords.isEmpty())
        {
            Map<String, String> mapBeneficiaries = new Map<String, String>();
            for(SBC_Communications__c sbcCom : lstSBCCommRecords)
            {mapBeneficiaries.put(sbcCom.Beneficiary__r.Compass_Child_Key__c,sbcCom.Supporter__r.Legacy_Supporter_Id__c);}
            updateSBCWithCommitment(response, mapBeneficiaries, lstSBCCommRecords);
        }
    }
    
    /**
    * Method name  : updateSBCWithCommitment
    * Description  : This method is called to update SBC records
                     based on Commitment Details received from Compass
    *                
    * Return Type  : void
    * Parameter    : Set<Id>
    **/ 
    
    private static void updateSBCWithCommitment(HTTPResponse response, Map<String, String> mapBeneficiaries, List<SBC_Communications__c> lstSBCCommunications)
    {
        Map<SBC_Communications__c, String> mapSBCCommunication = new Map<SBC_Communications__c, String>();
        List<SBC_Communications__c> lstFinalSBCCommunication = new List<SBC_Communications__c>();
        Set<String> lstBeneficiaries = new Set<String>();
       
        String sCorrespondence ='';
        // Instantiate a new HTTP request, specify the method (GET) as well 
        //as the endpoint
        
       
        
            if(response.getStatus()=='OK')
            {
                //This has to be implemented once COMPASS Endpoint is available
                String sResponse = String.valueOf(response.getBody()); 
                //String sResponse = createMockResponses.createCommitmentMockResponse();
                if(sResponse <> null && sResponse <> '')
                {
                     sResponse = sResponse.replace('\n','');
                     sResponse = sResponse.replace(' ','');
                     sResponse = sResponse.replace('"CommitmentDetails":[{','');
                     sResponse = sResponse.removeEndIgnoreCase('}]}');
                     
                    if(!sResponse.contains('['))
                    {
                        sResponse = sResponse.replaceFirst(':',':[');  
                        sResponse+=']}';
                    }
                    else
                    {
                        sResponse+='}';    
                    }
                    sResponse = sResponse.trim();
                    List<Account> sObjAccount = JSONHandlerMethods.deserialize
                    (sResponse ,'CommitmentProcess');
                    Map<String, String> mapSponsors = new Map<String,String>();  
                    Map<String, String> mapCorrespondents = new Map<String, String>();
                    sResponse=sResponse.replace('"null"', 'null');
                    Map<String, String> mapBeneficiaryId = new Map<String, String>();
                    Set<String> setUnavailableSupporters = new Set<String>();
                    for(Account a: sObjAccount)
                    {
                        
                        if(mapBeneficiaries <> null && ((mapBeneficiaries.get(a.Recognitions_And_Accomplishments__c) == a.Name) || a.Site.contains(System.Label.Correspondent)) && mapBeneficiaries.containsKey(a.Recognitions_And_Accomplishments__c))
                        {
                            Integer iDaysInBetween = 0;
                            Integer iAllowedGap = 0;
                            if(a.Employer__c <> null)
                                {
                                    String[] sDateValue = a.Employer__c.split('-');
                                    String sFinalDate =  sDateValue.get(1) +'/'+sDateValue.get(2)+'/'+sDateValue.get(0);
                                    Date dtFinalDate = date.parse(sFinalDate);
                                    iDaysInBetween = dtFinalDate.daysBetween(system.today());
                                    iAllowedGap = Integer.valueOf(System.Label.CommitmentStopDate);
                                    
                                }
                            if(!mapBeneficiaryId.containsKey(a.Recognitions_And_Accomplishments__c) &&
                            (
                            (a.Site <> System.Label.Correspondent && a.Status__c <> System.label.Active && !mapCorrespondents.containsKey(a.Recognitions_And_Accomplishments__c)) || 
                            (mapSponsors.containsKey(a.Recognitions_And_Accomplishments__c) && a.Site == System.Label.Correspondent && a.Status__c == System.Label.Active) ||  
                            (mapCorrespondents.containsKey(a.Recognitions_And_Accomplishments__c) && a.Site == System.Label.Sponsorship && a.Status__c == System.Label.Active) ||
                            (a.Site == System.Label.Correspondent && a.Status__c <> System.Label.Active && !mapSponsors.containsKey(a.Recognitions_And_Accomplishments__c))
                            ) && 
                            (a.Employer__c == null || iDaysInBetween >= iAllowedGap)) 
                             
                            {
                                if((!mapCorrespondents.isEmpty() || !mapSponsors.isEmpty())  && a.Status__c == System.Label.Active)
                                {
                                    mapBeneficiaryId.put(a.Recognitions_And_Accomplishments__c,System.Label.CorrespondentIssue);
                                }
                                //else if()
                                else
                                {
                                    mapBeneficiaryId.put(a.Recognitions_And_Accomplishments__c,System.Label.Inactive);
                                }
                            }
                            else
                            {
                                if((a.Site == System.Label.Correspondent || a.Site <> System.Label.Correspondent) && a.Status__c == System.Label.Active)
                                {
                                    mapBeneficiaryId.remove(a.Recognitions_And_Accomplishments__c);
                                }
                                                          
                            }
                            if(a.Site <> System.Label.Correspondent && a.Status__c == System.Label.Active)
                            {
                                mapSponsors.put(a.Recognitions_And_Accomplishments__c, System.Label.Active);
                            }
                            if(a.Site == System.Label.Correspondent && a.Status__c == System.Label.Active)
                            {
                                mapCorrespondents.put(a.Recognitions_And_Accomplishments__c, System.Label.Active);
                            }
                            
                            if(a.Site <> null)
                            {
                            if(a.Site.contains(System.Label.Correspondent))
                            {
                                sCorrespondence = System.Label.Correspondent_Communication;
                            }
                            else if(a.Site.contains(System.Label.Sponsorship))
                            {
                                sCorrespondence = System.Label.Sponsor_Communication;
                            }
                            }
                            //else
                            //{
                               // mapBeneficiaryId.remove(a.Recognitions_And_Accomplishments__c);
                                //mapBeneficiaryId.put(a.Recognitions_And_Accomplishments__c,a.Status__c);
                            //}
                            
                        }
                        setUnavailableSupporters.add(a.Recognitions_And_Accomplishments__c);
                        //lstBeneficiaries.add(a.Recognitions_And_Accomplishments__c);
                    }
                    
                    List<SBC_Communications__c> lstSBCCommRecords = lstSBCCommunications;
                    
                    for(SBC_Communications__c sbcRec :lstSBCCommRecords)
                    {
                        if(sbcRec.Status__c <> 'Exception')
                        {
                            if((mapBeneficiaryId <> null && !mapBeneficiaryId.isEmpty() && (mapBeneficiaryId.get(sbcRec.Beneficiary__r.Compass_Child_Key__c) <> null && mapBeneficiaryId.get(sbcRec.Beneficiary__r.Compass_Child_Key__c) <> System.Label.Active)) || (!setUnavailableSupporters.isEmpty() && !setUnavailableSupporters.contains(String.valueOf(sbcRec.Beneficiary__r.Compass_Child_Key__c))))
                            {
                                
                                if(mapBeneficiaryId.get(sbcRec.Beneficiary__r.Compass_Child_Key__c) == System.Label.CorrespondentIssue)
                                {
                                    mapSBCCommunication.put(sbcRec, String.valueOf(SBCCommunicationExceptionReason__c.getInstance(System.Label.CorrespondenceIssue).Status__c));
                                }
                                else
                                {
                                    mapSBCCommunication.put(sbcRec, String.valueOf(SBCCommunicationExceptionReason__c.getInstance(System.Label.Inactive_Commitment).Status__c));
                                }
                            }
                            else
                            {
                                if(sCorrespondence <> '')
                                sbcRec.Correspondence_Type__c = sCorrespondence;
                                
                                lstFinalSBCCommunication.add(sbcRec);
                            }
                        }
                    }
                    
                }
                
            }
            
        //}
        
        
        if(!lstFinalSBCCommunication.isEmpty())
        {
        
        
        getGlobalIdFromCI(lstFinalSBCCommunication);
        update lstFinalSBCCommunication;
        }
        if(mapSBCCommunication <> null 
        && !mapSBCCommunication.isEmpty())
        {
            SBCCommunicationStatusAssignment statusHandler = new SBCCommunicationStatusAssignment();
            statusHandler.assignStatusBasedOnCondition(mapSBCCommunication);
            List<SBC_Communications__c> lstUpdateRecords = new List<SBC_Communications__c>();
            lstUpdateRecords.addAll(mapSBCCommunication.keyset());
            try
            {
                 Utility.bToCheckSupporterStatus = false;
                update lstUpdateRecords;
            }
            catch(Exception ex)
            {
                //Error Log added here
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'SBC_Communications__c',String.valueOf(lstUpdateRecords),
                'SBCCommunicationTriggerHelper','findCommitmentDetails','Application',
                UserInfo.getUserId(),null,null);
            }
        }
        if(mapSBCCommunication <> null && !mapSBCCommunication.isEmpty())
        {
            SBCCommunicationStatusAssignment statusHandler = new SBCCommunicationStatusAssignment();
            statusHandler.assignStatusBasedOnCondition(mapSBCCommunication);
            List<SBC_Communications__c> lstUpdateRecords = new List<SBC_Communications__c>();
            lstUpdateRecords.addAll(mapSBCCommunication.keyset());
            try
            {
                Utility.bToCheckSupporterStatus = false;
                update lstUpdateRecords;
            }
            catch(Exception ex)
            {
                //Error Log to be added here
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'SBC_Communications__c',String.valueOf(lstUpdateRecords),
                'SBCCommunicationTriggerHelper','findCommitmentDetails','Application',
                UserInfo.getUserId(),null,null);
            }
        }
    }
    
    
    /**
    * Method name  : sendEmailForSBC
    * Description  : Use this method to send email using XMPie
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c>
    **/  
    
    private static void sendEmailForSBC(List<SBC_Communications__c> lstSBCComms){
        
        Map<SBC_Communications__c, Id> mapSupporterWithSBCIds = new Map<SBC_Communications__c,Id>();
        Set<Id> setSupporterIds = new Set<id>();
        for(SBC_Communications__c oSBCVar: lstSBCComms)
        {
            if(oSBCVar.Supporter__c <> null)
            {
                mapSupporterWithSBCIds.put(oSBCVar, oSBCVar.Supporter__c);
                setSupporterIds.add(oSBCVar.Supporter__c);
            }
        }
        
        Map<Id, String> mapSupporterPrefernce = new Map<Id, String>();
        
        
        for(Communication_Preference__c oComPrefVar : [select id, Account__c, Child_Letters_Medium__c 
        from Communication_Preference__c where Account__c in :setSupporterIds AND 
        (Account__r.Preferred_Email_Address__c!=null OR Account__r.Preferred_Address__c <> null) AND 
        ((Account__r.Do_Not_Contact__c=false) AND (Account__r.Do_not_Email__c=false) 
        AND (Account__r.Do_Not_Mail__c=false))])
        {
            if(oComPrefVar.Child_Letters_Medium__c <> null && oComPrefVar.Account__c <> null)
            {
                mapSupporterPrefernce.put(oComPrefVar.Account__c, oComPrefVar.Child_Letters_Medium__c); 
            }
        }
        List<SBC_Communications__c> lstFinalSBCRecordList = new List<SBC_Communications__c>();
        Set<Id> setSBCCommIds = new Set<Id>();
        
        for(SBC_Communications__c oSBCVar : mapSupporterWithSBCIds.keyset())
        {
            if(mapSupporterPrefernce <> null && mapSupporterPrefernce.get(oSBCVar.Supporter__c) <> null)
            {
                if(mapSupporterPrefernce.get(oSBCVar.Supporter__c) == System.Label.Email)
                oSBCVar.Template_ID__c = System.Label.Email;
                else
                oSBCVar.Template_ID__c = System.Label.Mail;
                
                setSBCCommIds.add(oSBCVar.id);
            }
            lstFinalSBCRecordList.add(oSBCVar);
        }
        
        
        
        if(!lstFinalSBCRecordList.isEmpty())
        {
            SendEmailUsingXMPie.sendEmailForSBC(lstFinalSBCRecordList, false);
        }
        
        
    }
    
    /**
    * Method name  : updateSBCLanguage
    * Description  : Use this method to send email using XMPie
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c>, Set<Id>, Set<Id>
    **/  
    
    public static void updateSBCLanguage(List<SBC_Communications__c> lstSBCCom,Set<Id> setSupporterId,Set<Id> setBeneficiaryId){
        
        List<Account> lstAccountVar=new List<Account>();
        lstAccountVar=[select Id,Primary_Language__c,recordtypeId from Account 
        where ID IN :setSupporterId OR ID IN :setBeneficiaryId]; 
        Map<Id,String> mapAccountCommDirection=new Map<Id,String>();
        Id S2BId=Utility.getRecordtype('Supporter To Beneficiary','SBC_Communications__c');
        for(Account oAccountVar:lstAccountVar)
        mapAccountCommDirection.put(oAccountVar.Id,oAccountVar.Primary_Language__c);
        
        for(SBC_Communications__c oSBCVar: lstSBCCom)
        {
            if(S2BId==oSBCVar.recordTypeId)
            {
                
                if(oSBCVar.Original_Language__c==null || oSBCVar.Translation_Language__c==null)
                {                    
                    if(mapAccountCommDirection.get(oSBCVar.Supporter__c)!=null)
                    oSBCVar.Original_Language__c=mapAccountCommDirection.get(oSBCVar.Supporter__c);
                    if(mapAccountCommDirection.get(oSBCVar.Beneficiary__c)!=null)
                    oSBCVar.Translation_Language__c=mapAccountCommDirection.get(oSBCVar.Beneficiary__c);
                }
                
                
            }
            else 
            {                
                if(oSBCVar.Original_Language__c==null || oSBCVar.Translation_Language__c==null)
                {                    
                    if(mapAccountCommDirection.get(oSBCVar.Supporter__c)!=null)
                    oSBCVar.Translation_Language__c=mapAccountCommDirection.get(oSBCVar.Supporter__c);
                    if(mapAccountCommDirection.get(oSBCVar.Beneficiary__c)!=null)
                    oSBCVar.Original_Language__c=mapAccountCommDirection.get(oSBCVar.Beneficiary__c);
                }
            }
            
        }
    }
     
    /**
    * Method name  : getGlobalIdFromCI
    * Description  : This method is called to get Global Id from CI org.
    *                
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c>
    **/  
    
    public static void getGlobalIdFromCI(List<SBC_Communications__c> lstSBC){
        
        
        Set<Id> setSBCIds=new Set<Id>();
        for(SBC_Communications__c oSBCVar :lstSBC)
        {
            if(oSBCVar.Status__c <> System.Label.Exception && (oSBCVar.SBC_Global_Id__c==null || oSBCVar.SBC_Global_Id__c==''))
            setSBCIds.add(oSBCVar.Id);
        }
        if(!setSBCIds.isEmpty())
        {
            String sResponse=generateJSONForSBCCommunicationToCI.generateJSONForCI(setSBCIds, false);
            
 
            Http http = new Http();

            // Instantiate a new HTTP request, specify the method (GET) as well 
            //as the endpoint
            HttpRequest request = new HttpRequest();
            Integration_Endpoints__c oConnector = 
            Integration_Endpoints__c.getAll().get('SBC CI Endpoint URL'); 
            //Getting Endpoint details from custom setting            
            request.setMethod('POST');
            String sURL = oConnector.Endpoint_URL__c+'?api_key='+oConnector.Authorization_Code__c;
            request.setEndpoint(sURL);
            request.setBody(sResponse);
            request.setTimeout(120000); 
            
            // Send the request, and return a response
                request.setHeader('Authorization',new MasheryOAuthGenerator().generateMasheryOAuth ());
                request.setHeader('Content-Type','application/json');
            Utility.bToCheckSupporterStatus=false;
            //Adding authorization Header
            HttpResponse response = http.send(request);
            if((response.getStatus()=='OK') || (response.getStatus()=='Created'))
            {
                populateSBCCommunicationValues(response);
            } 
            else
            {   
                Utility.insertErrorLogIntegration3(response.getStatus(),'Call out Failed','SBCCommunicationTriggerHelper','Integration',
                'S2BCI','Insert Call',
                sResponse,UserInfo.getUserId(),
                'getGlobalIdFromCI',null,sURL,'POST');
                
                
                Utility.bToCheckSupporterStatus = false;
                //This update has been made to ensure the Correspondence Type of 
                //SBC Communication records to be populated from Commitment
                //even if the CI call fails for Global Id.
                //This method will execute only when the commitment scenario 
                //has been successfully executed
                update lstSBC;
                
            }
            
        }
    }
    
    public static void populateSBCCommunicationValues(HTTPResponse response)
    {
        List<SBC_Communications__c>  lstSBCComm=((List<SBC_Communications__c>)JSONHandlerMethods.deserialize
                (response.getBody().trim() ,'SBCCommGlobalIdCIUpdateFieldProcess'));
                
                Set<String > setAccounts=new Set<String>();
                if(lstSBCComm.size()>0)
                {                    
                    Map<String,String> mapSBCNameGBId=new Map<String,String>();
                    for(SBC_Communications__c oSBCVar: lstSBCComm)
                    mapSBCNameGBId.put(oSBCVar.Communication_Source__c,oSBCVar.SBC_Global_Id__c);
                    Map<String,SBC_Communications__c> mapSBCNameVar=New  Map<String,SBC_Communications__c>();
                    List<SBC_Communications__c> lstSBCCommVar=[select Id,Name from SBC_Communications__c where Name  IN :mapSBCNameGBId.keySet()]; 
                    for(SBC_Communications__c oSBCVar: lstSBCCommVar)
                    mapSBCNameVar.put(oSBCVar.name,oSBCVar);  
                    
                    for(String sSBCName: mapSBCNameGBId.keySet())
                    {
                        SBC_Communications__c oSBCTmpVar=mapSBCNameVar.get(sSBCName);
                        oSBCTmpVar.SBC_Global_Id__c=mapSBCNameGBId.get(sSBCName);
                        
                    }
                    if(mapSBCNameVar.size()>0)     
                    upsert mapSBCNameVar.values();
                    
                    
                    
                }                
             
    }    
    
        
    /**
    * Method name  : updateInappropriateCorrospondence
    * Description  : This method is called to update 
                     Inappropriate Corrospondence related to supporter
    *                
    * Return Type  : void
    * Parameter    : Set<Id>
    **/  
    
    public static void updateInappropriateCorrospondence(Set<Id> setSupporterId){
        
        
        Map<Id,Account> mapSupporter=new Map<Id,Account>([select Id,Inappropriate_Correspondence__c from Account where Id IN :setSupporterId]);
        List<AggregateResult> lstAggr=[select Count(Id) noOfSBC,Supporter__c supporter from SBC_Communications__c where Supporter__c IN :setSupporterId
        and Communication_Issue_Source__c !=null and Status__c='Cancelled' group by Supporter__c];
        
        for(AggregateResult aggrVar: lstAggr)
        {
            if(aggrVar.get('noOfSBC')!=null)
            {
                Id supporterId=String.valueOf(aggrVar.get('supporter'));
                if(mapSupporter.get(supporterId)!=null)
                {
                    mapSupporter.get(supporterId).Inappropriate_Correspondence__c=(Integer)aggrVar.get('noOfSBC');
                    
                }
                
            }
            
        }
        
        try
        { 
            if(mapSupporter.values().size()>0)
            update mapSupporter.values();
        }
        Catch(Exception ex)
        {
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
            ex.getStackTraceString(),'Account',String.valueOf(mapSupporter),
            'SBCCommunicationTriggerHelper','updateInappropriateCorrospondence','Application',
            UserInfo.getUserId(),null,null);
        }  
        
    }
}