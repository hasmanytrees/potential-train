/*******************************************************************************
Name             : SBCCommunicationTriggerHandler
Description      : Trigger Handler class used to initiate other helper class 
                based on condition
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan                30/10/2014            Created
*******************************************************************************/


public without Sharing class SBCCommunicationTriggerHandler
{

    private boolean bIsBeneficiaryValidationActive = false;
    private boolean bIsSupporterValidationActive = false;
    private Map<Id, String> mapAccountsStatus = new Map<Id, String>();
    private Id beneficiaryToSupporterId = 
    Utility.getRecordType(System.Label.B2S,System.Label.SBCCommunicationObject);
    private Set<Id> setAccounts = new Set<Id>();
    private Set<Id> setSBCWithAccountException = new Set<Id>();
    private Set<Id> setFinalLetters = new Set<Id>();
    private static set<Id> setInappropriateSBCIdsToCI = new set<Id>();
    
    /**
    * Method name  : onBeforeInsertSBCCom 
    * Description  : Use this method to filter out intial set of records 
    *                based on some primary conditions 
    *                and move to corresponding validation                
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c>, Boolean,
    *                Map<ID,SBC_Communications__c>, map<ID,SBC_Communications__c>
    **/
    
    Public void onBeforeInsertSBCCom ( List<SBC_Communications__c> 
    lstNewSBCComRecs, Boolean isInsert ,Map<ID,SBC_Communications__c  > 
    mapOldSBCComRecords , map<ID,SBC_Communications__c  > mapNewSBCComRecords)
    {
        
        if( !isInsert ) 
        {
            lstNewSBCComRecs = new List<SBC_Communications__c> () ;
            
            for(Id oSBCComRecId: mapNewSBCComRecords.keyset())
            {
                if(mapOldSBCComRecords <> null 
                && (mapOldSBCComRecords.get(oSBCComRecId).Status__c == System.Label.Exception 
                && mapOldSBCComRecords.get(oSBCComRecId).Status__c <> 
                mapNewSBCComRecords.get(oSBCComRecId).Status__c 
                && !mapNewSBCComRecords.get(oSBCComRecId).Commitment_Link_Override__c 
                && (mapNewSBCComRecords.get(oSBCComRecId).Correspondence_Type__c 
                <> System.Label.EncouragerCommunication) 
                && !(mapNewSBCComRecords.get(oSBCComRecId).Exception_Reason__c 
                <> null)))
                {
                    lstNewSBCComRecs.add(mapNewSBCComRecords.get(oSBCComRecId));
                }
                
                if(mapOldSBCComRecords <> null && (mapOldSBCComRecords.get(oSBCComRecId).Status__c == System.Label.Exception       
                            && mapOldSBCComRecords.get(oSBCComRecId).Status__c <> mapNewSBCComRecords.get(oSBCComRecId).Status__c       
                            && mapOldSBCComRecords.get(oSBCComRecId).Exception_Reason__c == System.Label.PastCommunicationIssues) )      
                {       
                        
                    setInappropriateSBCIdsToCI.add(oSBCComRecId);       
                }
            }
        }
        
        bIsSupporterValidationActive = Trigger_Methods_Activation__c.getInstance
        (System.Label.SupporterValidationCheck).
        Is_Trigger_Method_Required_In_Insert__c ;
        
        bIsBeneficiaryValidationActive = Trigger_Methods_Activation__c.getInstance
        (System.Label.BeneficiaryValidationCheck).Is_Trigger_Method_Required_In_Insert__c ;
        
        if(bIsSupporterValidationActive || bIsBeneficiaryValidationActive) 
        {       
            Set<Id> setSupporters = new  Set<Id>();
            for(SBC_Communications__c oSBCVar: lstNewSBCComRecs)
            {
                if((oSBCVar.Correspondence_Type__c <> System.Label.EncouragerCommunication) 
                && oSBCVar.Supporter__c <> null)
                {
                    setAccounts.add(oSBCVar.Supporter__c);
                    setSupporters.add(oSBCVar.Supporter__c);
                }
                if(oSBCVar.Exception_Reason__c <> null 
                && oSBCVar.Exception_Reason__c <> '' 
                && oSBCVar.Status__c == System.Label.Exception)
                {
                    oSBCVar.Status__c = '';
                }
                if((oSBCVar.Correspondence_Type__c <> System.Label.EncouragerCommunication) 
                && oSBCVar.Beneficiary__c <> null)
                {
                    setAccounts.add(oSBCVar.Beneficiary__c);
                }
            }
            
            if(!setAccounts.isEmpty())
            {
                for(Account oAccVar: [select id, Status__c, 
                Special_Handling__c, Inappropriate_Correspondence__c 
                from Account where id in :setAccounts])
                {
                    if(oAccVar.Status__c <> null)
                    {
                        mapAccountsStatus.put(oAccVar.id, oAccVar.Status__c);                        
                    } 
                    if((oAccVar.Inappropriate_Correspondence__c <> null 
                    && oAccVar.Inappropriate_Correspondence__c >= Integer.valueOf(System.Label.InappropriateCorrespondenceLimit)) || 
                    (oAccVar.Special_Handling__c <> null 
                    && oAccVar.Special_Handling__c <> '' 
                    && oAccVar.Special_Handling__c.contains(System.Label.CorrespondenceProhibited)))
                    {
                        setSBCWithAccountException.add(oAccVar.id);
                    }                   
                }
            }
            if(!setSupporters.isEmpty())
            {
                for(SBC_Communications__c oSBCVar: [select id, Supporter__c, 
                Status__c from SBC_Communications__c 
                where Supporter__c in :setSupporters and 
                Exception_Reason__c = :System.Label.PastCommunicationIssues 
                and LastModifiedDate > 
                :System.Today().addDays(Integer.valueOf
                (System.Label.AccountExceptionDays))])
                {
                    if(oSBCVar.Status__c == System.Label.Exception)
                    {
                        setSBCWithAccountException.add(oSBCVar.Supporter__c);
                    }
                }
            }
            
            if(!isInsert)
            {
                setSBCWithAccountException.clear();
            }
            ValidateSBCComRecords(lstNewSBCComRecs)  ; 
        }
    }

    /**
    * Method name  : ValidateSBCComRecords 
    * Description  : This method is used for running 
    *                basic validation checks on SBC Record
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c>
    **/

    Private void ValidateSBCComRecords (List<SBC_Communications__c> 
    lstNewSBCComRecs) 
    {
        
        Map<SBC_Communications__c, String> mapSBCCommunicationsException = 
        new Map<SBC_Communications__c, String>();
        
        For( SBC_Communications__c oSBCComRec : lstNewSBCComRecs ) 
        {
            
            if(bIsSupporterValidationActive && oSBCComRec.Supporter__c == null 
            && oSBCComRec.Correspondence_Type__c <> System.Label.EncouragerCommunication)
            {
                mapSBCCommunicationsException.put(oSBCComRec, 
                SBCCommunicationExceptionReason__c.getInstance(System.Label.NoSupporter).Status__c);                
                
            }
            
            else if(oSBCComRec.Correspondence_Type__c <> System.Label.EncouragerCommunication 
            && bIsSupporterValidationActive && oSBCComRec.Supporter__c <> null 
            && mapAccountsStatus <> null 
            && mapAccountsStatus.get(oSBCComRec.Supporter__c) <> null 
            && mapAccountsStatus.get(oSBCComRec.Supporter__c).toLowerCase() == System.Label.Inactive.toLowerCase())
            {
                mapSBCCommunicationsException.put(oSBCComRec, 
                SBCCommunicationExceptionReason__c.getInstance(System.Label.InactiveSupporter).Status__c);
                
            }
            
            else if(oSBCComRec.Correspondence_Type__c <> System.Label.EncouragerCommunication 
            && bIsBeneficiaryValidationActive && oSBCComRec.Beneficiary__c == null)
            {
                mapSBCCommunicationsException.put(oSBCComRec, 
                SBCCommunicationExceptionReason__c.getInstance(System.Label.NoBeneficiary).Status__c);
            }
            else if(oSBCComRec.Correspondence_Type__c <> System.Label.EncouragerCommunication 
            && bIsBeneficiaryValidationActive 
            && oSBCComRec.Beneficiary__c <> null 
            && mapAccountsStatus <> null 
            && mapAccountsStatus.get(oSBCComRec.Beneficiary__c) <> null 
            && mapAccountsStatus.get(oSBCComRec.Beneficiary__c).toLowerCase() == System.Label.Inactive.toLowerCase())
            {
                if(!oSBCComRec.Final_Letter__c)
                {
                    mapSBCCommunicationsException.put(oSBCComRec, 
                    SBCCommunicationExceptionReason__c.getInstance(System.Label.InactiveBeneficiary).Status__c);  
                }
                
            }
            else if(oSBCComRec.Correspondence_Type__c <> System.Label.EncouragerCommunication 
            && oSBCComRec.RecordTypeId <> beneficiaryToSupporterId  
            && !setSBCWithAccountException.isEmpty() 
            && oSBCComRec.Supporter__c <> null 
            && setSBCWithAccountException.contains(oSBCComRec.Supporter__c))
            {
                oSBCComRec.Status__c = System.Label.Exception;
                oSBCComRec.Exception_Reason__c = System.Label.PastCommunicationIssues;
            }
            if(oSBCComRec.Final_Letter__c)
            {
                mapSBCCommunicationsException.put(oSBCComRec, 
                SBCCommunicationExceptionReason__c.getInstance(System.Label.FinalLetter).Status__c);
                setFinalLetters.add(oSBCComRec.id);
            }
            
            
        }
        
        if(!mapSBCCommunicationsException.IsEmpty())
        {
            SBCCommunicationStatusAssignment statusHandler = 
            new SBCCommunicationStatusAssignment();
            statusHandler.assignStatusBasedOnCondition(mapSBCCommunicationsException);
            if(setFinalLetters.isEmpty()) 
            Utility.bToCheckSupporterStatus = false;    
        }        
        
        
    }
    
    /**
    * Method name  : setLastCorrespondenceDate
    * Description  : Use this method to set last corrsopondence Date
            
    * Return Type  : void
    * Parameter    : Map<Id,SBC_Communications__c>, Map<Id,SBC_Communications__c>, 
    *                List<SBC_Communications__c>
    **/  
    
    public static void setLastCorrespondenceDate(Map<Id,SBC_Communications__c> mapNewSBCComm,
    Map<Id,SBC_Communications__c> mapOldSBCComm,List<SBC_Communications__c> lstNewComm)
    {
        
        String sS2BrecordtypeId=
        Utility.getRecordtype(System.Label.S2B,System.Label.SBCCommunicationObject);
        Set<Account> setBeneficiary=new Set<Account>();
        List<SBC_Communications__c> lstSBCTemp=new List<SBC_Communications__c>();
        if(mapOldSBCComm!=null)
        lstSBCTemp.addAll(mapNewSBCComm.values());
        else
        lstSBCTemp.addAll(lstNewComm);
        
        
        for(SBC_Communications__c oSBCVar : lstSBCTemp){
            if((mapOldSBCComm!=null)
            &&(mapNewSBCComm.get(oSBCVar.Id).Beneficiary__c!=null)
            &&( mapNewSBCComm.get(oSBCVar.Id).Beneficiary__c!=
            mapOldSBCComm.get(oSBCVar.Id).Beneficiary__c)
            &&(oSBCVar.recordtypeId==sS2BrecordtypeId))     
            setBeneficiary.add(new Account(Id=oSBCVar.Beneficiary__c,
            Last_Correspondence_Date__c=System.today()));
            else if((mapOldSBCComm==null)&&(oSBCVar.Beneficiary__c!=null) )
            setBeneficiary.add(new Account(Id=oSBCVar.Beneficiary__c,
            Last_Correspondence_Date__c=System.today()));
        }
        
        if(setBeneficiary.size()>0)
        {
            List<Account> lstUpdateAccount = new List<Account>();
            lstUpdateAccount.addAll(setBeneficiary);
            try{
                update lstUpdateAccount;
            }
            Catch(Exception ex) {
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),System.label.Account,
                String.valueOf(lstUpdateAccount),
                'SBCCommunicationTriggerHandler',
                'setLastCorrespondenceDate','Application',
                UserInfo.getUserId(),String.valueOf(mapNewSBCComm),
                String.valueOf(mapOldSBCComm));    
            }
            
        }
        
    }  
    
    
    /**
    * Method name  : setFinalDeliveryPrefernce
    * Description  : Use this method to set Final Delivery Preference Value
            
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c>
    **/  
    
    public static void setFinalDeliveryPrefernce(List<SBC_Communications__c> 
    lstNewSBCCommunications)
    {
        Set<Id> setSupporters = new Set<Id>();
        Id beneficaryToSupporterId = 
        Utility.getRecordType(System.Label.B2S, System.Label.SBCCommunicationObject);
         Id SupporterTobeneficaryId = 
         Utility.getRecordType(System.Label.S2B, System.Label.SBCCommunicationObject);
         
        Boolean bDeliveryOverride = Trigger_Methods_Activation__c.getInstance
        (System.Label.OverideDeliveryPreferenceOfSBC).
        Is_Trigger_Method_Required_In_Insert__c;
        
        Boolean bFindSupporterPrefernce = Trigger_Methods_Activation__c.getInstance
        (System.Label.FindSupporterPreference).
        Is_Trigger_Method_Required_In_Insert__c;
        
        
        
        for(SBC_Communications__c oSBCVar: lstNewSBCCommunications)
        {
            if(oSBCVar.Supporter__c <> null 
            && String.valueOf(oSBCVar.RecordtypeId).contains
            (String.valueOf(beneficaryToSupporterId)))
            {
                setSupporters.add(oSBCVar.Supporter__c);
            }
            // added for gift scanned 
            if( String.valueOf(oSBCVar.RecordtypeId).contains
            (String.valueOf(SupporterTobeneficaryId )) && 
                oSBCVar.Gift_Not_Scanned_Not_Eligible__c 
                && oSBCVar.Supporter__c <> null ) {
                setSupporters.add(oSBCVar.Supporter__c);
            } 
            // for gift scanned ends here            
        }
        if(!setSupporters.isEmpty())
        {   
            
            Map<String,Map<Id, String>> mapRelatedPreferencesOfSupportersAll = 
            new Map<String,Map<Id, String>>();
            Map<Id,String> mapRelatedPreferencesOfSupporters = 
            new Map<Id, String>();
            Map<Id, String> mapSupporterPrefernce = 
            new Map<Id, String>();
            Map<Id, String> mapSupporterPrefernceEmail = 
            new Map<Id, String>();
            Map<Id, String> mapSupporterPrefernceAddress = 
            new Map<Id, String>();
            Map<String,Map<Id, String>> mapSupporterPrefernceFinalAll= 
            new Map<String,Map<Id, String>>();
            Map<Id, String> mapSupporterPrefernceFinal = 
            new Map<Id, String>();
            
            mapRelatedPreferencesOfSupportersAll = 
            SBCPreferenceHelper.getSupporterPreferences(setSupporters);
            
            if(mapRelatedPreferencesOfSupportersAll.get(System.Label.Preference)!=null 
            && mapRelatedPreferencesOfSupportersAll.get(System.Label.Preference).size()>0)
            {
                mapRelatedPreferencesOfSupporters=
                mapRelatedPreferencesOfSupportersAll.get(System.Label.Preference); 
                mapSupporterPrefernceEmail =
                mapRelatedPreferencesOfSupportersAll.get(System.label.Email); 
                mapSupporterPrefernceAddress =
                mapRelatedPreferencesOfSupportersAll.get(System.Label.Mail); 
            }
            if(!mapRelatedPreferencesOfSupporters.isEmpty() 
            && bFindSupporterPrefernce)
            {
                mapSupporterPrefernceFinalAll= 
                SBCPreferenceHelper.overrideDeliveryPref(mapRelatedPreferencesOfSupporters);
            }
          
            if(mapSupporterPrefernceFinalAll.get(System.Label.Preference)!=null 
            && mapSupporterPrefernceFinalAll.get(System.Label.Preference).size()>0)
            {
                mapSupporterPrefernce =
                mapSupporterPrefernceFinalAll.get(System.Label.Preference); 
              
                mapSupporterPrefernceEmail=
                mapSupporterPrefernceFinalAll.get(System.Label.Email); 
                mapSupporterPrefernceAddress =
                mapSupporterPrefernceFinalAll.get(System.Label.Mail); 
            }
             
           
           
            mapSupporterPrefernceFinal= 
            SBCPreferenceHelper.setFianlDeliveryPreference(
            mapRelatedPreferencesOfSupporters ,mapSupporterPrefernce );
            if((mapSupporterPrefernceFinal.size()>0) && bDeliveryOverride)
            {
                for(SBC_Communications__c oSBCComVar : lstNewSBCCommunications)
                {
                    if(mapSupporterPrefernceFinal.get(oSBCComVar.Supporter__c) <> null)
                    {
                        oSBCComVar.Final_Delivery_Preference__c = 
                        mapSupporterPrefernceFinal.get(oSBCComVar.Supporter__c);
                        oSBCComVar.Preferred_Email__c= 
                        mapSupporterPrefernceEmail .get(oSBCComVar.Supporter__c);
                        oSBCComVar.Preferred_Address__c= 
                        mapSupporterPrefernceAddress .get(oSBCComVar.Supporter__c);
                    }
                }
            }
        }
    }  
    

    /* Method name  : updateSBCLanguage
    * Description  : Use this method to set Original and Translation Language 
    *                based on Supporter and Beneficiary            
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c>, Boolean  
    **/  
    
    public static void updateSBCLanguage(List<SBC_Communications__c> 
    lstNewComm , Boolean bIsInsert){
        if(bIsInsert && 
        Trigger_Methods_Activation__c.getInstance(System.Label.updateSBCLanguage).Is_Trigger_Method_Required_In_Insert__c)
        {
            Set<Id> setSupporterId=new Set<Id>();
            
            Set<Id> setBeneficiaryId=new Set<Id>();
            
            for(SBC_Communications__c oSBCVar : lstNewComm)
            {                
                if((oSBCVar.Supporter__c)!=null)
                setSupporterId.add(oSBCVar.Supporter__c);  
                if((oSBCVar.Beneficiary__c)!=null)
                setBeneficiaryId.add(oSBCVar.Beneficiary__c);  
                
            }
            if( setSupporterId.size()>0 || setBeneficiaryId.size()>0)
            SBCCommunicationTriggerHelper.updateSBCLanguage(lstNewComm,
            setSupporterId,setBeneficiaryId);
        }  
    }
    /**
    * Method name  : UpdateInappropriateCorrespondence 
    * Description  : This method is called to update 
                     Inappropriate Corrospondence related to supporter
    *                
    * Return Type  : void
    * Parameter    : Map<Id,SBC_Communications__c>,Map<Id,SBC_Communications__c>,
    List<SBC_Communications__c>
    **/  
    
    public static void UpdateInappropriateCorrespondence (Map<Id,SBC_Communications__c> mapNewSBC,
    Map<Id,SBC_Communications__c> mapOldSBC,List<SBC_Communications__c> lstSBC)
    {
        
        Map<Id,Integer> MapSupporterId=new Map<Id,Integer>();
        Set<Id> setSupporterIds=new Set<Id>();
        for(SBC_Communications__c oSBCVar: lstSBC)
        {
            if(mapOldSBC!=null)
            {                
                if(oSBCVar.Status__c==System.Label.Cancelled 
                && mapNewSBC.get(oSBCVar.Id).Communication_Issue_Source__c!=null 
                && mapOldSBC.get(oSBCVar.Id).Status__c!=
                mapNewSBC.get(oSBCVar.Id).Status__c)
                {                    
                    if(oSBCVar.Supporter__c!=null)
                    setSupporterIds.add(oSBCVar.Supporter__c);
                }
            }
            
            else 
            {                
                if((oSBCVar.Communication_Issue_Source__c!=null)&& 
                (oSBCVar.Status__c==System.Label.Cancelled))
                {                    
                    if(oSBCVar.Supporter__c!=null)
                    {   
                        setSupporterIds.add(oSBCVar.Supporter__c);
                    }
                }
            }
        }                                                          
        if(setSupporterIds.size()>0) 
        SBCCommunicationTriggerHelper.updateInappropriateCorrospondence(setSupporterIds);    
        
    }

    /**
    * Method name  : sendSBCComToExternalSystem
    * Description  : This method is called to Send  
                     Send SBC Communication to CI or XMPie
    *                
    * Return Type  : void
    * Parameter    : List<SBC_Communications__c> , Map<Id,SBC_Communications__c> , Boolean
    **/ 

    public static void sendSBCComToExternalSystem (List<SBC_Communications__c> 
    lstNewSBCComRecords ,Map<Id,SBC_Communications__c> MapOldSBCComRecords , Boolean bIsInsert ) 
    {
        Set<Id> setSBCCommId = new Set<Id>();
        Id beneficaryToSupporterId = 
        Utility.getRecordType(System.Label.B2S, System.Label.SBCCommunicationObject);
        Id SupporterTobeneficaryId = 
        Utility.getRecordType(System.Label.S2B, System.Label.SBCCommunicationObject);
        Set<Id> setBeneficiaryIds = new Set<Id>(); 
        Set<Id> setSupporterLegacyIds = new Set<Id>(); 
        Set<Id> setSBCCommunicationIds = new Set<Id>();   
        Set<Id> setSBCFinalIds = new Set<Id>();
        
        for(SBC_Communications__c oSBCComRec: lstNewSBCComRecords)
        {
            if(!(oSBCComRec.Exception_Reason__c <> null) 
            && oSBCComRec.Correspondence_Type__c <> System.Label.EncouragerCommunication 
            && ((MapOldSBCComRecords == null) || 
            (MapOldSBCComRecords.get(oSBCComRec.id).Status__c == System.Label.Exception 
            && oSBCComRec.Status__c <> System.Label.Exception)))
            {
                setSBCCommId.add(oSBCComRec.id); 
                setBeneficiaryIds.add(oSBCComRec.Beneficiary__c);
                setSupporterLegacyIds.add(oSBCComRec.Supporter__c);
            }
            
            //added for gift not scanned 
            if(oSBCComRec.RecordTypeId == SupporterTobeneficaryId 
            && oSBCComRec.Correspondence_Type__c <> System.Label.EncouragerCommunication 
            && oSBCComRec.Status__c <> System.Label.Exception
            && (( bIsInsert  && oSBCComRec.Gift_Not_Scanned_Not_Eligible__c )  
            || ( !bIsInsert  
            && MapOldSBCComRecords.get(oSBCComRec.id).Status__c == System.Label.Exception 
            && oSBCComRec.Gift_Not_Scanned_Not_Eligible__c )
            || ( !bIsInsert  
            && (! MapOldSBCComRecords.get(oSBCComRec.id).Gift_Not_Scanned_Not_Eligible__c)
            && oSBCComRec.Gift_Not_Scanned_Not_Eligible__c )) && !oSBCComRec.Send_For_Print_Using_Batch__c)
            {
                setSBCCommunicationIds.add(oSBCComRec.id); // added for gift scanned 
            }

            // ends for gift scanned 
            if((oSBCComRec.RecordTypeId == beneficaryToSupporterId  
            && oSBCComRec.Status__c == System.Label.Complete_Delivered) && !oSBCComRec.Send_For_Print_Using_Batch__c )
            {
                setSBCCommunicationIds.add(oSBCComRec.id);
            }
            else  if(oSBCComRec.RecordTypeId == beneficaryToSupporterId         
            && ((MapOldSBCComRecords!=null &&
             MapOldSBCComRecords.get(oSBCComRec.Id).Date_Physical_Received__c!=oSBCComRec.Date_Physical_Received__c 
             && oSBCComRec.Date_Physical_Received__c!=null)     
            || (oSBCComRec.Date_Physical_Received__c!= null)) && !oSBCComRec.Send_For_Print_Using_Batch__c)
            {
                setSBCCommunicationIds.add(oSBCComRec.id);
            }
            if(!(oSBCComRec.SBC_Global_Id__c <> null && oSBCComRec.SBC_Global_Id__c <> ''))
            {
                setSBCFinalIds.add(oSBCComRec.id);
            }
            
        }
        if(Trigger_Methods_Activation__c.getInstance(System.Label.CommitmentValidationCheck).Is_Trigger_Method_Required_In_Insert__c)
        {
            Utility.bToCheckSupporterStatus =false;
            
            if(!setSBCCommId.isEmpty() && !setBeneficiaryIds.isEmpty())
            {              
                List<Account> lstAccountVar=new List<Account>();
                Map<Id,Account> mapAccount=new Map<Id,Account>();
                lstAccountVar=[select Id,Legacy_Supporter_Id__c from Account 
                where Id IN :setSupporterLegacyIds and 
                Legacy_Supporter_Id__c !=null];
                if(lstAccountVar.size()>0){
                 mapAccount.putAll(lstAccountVar);
                Set<String> setSupporterIdFinal=new Set<String>();
                for(Account oAccountVar: lstAccountVar)
                  setSupporterIdFinal.add(
                  mapAccount.get(oAccountVar.Id).Legacy_Supporter_Id__c );
               if(setSupporterIdFinal.size()>0)
                 SBCCommunicationTriggerHelper.retrieveOnlyCommitmentDetails(
                 setSupporterIdFinal,setSBCCommId); 
              }
            
            }
            else if(!setSBCFinalIds.isEmpty() || !setInappropriateSBCIdsToCI.isEmpty()) {
                SBCCommunicationTriggerHelper.sendDirectlyToCI(setSBCFinalIds);
            }
            else if(!setSBCFinalIds.isEmpty())
            {
                SBCCommunicationTriggerHelper.sendDirectlyToCI(setSBCFinalIds);                
            } 
        }
        else
        {
            if(!setSBCFinalIds.isEmpty()) 
                SBCCommunicationTriggerHelper.sendDirectlyToCI(setSBCFinalIds);
        }
        
        if(!setSBCCommunicationIds.isEmpty())
        {
            SBCCommunicationTriggerHelper.sendSBCToXMPie(setSBCCommunicationIds);
        }

    }
    
}