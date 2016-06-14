/*******************************************************************************
Name             : AccountTriggerHandler
Description      : Trigger Handler class used to initiate other helper class 
                based on condition
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                            & optimization
Subhojit                29/09/2015            Modified for R3 Changes     
Apurva                  18/10/2015            Changes made for COR0001428                                        
*******************************************************************************/

public with Sharing class AccountTriggerHandler{
    
    /**
    * Method name  : onInsertUpdateAssignOwner
    * Description  : Use this method to initiate helper class for owner Account 
                    Assignment
    *                
    * Return Type  : void
    * Parameter    : List<Account>
    **/
    public static void onInsertUpdateAssignOwner(List<Account> lstNew){
        if(Trigger_Methods_Activation__c.getInstance('onInsertUpdateAssignOwner').Is_Trigger_Method_Required_In_Insert__c)
        {
            String sRecordTypeBenId=Utility.getRecordtype('Beneficiary','Account');
            
            List<Account> lstAccount= new List<Account>();
            for(Account oAccountVar: lstNew){
                
                if(oAccountVar.recordTypeId!=Utility.getRecordtype
                        (System.label.Agency,System.label.Account) && 
                   oAccountVar.recordTypeId != sRecordTypeBenId )
                lstAccount.add(oAccountVar);
            }
            
            if(lstAccount.size()>0)
            //Calling Account Assignment Handler Class
            AccountOwnerAssignmentHelper.setNewAccountOwners(lstNew);   
        }
    }

    /**
    * Method name  : addCommPrefRule
    * Description  : Use this method to initiate helper class to create default 
    *                Communication Preferences records.                
    * Return Type  : Void
    * Parameter    : Set<Id>
    **/  
    
    public static void addCommPrefRule(List<Account> lstNew){
        if(Trigger_Methods_Activation__c.getInstance('addCommPrefRule').Is_Trigger_Method_Required_In_Insert__c)
        {
            String sRecordTypeBenId=Utility.getRecordtype('Beneficiary','Account');
            
            set<ID> setAccIds = new set<ID> ();
            for(Account oAccountVar: lstNew){
                
                if(oAccountVar.recordTypeId != sRecordTypeBenId )
                    setAccIds.add( oAccountVar.ID );
            }
            IF( setAccIds!= NULL && setAccIds.size() > 0 )   
            CommunicationHandler.addCommunicationPref(setAccIds);
        }   
    }
    
    /**
    * Method name  : followAndUnfollowHandler
    * Description  : Use this method to initiate helper class to follow and 
    *                unfollow record for account Owner.                
    * Return Type  : Void
    * Parameter    : Map<Id,Account>,Map<Id,Account>
    **/
    public static void followAndUnfollowHandler(Map<Id,Account> mapNewAccount,
    Map<Id,Account> mapOldAccount){
        if(Trigger_Methods_Activation__c.getInstance('followAndUnfollowHandler').Is_Trigger_Method_Required_In_Insert__c 
                || Trigger_Methods_Activation__c.getInstance('followAndUnfollowHandler').Is_Trigger_Method_Required_In_Update__c)
        {
            Map<Id,Account> mapNewAccountVar=new Map<Id,Account>();
            Map<Id,Account> mapOldAccountVar=new Map<Id,Account>();
            User oUser=[select Id from User where 
            Name=:System.label.MassSegmentUser];
            
            String sRecordTypeBenId=Utility.getRecordtype('Beneficiary','Account');
            
            for(Account oAccountVar: mapNewAccount.values()){
                
                if( oAccountVar.recordTypeId != sRecordTypeBenId ) {
                if((mapOldAccount!=null)
                        &&(mapOldAccount.get(oAccountVar.Id).ownerId!=oAccountVar.ownerId)){
                    
                    if(oAccountVar.OwnerId!=oUser.Id){ 
                        //Checking if Owner Id is changed.It is used for update scenario
                        mapNewAccountVar.put(oAccountVar.Id,oAccountVar);
                    }
                    mapOldAccountVar.put(oAccountVar.Id,mapOldAccount.get(oAccountVar.Id));
                    
                }
                else{
                    if(oAccountVar.OwnerId!=oUser.Id){ 
                        //This block is used for insert,delete Statement only
                        mapNewAccountVar.put(oAccountVar.Id,oAccountVar);
                    }                
                }
                }
                
            }
            


            try{
                
                if(mapNewAccountVar.size()>0){ 
                    // Initiate helper class to follow record for account owner
                    FollowUnFollowChatterHelper.autoFollowsObject(
                    (Map<Id,sObject>)mapNewAccountVar,System.label.OwnerId,
                    System.label.Id);  
                }
                
                if(mapOldAccountVar.size()>0){
                    // Initiate helper class to unfollow record for account owner
                    FollowUnFollowChatterHelper.autoUnfollowsObject(
                    (Map<Id,sObject>)mapOldAccountVar,System.label.OwnerId);   
                } 
                
            }
            catch(Exception ex){
            
                
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Account',String.valueOf(mapOldAccountVar.keyset()),
                'AccountTriggerHandler','FollowUnFollowhandler','Application',
                UserInfo.getUserId(),String.valueOf(mapOldAccountVar.values()),null);    
            }
        }   
    }
    /**
    * Method name  : updateVolunteerSlotEmail
    * Description  : Use this method to update Volunteer Slot email once 
    *                preferred email value changes                 
    * Return Type  : void
    * Parameter    : Map<Id,Account>,Map<Id,Account>
    **/  
    public static void updateVolunteerSlotEmail(Map<Id,Account> mapNewAccount,
    Map<Id,Account> mapOldAccount){
        if(Trigger.isUpdate&&Trigger_Methods_Activation__c.getInstance('updateVolunteerSlotEmail').Is_Trigger_Method_Required_In_Update__c)
        {
            Set<Id> setAccountId=new Set<Id>();
            List<Volunteer_Slot__c> lstVolunteerSlot=new List<Volunteer_Slot__c>();
            if(mapOldAccount!=null){
                
                for(Id accountIdVar: mapNewAccount.keySet()){
                    
                    if(mapNewAccount.get(accountIdVar).
                            Preferred_Email_Address__c!=null&&
                            mapNewAccount.get(accountIdVar).Preferred_Email_Address__c!=
                            mapOldAccount.get(accountIdVar).Preferred_Email_Address__c)
                    setAccountId.add(accountIdVar);
                }
            }
            
            
            if(setAccountId.size()>0)
            lstVolunteerSlot=[select Id,Status__c from Volunteer_Slot__c where 
            Volunteer__c IN :setAccountId and (Status__c LIKE 'Pending%' 
            OR Status__c='Approved')];
            try{ 
                if(lstVolunteerSlot.size()>0)
                update lstVolunteerSlot;
            }
            catch(Exception ex){
                
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Account',String.valueOf(setAccountId),
                'AccountTriggerHandler','updateVolunteerSlotEmail','Application',
                UserInfo.getUserId(),String.valueOf(lstVolunteerSlot),null);
                
            }  
        }
    }
    
    /**
    * Method name  : createAccountOwnerHistory
    * Description  : Use this method to create Account Owner History every
                     time Account Owner is updated.                
    * Return Type  : void
    * Parameter    : Map<Id,Account>,Map<Id,Account>
    **/  
    public static void createAccountOwnerHistory(Map<Id,Account> mapNewAccount,
    Map<Id,Account> mapOldAccount){
    
         Set<Id> setAccountId = new Set<Id>();
         List<Account_Owner_History__c> lstAccOwnerHistory =
             new List<Account_Owner_History__c>(); 
         for(Account oAccountVar: mapNewAccount.values()){
             if((mapOldAccount!=null
              &&(mapOldAccount.get(oAccountVar.Id).ownerId!=oAccountVar.ownerId))
              || (mapOldAccount==null && oAccountVar.ownerId != null)){
              setAccountId.add(oAccountVar.Id); 
             Account_Owner_History__c oVarAccOwnerHist = new Account_Owner_History__c();
             oVarAccOwnerHist.Account__c = oAccountVar.Id;
             oVarAccOwnerHist.Account_Owner__c = oAccountVar.ownerId;
             lstAccOwnerHistory.add(oVarAccOwnerHist);
             }
         }        
         if(lstAccOwnerHistory.size()>0){
           try{ 
               insert lstAccOwnerHistory;
           }
           catch(Exception ex){
           
              Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
              ex.getStackTraceString(),'Account',String.valueOf(setAccountId),
              'AccountTriggerHandler','createAccountOwnerHistory','Application',
              UserInfo.getUserId(),String.valueOf(setAccountId),null);
           
           }
       }      
    }
    
    /**
    * Method name  : getOldNewJSON
    * Description  : Use this method to initiate call to Compass using ESB to 
                    send account details
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Account>,Map<Id,Account>
    **/  
    public static void getOldNewJSON(Map<Id,Account> mapOldAccount,
    Map<Id,Account> mapNewAccount){
        //Getting Delta fields 
        List<String> lstDeltaCheckField=System.label.DeltaCheckField.split(';');   
        List<Account> lstFinalNewAccount=new List<Account>();
        List<Account> lstFinalOldAccount=new List<Account>();
        
        for(Id accountVarId: mapNewAccount.keySet()){
        
        //Checking if there are any change for delta fields
        if(mapNewAccount.get(accountVarId).Legacy_Supporter_Id__c!=null){
        
        
        //Apurva- COR0001310 check added Stop updates of Accounts with  
        //legacy Supporter ID having more than 1 '-' from being sent to Compass
        //Valid values should be in the format – “7-3755558” or “7-755558”
        String[] arrSupportIdSplitHyphen = mapNewAccount.get(accountVarId).
        Legacy_Supporter_Id__c.split(System.label.Hyphen);
        if(arrSupportIdSplitHyphen.size() <= 2)
        {
        sObject oSObjNewAccount = mapNewAccount.get(accountVarId);
        sObject oSObjOldAccount = mapOldAccount.get(accountVarId);
        Integer iMatched=0;
        
        for(String sFieldVar: lstDeltaCheckField){
            
            if(oSObjNewAccount.get(sFieldVar)!=oSObjOldAccount.get(sFieldVar))
            {    iMatched++; }
            
            if(iMatched>0)
                break;
               
        }
        if(iMatched>0){
            
            //Adding record to list if there is a match of any of 
            //the delta fields
            lstFinalNewAccount.add((Account)oSObjNewAccount);
            lstFinalOldAccount.add((Account)oSObjOldAccount);                    
                                
        }    
        
        }            
        } 
        }
        
        
        //Initiating call to generate JSON and send call to Compass via ESB
        if((lstFinalNewAccount.size()>0)&&(lstFinalOldAccount.size()>0))
        {
            OldAndNewJSONGeneratorHelper.getOldAndNewJSON(JSON.serialize(lstFinalOldAccount),
            JSON.serialize(lstFinalNewAccount));
            Utility.bRecursive = true;
        }
    }
    
    /**
    * Method name  : changeCorrespondingSBCCommunications
    * Description  : Use this method to initiate call to Compass using ESB to 
                    send account details
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Account>,Map<Id,Account>
    **/  
    public static void changeCorrespondingSBCCommunications(Map<Id,Account> mapOldAccount,
    Map<Id,Account> mapNewAccount)
    {
        if(Trigger_Methods_Activation__c.getInstance('changeCorrespondingSBCCommunications').Is_Trigger_Method_Required_In_Update__c)
        {
            Set<Id> lstSuuportersWithChangedCorrespondenceId = new Set<Id>();
            for(Id accountId : mapNewAccount.keyset())
            {
                if((mapOldAccount.get(accountId).Undeliverable_Invalid__c <> '' && mapOldAccount.get(accountId).Undeliverable_Invalid__c <> null) && (mapOldAccount.get(accountId).Undeliverable_Invalid__c <> mapNewAccount.get(accountId).Undeliverable_Invalid__c)
                        &&(mapNewAccount.get(accountId).Undeliverable_Invalid__c == '' || mapNewAccount.get(accountId).Undeliverable_Invalid__c == null))
                {
                    lstSuuportersWithChangedCorrespondenceId.add(accountId);
                }
                else if(mapNewAccount.get(accountId).Undeliverable_Invalid__c <> null && mapNewAccount.get(accountId).Undeliverable_Invalid__c <> '')
                {
                    Set<String> lstUndeliverableValuesSelected = new Set<String>(mapNewAccount.get(accountId).Undeliverable_Invalid__c.split(';'));
                    String sFinalListOfUndeliveredScenario = '';
                    for(String oStringVar : lstUndeliverableValuesSelected)
                    {
                        sFinalListOfUndeliveredScenario = sFinalListOfUndeliveredScenario + oStringVar + ',';
                    }
                    if((!sFinalListOfUndeliveredScenario.contains(mapNewAccount.get(accountId).Preferred_Email__c + ' Email') 
                                && 
                                (
                                    (mapNewAccount.get(accountId).Preferred_Email__c == 'Business' && mapNewAccount.get(accountId).Business_Email__c <> null && mapNewAccount.get(accountId).Business_Email__c <> '') || 
                                    (mapNewAccount.get(accountId).Preferred_Email__c == 'Personal' && mapNewAccount.get(accountId).Personal_Email__c <> null && mapNewAccount.get(accountId).Personal_Email__c <> '') || 
                                    (mapNewAccount.get(accountId).Preferred_Email__c == 'Work' && mapNewAccount.get(accountId).Work_Email__c <> null && mapNewAccount.get(accountId).Work_Email__c <> '')))|| 
                            
                            (!sFinalListOfUndeliveredScenario.contains(mapNewAccount.get(accountId).Preferred_Address__c + ' Address')
                                &&
                                (
                                    (mapNewAccount.get(accountId).Preferred_Address__c == 'Bill To' && mapNewAccount.get(accountId).BillingStreet <> null && mapNewAccount.get(accountId).BillingState <> null && mapNewAccount.get(accountId).BillingCountry <> null) || 
                                    (mapNewAccount.get(accountId).Preferred_Address__c == 'Mailing' && mapNewAccount.get(accountId).Mailing_State_Province__c <> null && mapNewAccount.get(accountId).Mailing_State_Province__c <> '' && mapNewAccount.get(accountId).Mailing_Country__c <> null && mapNewAccount.get(accountId).Mailing_Country__c <> '' && mapNewAccount.get(accountId).Mailing_Street__c <> null && mapNewAccount.get(accountId).Mailing_Street__c <> '') || 
                                    (mapNewAccount.get(accountId).Preferred_Address__c == 'Work' && mapNewAccount.get(accountId).ShippingStreet <> null && mapNewAccount.get(accountId).ShippingState <> null && mapNewAccount.get(accountId).ShippingCountry <> null))))
                    {
                        lstSuuportersWithChangedCorrespondenceId.add(accountId);            
                    }
                    
                }
            }
            
            if(!lstSuuportersWithChangedCorrespondenceId.isEmpty())
            {
                List<SBC_Communications__c> lstSBCCommunicationRecords = new List<SBC_Communications__c>();
                lstSBCCommunicationRecords = [select id, Status__c from SBC_Communications__c where Supporter__c in :lstSuuportersWithChangedCorrespondenceId and Status__c = 'Undeliverable'];
                for(SBC_Communications__c oSBCVar: lstSBCCommunicationRecords)
                {
                    oSBCVar.Status__c = 'Translation Complete';
                }
                if(lstSBCCommunicationRecords.size()>0){
                    try{
                        update lstSBCCommunicationRecords;
                    }
                    catch(Exception ex){
                        
                        Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                        ex.getStackTraceString(),'SBC_Communications__c',String.valueOf(lstSuuportersWithChangedCorrespondenceId),
                        'AccountTriggerHandler','changeCorrespondingSBCCommunications','Application',
                        UserInfo.getUserId(),String.valueOf(mapNewAccount),String.valueOf(mapOldAccount));
                    }  
                } 
            }
        }
    }
    
    /**
    * Method name  : updateAccountToCI
    * Description  : Use this method to initiate call to CI  wth status changes
            
    * Return Type  : void
    * Parameter    : Map<Id,Account>,Map<Id,Account>
    **/  
    public static void updateAccountToCI(Map<Id,Account> mapOldAccount,Map<Id,Account> mapNewAccount){
        
        List<String> lstDeltaCheckField=System.label.DeltaFieldForCI.split(';');   
        List<Id> lstFinalNewAccount=new List<Id>();
        
        
        for(Id accountVarId: mapNewAccount.keySet()){
            
            //Checking if there are any change for delta fields
            if((mapNewAccount.get(accountVarId).Legacy_Supporter_Id__c!=null)||((mapNewAccount.get(accountVarId).Global_Id__c!=null))){
                
                sObject oSObjNewAccount = mapNewAccount.get(accountVarId);
                sObject oSObjOldAccount = mapOldAccount.get(accountVarId);
                Integer iMatched=0;
                
                for(String sFieldVar: lstDeltaCheckField){
                    
                    if(oSObjNewAccount.get(sFieldVar)!=oSObjOldAccount.get(sFieldVar))
                    {    iMatched++; }
                    
                    if(iMatched>0)
                    break;
                    
                }
                if(iMatched>0){
                    
                    //Adding record to list if there is a match of any of 
                    //the delta fields
                    lstFinalNewAccount.add(accountVarId);
                    
                    
                }                
            } 
        }
        
        
        //Initiating call to generate JSON and send call to Compass via ESB
        if(lstFinalNewAccount.size()>0)
        {
            AccountSendUpdateToCI.sendUpdateCI(lstFinalNewAccount);
            Utility.bRecursive = true;
        }

        
        
        
        
        
        
    }
    
    /**
    * Method name  : changeCorrespondingSBCStatus
    * Description  : Use this method to change the related SBC Communications
    *                records linked to the particular Beneficiary
    * Return Type  : void
    * Parameter    : Map<Id, Account>, Map<Id, Account> 
    **/  
    
    public static void changeCorrespondingSBCStatus(Map<Id, Account> mapOldAccounts, Map<Id, Account> mapNewAccounts)
    {
        List<Id> lstFinalAccountsId = new List<Id>();
        Id supporterRecordTypeId = Utility.getRecordType('Supporter','Account');
        Id beneficiaryRecordTypeId = Utility.getRecordType('Beneficiary','Account');
        for(Id oIdVar: mapNewAccounts.keyset())
        {
            if(mapOldAccounts <> null && 
                    (mapOldAccounts.get(oIdVar).RecordTypeId == supporterRecordTypeId || mapOldAccounts.get(oIdVar).RecordTypeId == beneficiaryRecordTypeId) &&
                    (mapOldAccounts.get(oIdVar).Status__c <> mapNewAccounts.get(oIdVar).Status__c) &&
                    (mapNewAccounts.get(oIdVar).Status__c == 'Inactive'))
            {
                lstFinalAccountsId.add(oIdVar);
            }
        }
        if(!lstFinalAccountsId.isEmpty())
        {
            List<SBC_Communications__c> lstSBCComRceords = new List<SBC_Communications__c>();
            List<String> lstStatus = System.Label.SBCCommunicationStatus.split(',');
            for(SBC_Communications__c oSBCVar: [select id, Status__c, Supporter__C, Beneficiary__c, Exception_Reason__c from SBC_Communications__c 
            where Status__c not in :lstStatus and (Supporter__c in :lstFinalAccountsId OR Beneficiary__c in :lstFinalAccountsId)])
            {
                oSBCVar.Status__c = 'Exception';
                if(oSBCVar.Supporter__c <> null && String.valueOf(lstFinalAccountsId).contains(String.valueOf(oSBCVar.Supporter__c)))
                {
                    oSBCVar.Exception_Reason__c = SBCCommunicationExceptionReason__c.getInstance('Inactive Supporter').Status__c;
                }
                else
                {
                    oSBCVar.Exception_Reason__c = SBCCommunicationExceptionReason__c.getInstance('Inactive Beneficiary').Status__c;
                }
                lstSBCComRceords.add(oSBCVar);
            }
            if(!lstSBCComRceords.isEmpty())
            {
                try{
                    update lstSBCComRceords;
                }
                catch(Exception ex){
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'SBC_Communications__c',String.valueOf(lstSBCComRceords),
                    'AccountTriggerHandler','changeCorrespondingSBCStatus','Application',
                    UserInfo.getUserId(),String.valueOf(mapNewAccounts),String.valueOf(mapOldAccounts));
                }   
            }
        }
    }
    /**
    * Method name  : setLastCorrespondenceDate
    * Description  : Use this method to set last corrsopondence Date
            
    * Return Type  : void
    * Parameter    : List<Account>
    **/  
    public static void setLastCorrespondenceDate(List<Account> lstNewAccount){
        
        String sRecordTypeId=Utility.getRecordtype('Beneficiary','Account');
        for(Account oAccountVar:lstNewAccount){
            
            if(oAccountVar.recordtypeId!=sRecordTypeId )
            oAccountVar.Last_Correspondence_Date__c=System.today();
            
        }
        
        
        
    }  
    /**
    * Method name  : checkAccountDeletionValidation
    * Description  : Use this method to validate of user can delete the account                 



    * Return Type  : void
    * Parameter    : List<Account>

    **/  
    public static void checkAccountDeletionValidation(List<Account> lstAccountOld){
        String sConsignmentVar = 'Consignment';
        Set<Id> setAccountId = new Set<Id>();
        sConsignmentVar = sConsignmentVar.toUpperCase();
        try{
        
         if(lstAccountOld!=null && lstAccountOld.size()>0){
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            if(profileName!=System.Label.Business_Administrator_Profile 
            && profileName!=System.Label.System_Administrator_Profile ){
              for(Account oAccountVar: lstAccountOld){
                if(oAccountVar.Name.toUpperCase().contains(sConsignmentVar)){
                  setAccountId.add(oAccountVar.Id); 
                  Trigger.Old.get(0).addError(System.Label.ConsignmentAccountDeletion,false);
                }
              }

            }
          }
        }      

        catch(Exception ex){
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
            ex.getStackTraceString(),'Account',String.valueOf(setAccountId),
            'AccountTriggerHandler','checkAccountDeletionValidation','Application',
            UserInfo.getUserId(),String.valueOf(setAccountId),null);
       }      

    }
    
}