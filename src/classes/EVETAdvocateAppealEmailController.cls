/*****************************************************************************
    Name             : EVETAdvocateAppealEmailController
    Description      : Class used to handle Advocate appeal via email .                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer            Date              Description
    ---------------------------------------------------------------------------
    Subhojit             30/10/2014        Created
    Subhojit             29/01/2015        Modified for code re-factoring & 
                                           optimization
    Shanu                24/11/2015        Changes made for COR0001494                                           
*****************************************************************************/

public with Sharing class EVETAdvocateAppealEmailController{    

    public Campaign campaignOwner{get;set;}
    public boolean  bSuccess{get;set;}
    public boolean bIsSystemAdmin{get;set;}
    public List<SelectOption> lstAllDistance{get;set;}
    public String sSelectedDistance{get;set;}
    public String sEventIdSelected{get;set;}
    public List<Campaign> lstAllActiveCampaign{get;set;}
    public List<AccountWrapper> lstAccountWrapper{get;set;}
    public List<CampaignWrapper> lstCampaignWrapper{get;set;}
    public String sZIPCode{get;set;}
    public Integer iNoOfAdvocate{get;set;}
    public Integer iNoOfSelectedAdvocate{get;set;}
    public boolean bShowAdvocates{get;set;}
    public String sEmailIds{get;set;}
    public boolean bShowSecondPage{get;set;}
    public String sSpecialNote{get;set;}
    public String sSelectedEvent{get;set;}
    public boolean bIsNoRecord{get;set;}
    Map<Id,String> mapZipCodeEvent{get;set;}
    public boolean bIsHidden{get;set;}
    public String sSelectedEventVar{get;set;}
    public boolean  bIsContionueBatch{get;set;}
    Static Final Integer BATCH_CHUNK_LIMIT= Integer.valueOf(System.Label.EVETBatchLimit);
    user userVar;
    List<AccountWrapper> LstSelectedAccountWrapper{get;set;}
    List<AccountWrapper> lstAccountWrapperTemp{get;set;}
    public Integer iTotalSize{get;set;}
    public Integer iTotalEmailCount{get;set;}
      public boolean isLastBatch{get;set;}
    //Basic constructor
    public EVETAdvocateAppealEmailController(){

        campaignOwner=new Campaign();
        campaignOwner.Published_Volunteer_Coordinator_Name__c 
        = UserInfo.getName();
        bIsContionueBatch=false;
        iTotalEmailCount=0;
        iTotalSize=0;
       try{
        Profile oProfile=[SELECT Id, Name, Description
                            FROM Profile
                            WHERE  PermissionsAuthorApex = true and Id=:UserInfo.getProfileId() ];
        if( oProfile!=null)
          bIsSystemAdmin=true;                 
       }
       catch(Exception ex){
       
        bIsSystemAdmin=false;
       }
        lstAllDistance=new List<SelectOption>{new SelectOption('5','5'),
        new SelectOption('10','10'),new SelectOption('15','15'),
        new SelectOption('25','25'),new SelectOption('50','50'),
        new SelectOption('75','75'),new SelectOption('100','100')};
        sSelectedDistance='5';
        init();
    }
    /**
    * Method name  : init
    * Description  : Use this method to instantiate all class variable and 
    *                get Event Location based on logged in user as VC.
    * Return Type  : void
    * Parameter    : void
    **/  
    public void init(){
        bIsHidden=false;
        bSuccess=false;
        sSelectedEventVar=null;
        lstAllActiveCampaign = new List<Campaign>();
        Recordtype recordtypeId = new Recordtype();
        recordtypeId = [select Id from recordtype where developerName 
        = 'Event_Location' and SobjectType='Campaign']; 
        //Getting Event Location recordtype.
        /*Getting all confirmed Campaigns where logged in user as Volunteer 
        coordinator*/
        lstAllActiveCampaign=[select Address_1__c,Address_2__c,Address_3__c,
        Campaign__c,Event__r.Name,Id,VEN_Name__c,Venue__C,Name,OwnerId,City__c,
        State__c,ZIP_Code__c,Country__c,Volunteer_Coordinator__c,
        volunteer_Coordinator__r.Name,Volunteer_Coordinator__r.FirstName,
        Partner_Website__c,Venue__r.Name,Venue__r.Address__c,
        Published_Location_Name__c,Published_Volunteer_Coordinator_Email__c,
        Published_Volunteer_Coordinator_Name__c,EVE_Start_Time__c,
        EVE_End_Time__c,Volunteer_Coordinator__r.LastName,
        Volunteer_Coordinator__r.Email,Volunteer_Coordinator__r.Phone,Status,
        StartDate,EndDate,(select Id,Start_Time__c,End_Time__c,Date__c,
        Volunteer_Role__c from Volunteer_Shift__r)
        from Campaign where Publish_To_Web__c=true and  
        Published_Volunteer_Coordinator_Name__c 
        =: campaignOwner.Published_Volunteer_Coordinator_Name__c and 
        recordTypeId=:recordtypeId.Id and status='Confirmed'];
        try{
            userVar=[select Id,Email,Phone,FirstName,LastName,Name from User 
            where Name=:campaignOwner.Published_Volunteer_Coordinator_Name__c];
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.InvalidVolunteerCoordinator);//Invalid Volunteer Coordinator.
            ApexPages.addMessage(myMsg);
            
        }
        //Creating Campaign Wrapper from retrieved result
        lstCampaignWrapper=new List<CampaignWrapper>();
        lstAccountWrapper=new List<AccountWrapper>();
        if( lstAllActiveCampaign.size()>0){
            for(Campaign oCampaignVar :lstAllActiveCampaign){
                lstCampaignWrapper.add(new CampaignWrapper(oCampaignVar,false));
            }
        }
        
        if(lstAllActiveCampaign.size()==0)
        bIsNoRecord=true;
        else
        bIsNoRecord=false;
        bShowAdvocates=false;
        bShowSecondPage=false;
    }

    /**
    * Method name  : getNearByPinCodeList
    * Description  : Use this method to make call out and get nearby zip code 
    *                and get account contains  with those zip code.
    * Return Type  : void
    * Parameter    : void
    **/  
    public void getNearByPinCodeList(){
        bShowAdvocates=false;
        if(sZIPCode==''){
            ApexPages.Message myMsg = new 
        ApexPages.Message(ApexPages.Severity.ERROR,System.label.MissingZipCode);
            //Please enter a ZIP Code.
            ApexPages.addMessage(myMsg);
            sSelectedEventVar=null;
            return;      
        }
        //Making callout to get all nearby zip code from Campaign Zip Code or 
        //User given value.
        HttpRequest request = new HttpRequest();
        Integration_Endpoints__c integrationDetails 
        = Integration_Endpoints__c.getAll().get('Zip Code Search'); 
        String sURL=integrationDetails.Endpoint_URL__c;
        sURL+=integrationDetails.Authorization_Code__c;
        if(sZIPCode.length()>5)
        sZIPCode=sZIPCode.subString(0,5);
        sURL+='/radius.json/'+sZIPCode+'/'+sSelectedDistance+'/'+'mile';
        Http http= new Http();
        request.setEndPoint(sURL);
        request.setMethod('POST');
        HTTPResponse response = http.send(request);
        if(response.getStatusCode()!=200 ){
     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR
          , System.label.ErrorOccoredInZipSearch);
    //Some Error Occurred in Searching ZIP Code.Please check the zip code again.
            ApexPages.addMessage(myMsg);
            if(lstAccountWrapper.size()>0)
            bShowAdvocates=true;
            sSelectedEventVar=null;
            return;    
        }
        List<Integer> lstMatchedZipCode=new List<Integer>();
        List<String> lstMatchedZipCodeString=new List<String>();
        String sResponseString=response.getBody();
        JsonHandler.ZipCodeSearchData zipData = 
        (JsonHandler.ZipCodeSearchData)JSON.deserialize(sResponseString
        ,JsonHandler.ZipCodeSearchData .class);
        for(JsonHandler.ZipCodeDetails zipDetails:zipData.zip_codes){
            lstMatchedZipCode.add(Integer.valueOf(zipDetails.zip_code));
            lstMatchedZipCodeString.add(zipDetails.zip_code+'%');
            
        }
        List<Account> lstMatchedAccount=new List<Account>();
        //Querying to get all account which match with retrieved zip code with 
        //Billing Zip code and Radius as Preferred Zip Radius
        lstMatchedAccount=[select Id,RecordTypeId,Account_Full_Name__c,Name,First_Name__c,
        BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,
        ShippingCity,ShippingState,ShippingStreet,Personal_Email__c,
        Work_Email__c,Preferred_Email__c,ShippingCountry,ShippingPostalCode,
        Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,
        Mailing_City__c,Business_Email__c,Type,Business_Phone__c ,
        Preferred_Email_Address__c,SUP_Service_Level__c,
        Mailing_Zip_Postal_Code__c,Do_not_Email__c,C_o_Biling_Address__c,
        C_o_Mailing_Address__c,C_o_Physical_Address__c,ADV_Preferred_Radius__c,
        ADV_Preferred_Zip_Code__c,Preferred_Phone_No__c,
        (select Id,Name,Volunteer_Appeals_Email_Opt_Out__c,
        Volunteer_Appeals_Active__c from Communication_Preferences__r ) from 
       Account  where ( (ADV_Preferred_Zip_Code__c Like :lstMatchedZipCodeString) 
        and Preferred_Email_Address__c!=null) and ((Do_not_Email__c=false) AND 
        (Do_not_Contact__c=false)) 
        /*AND ADV_Preferred_Radius__c=:(sSelectedDistance)*/];
        List<Account> lstAccountTemp=new List<Account>();
        for(Account oAccount: lstMatchedAccount){
            if((oAccount.Communication_Preferences__r !=null)&&
            (oAccount.Communication_Preferences__r .size()>0)){
                if((oAccount.Communication_Preferences__r[0]
                .Volunteer_Appeals_Email_Opt_Out__c==false)&&
                (oAccount.Communication_Preferences__r[0]
                .Volunteer_Appeals_Active__c=true ))
                lstAccountTemp.add(oAccount);
            }
        }
        
        //Shanu- Nov 2015 Changes made for COR0001494 
        List<Account> lstActiveAdvocateAccount=new List<Account>();
        if(lstAccountTemp.size()>0){
                lstActiveAdvocateAccount=FilterActivePartnerSupporterAccounts(lstAccountTemp);
        }
        
        lstMatchedAccount=lstActiveAdvocateAccount;
        if(lstMatchedAccount.size()==0){
            if(sSelectedEventVar==null){
                ApexPages.Message myMsg = new 
                ApexPages.Message(ApexPages.Severity.ERROR,
                System.label.NoAdvocateFound); 
                //No Advocate found.Please check Zip code and filter criteria.
                ApexPages.addMessage(myMsg);
            }
            else{
                
                ApexPages.Message myMsg = new 
                ApexPages.Message(ApexPages.Severity.ERROR,
                System.label.NoAdvFoundByEL);
//No Advocate found.Please check Zip code and filter criteria. NoAdvFoundByEL
                ApexPages.addMessage(myMsg);
                
            }
            sSelectedEventVar=null;
            if(lstAccountWrapper.size()>0)
            bShowAdvocates=true;
            return;
        }
        Set<Id> setCampaignId=new  Set<Id>();
        for(CampaignWrapper campaignWrapperVar: lstCampaignWrapper){
            if(campaignWrapperVar.campaign.Id==sEventIdSelected)
            setCampaignId.add(campaignWrapperVar.campaign.Id);
        }
      List<Volunteer_Shift__c> lstVolunteerShift=new List<Volunteer_Shift__c>();
        Map<Id,Account> mapVolunteer=new Map<Id,Account>();
        lstVolunteerShift=[select Id,(select Id,Status__c,Volunteer__c from 
        Volunteer_Slots__r),EventLocation__c from Volunteer_Shift__c where
        EventLocation__c IN :setCampaignId];
        for(Volunteer_Shift__c  oVShiftVar: lstVolunteerShift){
            for(Volunteer_Slot__c oVSlotVar: oVShiftVar.Volunteer_Slots__r ){
              if((oVSlotVar.Status__c!=null)&&((oVSlotVar.Status__c
              .contains('Pending'))||(oVSlotVar.Status__c=='Approved')))
                mapVolunteer.put(oVSlotVar.Volunteer__c,
                new Account(Id=oVSlotVar.Volunteer__c));                
            }
        }
        if((lstAccountWrapper==null)||(lstAccountWrapper.size()==0))
        lstAccountWrapper=new List<AccountWrapper>();
        for(Account accountVar:lstMatchedAccount){
          AccountWrapper accountWrapperVar=new AccountWrapper(accountVar,true);
            lstAccountWrapper.add(accountWrapperVar);
        }
        if(lstAccountWrapper.size()>0)
        lstAccountWrapper=removeDuplicateAccount(lstAccountWrapper);
        else{
   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
   System.label.NoAdvocateFound);
            //No Advocate found.Please check Zip code and filter criteria.
            ApexPages.addMessage(myMsg);
            return;
        }
        iNoOfAdvocate= lstAccountWrapper.size();
        bShowAdvocates=true;
        sSelectedEventVar=null;
    }

    /**
    * Method name  : getAccountByEmails
    * Description  : Use this method to get all account which contains user 
    *                entered email address in any email fields.
    * Return Type  : void
    * Parameter    : void
    **/  
    public void getAccountByEmails(){
        if(sEmailIds==''){
  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR
            ,System.label.AddMinOneEmail);
            //Please enter at least one email
            ApexPages.addMessage(myMsg);
            return;      
        }
        List<String> lstEmailId=new List<String>();
        if(sEmailIds!=null)
        lstEmailId=sEmailIds.split('\n');
        if(lstEmailId.size()>50){
 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR
            ,System.label.SpecialMessageMaxEmailLimit);
            //Maximum 50 emails are allowed in a single search.
            ApexPages.addMessage(myMsg);
            return;      
        }
        String sQuery='FIND {';
        for(String sEmailVar: lstEmailId){
          sQuery+='"'+sEmailVar+'" OR ';
        
        }
        sQuery=sQuery.subStringBeforeLast('OR');
        // Shanu- Nov 2015 Added RecordTypeId in the query for COR0001494                                              
        sQuery+='} IN EMAIL FIELDs RETURNING Account(Name,Id,RecordTypeId,Account_Full_Name__c,Personal_Email__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode, ShippingCity,ShippingState,ShippingStreet,Preferred_Email__c,ShippingCountry,ShippingPostalCode,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_City__c,Business_Email__c,Type,Preferred_Email_Address__c,Mailing_Zip_Postal_Code__c,Do_not_Email__c,C_o_Biling_Address__c,C_o_Mailing_Address__c,C_o_Physical_Address__c,Business_Phone__c ,First_Name__c,Preferred_Phone_No__c,SUP_Service_Level__c,Work_Email__c where Preferred_Email_Address__c!=null AND ((Do_Not_Contact__c=false) AND (Do_not_Email__c=false)) )';
        
        
        //Querying Account based on Email address
        List<Account> lstMatchedAccount=new List<Account>();
        List<List<sObject>> lstAllAccount=new List<List<sObject>>();
        lstAllAccount=search.query(sQuery);
        if(lstAllAccount.size()>0)
        lstMatchedAccount=(List<Account>)lstAllAccount[0];
        Set<String> setAccountIds=new Set<String>();
        Map<Id,List<Communication_Preference__c>> mapAccountCommPref=new Map<Id,List<Communication_Preference__c>>();
        for(Account oAccount: lstMatchedAccount)
         setAccountIds.add(oAccount.Id);
        List<Communication_Preference__c> lstCommPref=[select Volunteer_Appeals_Email_Opt_Out__c,Id,Name,Account__c
                                                        from Communication_Preference__c where Account__C IN :setAccountIds];
                                                        
        for(Communication_Preference__c oCommPref: lstCommPref){
        
             if((mapAccountCommPref.get(oCommPref.Account__c)!=null)&&(mapAccountCommPref.get(oCommPref.Account__c).size()>0))
                mapAccountCommPref.get(oCommPref.Account__c).add(oCommPref);
             else
               mapAccountCommPref.put(oCommPref.Account__c,new List<Communication_Preference__c>{oCommPref});
        
        }                        
                                                        
 
        
        List<Account> lstAccountTemp=new List<Account>();
        for(Account oAccount: lstMatchedAccount){
           List<Communication_Preference__c > lstComPrefVar=new List<Communication_Preference__c > ();
           lstComPrefVar=mapAccountCommPref.get(oAccount.Id);
            if((lstComPrefVar !=null)&&
            (lstComPrefVar.size()>0)){
                if((lstComPrefVar[0]
                .Volunteer_Appeals_Email_Opt_Out__c==false)&&
                (lstComPrefVar[0]
                .Volunteer_Appeals_Active__c=true ))
                lstAccountTemp.add(oAccount);
            }
        }
        
        //Shanu- Nov 2015 Changes made for COR0001494 
        List<Account> lstActiveAdvocateAccount=new List<Account>();
        if(lstAccountTemp.size()>0){
            lstActiveAdvocateAccount=FilterActivePartnerSupporterAccounts(lstAccountTemp);
        }
        
        lstMatchedAccount=lstActiveAdvocateAccount;
        if(lstMatchedAccount.size()==0){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.NoAdvocateFoundEmail);
            //No Advocate found.Please check the email address.
            ApexPages.addMessage(myMsg);
            if(lstAccountWrapper.size()>0)
            bShowAdvocates=true;
            return;
        }
        if((lstAccountWrapper==null)||(lstAccountWrapper.size()==0))
        lstAccountWrapper=new List<AccountWrapper>();
        
        for(Account accountVar:lstMatchedAccount){
           AccountWrapper accountWrapperVar=new AccountWrapper(accountVar,true);
            lstAccountWrapper.add(accountWrapperVar);
        }
        if(lstAccountWrapper.size()>0)
        lstAccountWrapper=removeDuplicateAccount(lstAccountWrapper); 
        //Removing duplicate account 
        iNoOfAdvocate= lstAccountWrapper.size();
        bShowAdvocates=true;
    }

    public void back(){
        bShowSecondPage=false;
    } 
    /**
    * Method name  : gotoSecondPage
    * Description  : Use this method to set necessary visible to show next page 
    *                and also page validation.
    * Return Type  : void
    * Parameter    : void
    **/  
    public void gotoSecondPage(){
        LstSelectedAccountWrapper=new List<AccountWrapper>();
        iNoOfSelectedAdvocate=0;
        for(AccountWrapper accountVar:lstAccountWrapper) {
            if(accountVar.bIsSelected==true) {  
                LstSelectedAccountWrapper.add(accountVar);
                iNoOfSelectedAdvocate++;
            }
        }
        //If query does not return any matched Account
        if(lstAccountWrapper.size()==0){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.NoAdvocateFound);
            //No Advocate to proceed.Please verify zip code filter.
            ApexPages.addMessage(myMsg);
            return;
        }
        else if(iNoOfSelectedAdvocate==0){
         //When user does not select any account and tries to go to second page
            ApexPages.Message myMsg = new
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.SelectOneVolunteer);
            //Please select at least one advocate to proceed
            ApexPages.addMessage(myMsg);
            return;
        }
        bShowSecondPage=true;
    } 
    
    public void getEmailBatch(){
        Integer iBatchSize=0;
         bIsContionueBatch=true;
         iTotalEmailCount=LstSelectedAccountWrapper.size();
        lstAccountWrapperTemp=new List<AccountWrapper> ();
        isLastBatch=false;
        for(Integer iIndex=iTotalSize;iIndex<LstSelectedAccountWrapper.size();iIndex++ ){
        
           
           if((iBatchSize<BATCH_CHUNK_LIMIT)&&(iTotalSize<=LstSelectedAccountWrapper.size())){
             if(iTotalEmailCount-iTotalSize<=BATCH_CHUNK_LIMIT)
                   isLastBatch=true; 
           
             if(LstSelectedAccountWrapper[iIndex]!=null){
             
                  
                 lstAccountWrapperTemp.add(LstSelectedAccountWrapper[iIndex]);
             
              iTotalSize++;
              iBatchSize++;
             }
          }
          else
          break;
        
        
        
        }
    
   if(( lstAccountWrapperTemp.size()>0)&&(iTotalSize<=LstSelectedAccountWrapper.size()))
    sendEmail();
   else{
   
    bIsContionueBatch=false;
     bSuccess=true;
  
       
               ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.INFO,System.Label.EmailSendingSuccess); 
            //Your Emails sent successfully.
           ApexPages.addMessage(myMsg);
   } 
    
    }
    
    
    
    
    
    /**
    * Method name  : sendEmail
    * Description  : Use this method to send email using XMPie
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    public void sendEmail(){
        boolean bIsAnyEventChecked=false;
        Campaign campaignSelected = new Campaign();
        if((sSpecialNote!=null)&&(sSpecialNote.contains('\n')))
        sSpecialNote=sSpecialNote.replace('\n','<br/>');
        if(lstCampaignWrapper.size()>0){
            for(CampaignWrapper campaignWrpVar: lstCampaignWrapper){
               
                if(campaignWrpVar.bIsSelected==true){
                    bIsAnyEventChecked=true;                    
                    campaignSelected = campaignWrpVar.campaign;
                }
            }
        }
        if( bIsAnyEventChecked==false){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.Error,
            System.label.SelectOneCampaign);
            //Please select at least one Campaign.
            ApexPages.addMessage(myMsg);
             bIsContionueBatch=false;
            iTotalSize=0;
            return;
        }
        List<CampaignWrapper> lstSelectedCampaignWrapper = 
        new List<CampaignWrapper>();
        List<AccountWrapper> lstAccountWrapper=new List<AccountWrapper>();
        String sLocationText='';
        String sShiftRule=null;
        String sIdString='';
        Integer iNumber=0;
        for(CampaignWrapper campaignVar: lstCampaignWrapper){
            if(campaignVar.bIsSelected){
                //Forming Volunteer Shift Rule
                iNumber++;
                if((campaignVar.campaign.StartDate!=null)&&
                (campaignVar.campaign.EndDate!=null)){
                    String sStartDate=campaignVar.campaign.StartDate.month()+'/'
                    +campaignVar.campaign.StartDate.day()+'/'+
                    campaignVar.campaign.StartDate.year();
                    String sEndDate=campaignVar.campaign.EndDate.month()+'/'+
                    campaignVar.campaign.EndDate.day()+'/'+
                    campaignVar.campaign.EndDate.year();
                    sIdString+=campaignVar.campaign.Id+'#';
                    sLocationText+=Utility.getLocationText
                    (campaignVar.campaign.Published_Location_Name__c,
                    sStartDate+' '+CampaignVar.campaign.EVE_Start_Time__c,
                    sEndDate+' '+CampaignVar.campaign.EVE_End_Time__c,
                    campaignVar.campaign.Venue__r.Name,
                    campaignVar.campaign.Venue__r.Address__c,
                    campaignVar.campaign.Partner_Website__c,true,
                    iNumber,false,null,null,null,null);
                }
            }
            lstSelectedCampaignWrapper.add(campaignVar);
        }
        sIdString=sIdString.subStringBeforeLast('#');
        //Adding Other recipient in accountWrapper
        for(AccountWrapper lstAccountWrappervar: lstAccountWrapperTemp){
            AccountWrapper accountWrapperVar = 
            new AccountWrapper(new Account(),true);
            accountWrapperVar.account.Compassion_Background__c 
            =(sSpecialNote!='')?sSpecialNote:null;
            accountWrapperVar.account.Hobbies__c 
            =(sLocationText!='')?sLocationText:null;
            accountWrapperVar.account.Business_Type__c = sIdString;
            accountWrapperVar.account.Research_Comments__c = 
            lstAccountWrapperVar.account.Id;
            accountWrapperVar.account.T_Shirt_Size__c = 
            lstAccountWrapperVar.account.Id.getSObjectType().getDescribe()
            .getName(); 
            if( campaignSelected <> NULL) {
                accountWrapperVar.account.Occupation_Details__c = 
                campaignSelected.Published_Volunteer_Coordinator_Email__c;
            }
            accountWrapperVar.account.Segment_Type__c = userVar.FirstName;
            accountWrapperVar.account.VEN_Service__c = userVar.LastName;
            accountWrapperVar.account.Social_Profile_s__c = sShiftRule;
            accountWrapperVar.account.Mailing_State_Province__c = 
            EVET_Template_Id__c.getAll().get('EVETAdvocateAppealEmail')
            .Template_ID__c;
            accountWrapperVar.account.Business_Phone__c = userVar.Phone;
            accountWrapperVar.account.Business_Email__c = lstAccountWrapperVar
            .account.Preferred_Email_Address__c;
            accountWrapperVar.account.Id=lstAccountWrapperVar.account.Id;
            accountWrapperVar.account.First_Name__c = (lstAccountWrapperVar
            .account.First_Name__c!=null)?lstAccountWrapperVar.account
            .First_Name__c:lstAccountWrapperVar.account.Account_Full_Name__c;
            lstAccountWrapper.add(accountWrapperVar);
        }
        if((LstSelectedAccountWrapper.size()>0)&&(isLastBatch)){
            Account accountVar=new Account();
            accountVar.Compassion_Background__c = 
            (sSpecialNote!='')?sSpecialNote:null;
            accountVar.Hobbies__c=(sLocationText!='')?sLocationText:null;            
            accountVar.Segment_Type__c=userVar.FirstName;
            accountVar.VEN_Service__c=userVar.LastName;
            accountVar.Social_Profile_s__c=sShiftRule;
            if (campaignSelected <> NULL){
                accountVar.Business_Type__c=campaignSelected.Id;
                accountVar.Occupation_Details__c = campaignSelected.Published_Volunteer_Coordinator_Email__c;
                accountVar.First_Name__c=campaignSelected.Published_Volunteer_Coordinator_Name__c+' (Notification)';           
                accountVar.Business_Email__c=campaignSelected.Published_Volunteer_Coordinator_Email__c;
            }
            accountVar.Business_Phone__c=userVar.Phone;
            accountVar.Research_Comments__c=userVar.Id;
            accountVar.T_Shirt_Size__c=userVar.Id.getSObjectType().getDescribe().getName();  
            accountVar.Mailing_State_Province__c = 
            EVET_Template_Id__c.getAll().get('EVETAdvocateAppealEmail')
            .Template_ID__c;
            accountVar.Id=null;            
            lstAccountWrapper.add(new AccountWrapper(accountVar,true));  
        }
        Integer iRecpNo=1;
        for(AccountWrapper accountWrapperVar: lstAccountWrapper){
            accountWrapperVar.account.Recognitions_and_Accomplishments__c 
            = String.valueOf(lstAccountWrapper.size());
            accountWrapperVar.account.Country_Of_Origin__c 
            = String.valueOf(iRecpNo);
            iRecpNo++;
        }
        List<Account> lstSelectedAccount=new List<Account>();
      
        for(AccountWrapper acountWrapperVar: lstAccountWrapper)
        lstSelectedAccount.add(acountWrapperVar.account);
        boolean bStatus=false;
        if(lstSelectedCampaignWrapper.size()>0){            
            bStatus=SendEmailUsingXMPie.sendEmail(lstSelectedAccount);  
            // Sending Email using XMPie 
           List<Task>   lstMassAppealTask=new List<Task>();    
            //Forming Task related to each Event LOcation           
            for(CampaignWrapper campaignVar: lstSelectedCampaignWrapper){
                if(campaignOwner.Volunteer_Coordinator__c!=null){
                    Task massAppealTaskVar=new Task();
                    massAppealTaskVar.Subject='Advocate Email';
                    massAppealTaskVar.Status='Completed';
                    massAppealTaskVar.Close_Date__c=Date.today();
                    massAppealTaskVar.OwnerId = 
                    campaignOwner.Volunteer_Coordinator__c;
                    massAppealTaskVar.whatId=campaignVar.campaign.Id;
                    massAppealTaskVar.Description=
                    'Advocate appeal email has been send out to '+
                    lstAccountWrapper.size()+' volunteer(s) on '+
                    datetime.now().date()+'  by '+UserInfo.getName();
                    lstMassAppealTask.add(massAppealTaskVar);
                }
            }
            
            
            if(bStatus){
            
               ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.INFO,System.Label.EmailSendingSuccess); 
            //Your Emails sent successfully.
        //   ApexPages.addMessage(myMsg);
            
            }
            else{
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
            System.Label.ErrorOccoredInEmailSending); 
            //Error Occurred while sending using XMPie.Please contact system
            //Administrator.
            ApexPages.addMessage(myMsg);
            
            }
            
            
            
            try{ 
                
                bSuccess=false;
            }
            catch(Exception ex){
                
                ApexPages.Message myMsg2 = new
                ApexPages.Message(ApexPages.Severity.Error,
                System.label.SelectOneCampaign+' '+ex);
                 bIsContionueBatch=false;
            iTotalSize=0;
            }
            return;
        }
        else{
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.Error,
            System.label.SelectOneCampaign);
            //Please select at least one Campaign.
            ApexPages.addMessage(myMsg);
            return;
        }
        
     
    }
    public void hideSearchResult(){
        if(bIsHidden==true)
        bIsHidden=false;
        else
        bIsHidden=true;

    }

    // Account Wrapper class to show Matched volunteer with check box
    public class AccountWrapper{
        public Account account{get;set;}
        public boolean bIsSelected{get;set;}
        public boolean bIsHidden{get;set;}
        public AccountWrapper(Account acc,boolean isSelected){
            account=acc;
            bIsSelected=isSelected;
        }

    }
    // Campaign Wrapper class to show Matched Campaign with check box
    public class CampaignWrapper{

        public Campaign campaign{get;set;}
        public boolean bIsSelected{get;set;}
        public Date dtStartDate{get;set;}
        public Date dtEndDate{get;set;}
        public String sStartDate{get;set;}
        public String sEndDate{get;set;}
        public String sVenue{get;set;}
        public String sCampaignName{get;set;}
        public CampaignWrapper(Campaign camp,boolean isSelected){

            campaign=camp;
            bIsSelected=isSelected;
            sCampaignName= camp.Published_Location_Name__c+' ('+camp.City__c+','
            +camp.State__c+')';
            sStartDate=(camp.StartDate!=null)?(camp.StartDate.format()+' '+
            (camp.EVE_Start_Time__c!=null?camp.EVE_Start_Time__c:'')):'';
            sEndDate=(camp.EndDate!=null)?(camp.EndDate.format()+' '+
            (camp.EVE_End_Time__c!=null?camp.EVE_End_Time__c:'')):'';
        }

    }
    /**
    * Method name  : removeDuplicateAccount
    * Description  : Use this method to remove duplicate account if added to
    *                 volunteer list twice
    * Return Type  : List<AccountWrapper>
    * Parameter    : List<AccountWrapper>
    **/  
    
    private List<AccountWrapper> removeDuplicateAccount(List<AccountWrapper>
    listAccountWrapper){
        Map<Id,AccountWrapper> mapAccountWrapper=new Map<Id,AccountWrapper>();
        for(AccountWrapper accountWrapperVar: listAccountWrapper)
        mapAccountWrapper.put(accountWrapperVar.account.Id,accountWrapperVar);
        return mapAccountWrapper.values();
    }

    //Shanu- Nov 2015 Changes made for COR0001494  
    /**
    * Method name  : FilterActivePartnerSupporterAccounts
    * Description  : Use this method to retrieve active Advocate type partner accounts 
                     and supporter accounts
    * Return Type  : List<Account>
    * Parameter    : List<Account>
    **/  
    
    public List<Account> FilterActivePartnerSupporterAccounts(List<Account> lstAccountTemp){
        List<Partner_Type__c> lstMatchedAdvocatePartner=new List<Partner_Type__c>();
        List<Account> lstActiveAdvocateAccount=new List<Account>();
        lstMatchedAdvocatePartner=[select Account__c  from Partner_Type__c where ((Account__c IN :lstAccountTemp) and (Type__c = 'Advocate') and (Advocate_Status__c ='Active'))];
        Schema.DescribeSObjectResult describeSchemaOfAccount =Schema.SObjectType.Account; 
        
        //Describe call for retrieving the record types 
        //and their corresponding ids in Account Object
        Map<Id,Schema.RecordTypeInfo> rtMapById = describeSchemaOfAccount.getRecordTypeInfosById();
        Map<String,Schema.RecordTypeInfo> rtMapByName = describeSchemaOfAccount.getRecordTypeInfosByName();
        
        Map<Id, Partner_Type__c> partnerTempMap = new Map<Id, Partner_Type__c>();
        if(lstMatchedAdvocatePartner.size()>0){
            for(Partner_Type__c oPartner : lstMatchedAdvocatePartner)
            {
                 partnerTempMap.put(oPartner.Account__c, oPartner);
            }
        }
        
        //This is used for assigning the record type id based 
        //on the name of the record type
        Id supporterRecordTypeId = rtMapByName.get('Supporter').getRecordTypeId();
        Id partnerRecordTypeId = rtMapByName.get('Partner').getRecordTypeId();
        Id agencyRecordTypeId = rtMapByName.get('Agency').getRecordTypeId();
        
        for(Account oAccount:lstAccountTemp ){
            if(oAccount.recordTypeId == supporterRecordTypeId || (partnerTempMap!=null && partnerTempMap.containsKey(oAccount.Id))){
                lstActiveAdvocateAccount.add(oAccount);
            }
        }
        return lstActiveAdvocateAccount;
}
}