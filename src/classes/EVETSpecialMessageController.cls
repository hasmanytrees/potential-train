public with Sharing class EVETSpecialMessageController{
    /*************************************************************************
    Name             : EVETSpecialMessageController
    Description      : Class used to handle Special Email Message Sending to 
                       various Advocates and Volunteers.                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Subhojit              30/10/2014         Created
    Subhojit              29/01/2015         Modified for code re-factoring & 
                                             optimization
    Shanu                 25/11/2015         Changes made for COR0001494                                              
    **************************************************************************
    */
    //Class variable defined for use both inside the controller and on the page 
    //for rendering the required values.
    public Campaign campaignOwner{get;set;}
    public boolean bSuccess{get;set;}
    public boolean bIsSystemAdmin{get;set;}
    public List<SelectOption> lstAllDistance{get;set;}
    public String sSelectedDistance{get;set;}
    public String sSelectedDistanceByEvent{get;set;}
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
    Map<Id,String> mapZipCodeEvent{get;set;}
    public boolean bIsNoRecord{get;set;}
    boolean bIsSearchByEvent{get;set;}
    public boolean bIsNew{get;set;}
    Set<Id> setVolunteerIds{get;set;}
    User userVar{get;set;}
     public  Map<Id,List<Volunteer_Slot__c>> mapEventVSlot{get;set;}
    public Set<id> setCampaignId{get;set;}
    public boolean bIsHidden{get;set;}
    List<AccountWrapper> lstSelectedAccountWrapper{get;set;}
    public List<SelectOption> lstAllCampaign{get;set;}
     public boolean  bIsContionueBatch{get;set;}
    Static Final Integer BATCH_CHUNK_LIMIT=Integer.valueOf(System.Label.EVETBatchLimit);
   
      public boolean isLastBatch{get;set;}
    List<AccountWrapper> lstAccountWrapperTemp{get;set;}
    public Integer iTotalSize{get;set;}
    public Integer iTotalEmailCount{get;set;}
    /**
    * Method name  : Constructor
    * Description  :This method is initiate constructor related methods and 
    *                class variable values assignment.
    * Return Type  : void
    * Parameter    : void
    **/   
    public EVETSpecialMessageController(){
        campaignOwner=new Campaign();
        iTotalSize=0;
        iTotalEmailCount=0;
       
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
       campaignOwner.Published_Volunteer_Coordinator_Name__c=UserInfo.getName();
        lstAllDistance=new List<SelectOption>{new SelectOption('5','5'),
        new SelectOption('10','10'),new SelectOption('20','20')};
        sSelectedDistance='5';
        lstAllActiveCampaign=new List<Campaign>();
        bShowAdvocates=false;
        bShowSecondPage=false;
        
      
        lstAllDistance=new List<SelectOption>{new SelectOption('5','5'),
        new SelectOption('10','10'),new SelectOption('15','15'),
        new SelectOption('25','25'),new SelectOption('50','50'),
        new SelectOption('75','75'),new SelectOption('100','100')};
        sSelectedDistance='5';
        sSelectedDistanceByEvent='5';
        init();
    }
    /**
    * Method name  : init
    * Description  :This method is initiate certain conditions for execution 
    *                initially.
    * Return Type  : void
    * Parameter    : void
    **/  
    public void init(){
        lstAllCampaign=new List<SelectOption>();
        bSuccess=false;
        lstAllActiveCampaign=new List<Campaign>();
        lstAccountWrapper=new List<AccountWrapper>();
         mapEventVSlot=new Map<Id,List<Volunteer_Slot__c>>();
        mapZipCodeEvent=new Map<Id,String>();
        setCampaignId=new Set<Id>();
        setVolunteerIds=new Set<Id>();
        //SOQL to retrieve all record informations related to the event location
        // in concern.
        lstAllActiveCampaign=[select Address_1__c,Address_2__c,Address_3__c,
        Campaign__c,Event__r.Name,Id,VEN_Name__c,Venue__C,Name,OwnerId,City__c,
        State__c,ZIP_Code__c,Country__c,
        Volunteer_Coordinator__r.Name,Volunteer_Coordinator__r.FirstName,
        Partner_Website__c,Venue__r.Name,Venue__r.Address__c,
        Published_Location_Name__c,Published_Volunteer_Coordinator_Email__c,
        Published_Volunteer_Coordinator_Name__c,EVE_Start_Time__c,
        EVE_End_Time__c,Volunteer_Coordinator__r.LastName,
        Volunteer_Coordinator__r.Email,Volunteer_Coordinator__r.Phone,Status,
        StartDate,EndDate,(select Id,Start_Time__c,End_Time__c,Date__c,
        Volunteer_Role__c from Volunteer_Shift__r)
        from Campaign where Publish_To_Web__c=true and ((status='Completed' or
        Status='Confirmed' or Status='Cancelled') and (EndDate=LAST_N_DAYS:14 OR EndDate>=TODAY ) )
        and Published_Volunteer_Coordinator_Name__c =: 
        campaignOwner.Published_Volunteer_Coordinator_Name__c];
      for(Campaign oCampaignVar: lstAllActiveCampaign)
        setCampaignId.add(oCampaignVar.Id);
       List<Volunteer_Slot__c> lstVolunteerSlot=new List<Volunteer_Slot__c> ();  
        
        lstVolunteerSlot=[select Id,Date__c,Volunteer_Role__c,
        Volunteer__r.Preferred_Email_Address__c,
        Volunteer__r.Preferred_Phone_No__c,
        Volunteer__c,Volunteer__r.First_Name__c,
        Volunteer__r.Account_Full_Name__c,
        Volunteer__r.Name,Volunteer__r.Business_Phone__c ,
        Volunteer__r.Business_Email__c,Volunteer__r.Work_Email__c,
        Volunteer__r.Personal_Email__c,
        Volunteer_Shift__r.EventLocation__c,Status__c,
        Start_Time__c,End_Time__c,Volunteer__r.Home_Phone__c,
        Volunteer__r.Do_Not_Contact__c,Volunteer__r.Do_Not_Email__c,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.Phone,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.Email,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.FirstName,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.Name,
        Volunteer_Shift__r.EventLocation__r.Published_Location_Name__c,
    Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Name__c,
        Volunteer_Shift__r.EventLocation__r.Venue__r.Name,
        Volunteer_Shift__r.EventLocation__r.Venue__r.Address__c,
        Volunteer_Shift__r.EventLocation__r.Partner_Website__c,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.LastName,
        Volunteer_Shift__r.EventLocation__r.Name,Volunteer_Email_Update__c ,
   Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c,
        Volunteer_Shift__r.EventLocation__r.Dress_Code__c,
        Volunteer_Shift__r.EventLocation__r.Primary_Compassion_Contact__c,
        Volunteer_Shift__r.EventLocation__r.Primary_Compassion_Contact_Name__c,
   Volunteer_Shift__r.EventLocation__r.Primary_Compassion_Contact_Cell_Phone__c,
        Volunteer_Shift__r.EventLocation__r.Primary_Compassion_Contact_Email__c                      
        from Volunteer_Slot__c where Volunteer_Shift__r.EventLocation__c 
        IN :setCampaignId and Volunteer_Email_Update__c!=null and Status__c='Approved'];
        lstCampaignWrapper=new List<CampaignWrapper>();
        try{
            userVar=[select Id,Email,Phone,FirstName,LastName,Name from User 
            where Name=:campaignOwner.Published_Volunteer_Coordinator_Name__c];
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.ERROR,System.label.InvalidVolunteerCoordinator);
            //Please enter a ZIP Code
            ApexPages.addMessage(myMsg);
           
        }
        //Iteration to add campaign values to wrapper and certain conditions to 
        //the lst and map simultaneously.
        lstAllCampaign.add(new SelectOption('','- None -'));
        for(Campaign campaignVar:lstAllActiveCampaign){
            lstCampaignWrapper.add(new CampaignWrapper(campaignVar,false));
          lstAllCampaign.add(new SelectOption(campaignVar.Id,CampaignVar.Name));
            mapZipCodeEvent.put(campaignVar.Id,campaignVar.ZIP_Code__c);
            //loop is executed for adding volunteer slots records for the event location
       
            List<Volunteer_Slot__c> lstVolunteerSlotVar = 
            new List<Volunteer_Slot__c>();
            for(Volunteer_Slot__C oVolunteerSlotVar: lstVolunteerSlot){
                if(oVolunteerSlotVar.Volunteer_Shift__r.EventLocation__c == 
                campaignVar.Id){
                   lstVolunteerSlotVar.add(oVolunteerSlotVar);
                 
                }
            }
            mapEventVSlot.put(campaignVar.Id,lstVolunteerSlotVar);
        }
            
        
        //Condition to check if any event is related to the corresponding 
        //location and assigning values to boolean flag for display on the page.
        sSelectedEvent='';
        if(lstAllActiveCampaign.size()==0)
        bIsNoRecord=true;
        else
        bIsNoRecord=false;
        bShowAdvocates=false;
        bShowSecondPage=false;
        bIsSearchByEvent=false;
        bIsNew=false;
        bIsHidden=false;
        sZIPCode='';
    }
    
    
     public void showVolunteers(){
        bShowAdvocates=false;
         for(Volunteer_Slot__c oVolunteerVar: mapEventVSlot.get(sSelectedEvent)){
         
            setVolunteerIds.add(oVolunteerVar.Volunteer__c);
         
         
         }
        
        List<Account> lstAccount=new List<Account>();
        //Shanu- Added RecordTypeId in the query for COR0001494                                              
        lstAccount=[select Id,RecordTypeId, Account_Full_Name__c,Name,BillingStreet,
        BillingCity,BillingState,BillingCountry,BillingPostalCode,ShippingCity,
        ShippingState,ShippingStreet,Personal_Email__c,Work_Email__c,
        /*Business_Phone__c,Preferred_Email__c,/Migration */
        ShippingCountry,ShippingPostalCode,Mailing_Country__c,
        Mailing_State_Province__c,Mailing_Street__c,Mailing_City__c,
        Business_Email__c,Preferred_Email_Address__c,
        Mailing_Zip_Postal_Code__c,Do_not_Email__c,C_o_Biling_Address__c,
        C_o_Mailing_Address__c,C_o_Physical_Address__c,Business_Phone__c,
        Preferred_Phone_No__c,First_Name__c,Do_Not_Contact__c,
         (select Id,Name,
        Volunteer_Appeals_Email_Opt_Out__c,Volunteer_Appeals_Active__c 
        from Communication_Preferences__r ) from Account 
        where (Id IN :setVolunteerIds) 
        and  (Preferred_Email_Address__c!=null)];
        
        //Shanu- Nov 2015 Changes made for COR0001494 
        List<Account> lstActiveAdvocateAccount=new List<Account>();
        if(lstAccount.size()>0)
            lstActiveAdvocateAccount=FilterActivePartnerSupporterAccounts(lstAccount);
            
        lstAccount=lstActiveAdvocateAccount;
        Set<AccountWrapper> setVolunteerWrapper=new Set<AccountWrapper>();
        //Iteration to check for the volunteers; communication preferences
        for(Account oAccountVar:lstAccount){
           
             setVolunteerWrapper.add(new AccountWrapper(oAccountVar,true));
             
             
        }
        if(setVolunteerWrapper.size()==0){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.NoVolunteerFound);
            //No approved Volunteer(s) found for this event.
            ApexPages.addMessage(myMsg);
            return;
        }
        //Adding all the volunteer to the wrapper list for display
        lstAccountWrapper.addAll(setVolunteerWrapper);
        lstAccountWrapper=removeDuplicateAccount(lstAccountWrapper);
        iNoOfAdvocate=lstAccountWrapper.size();
        bShowAdvocates=true;
    }
    
  
    
    /**
    * Method name  : getNearByPinCodeListByEvent
    * Description  :This getter method is used to retrieve pin code lst based 
    *               on the event. 
    * Return Type  : void
    * Parameter    : void
    **/  
    public void getNearByPinCodeListByEvent(){
        if((sSelectedEvent=='')||(sSelectedEvent==null)){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.ZIPCodeError);//Please choose one Event Location
            ApexPages.addMessage(myMsg);
            return;      
        }
        bIsSearchByEvent=true;
        for(CampaignWrapper campaignWrpVar: lstCampaignWrapper){
            if(campaignWrpVar.campaign.Id==sSelectedEvent)
            campaignWrpVar.bIsSelected=true;
            else
            campaignWrpVar.bIsSelected=false; 
        }
        getNearByPinCodeList();
    } 
    /**
    * Method name  : getNearByPinCodeList
    * Description  :This getter method is used to retrieve pin code lst based 
            on the event and use it for finding volunteers located around by
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public void getNearByPinCodeList(){
        bShowAdvocates=false;
        if(bIsSearchByEvent==false){
            if(sZIPCode==''){
                ApexPages.Message myMsg = 
                new ApexPages.Message(ApexPages.Severity.ERROR,
                System.label.MissingZipCode);//Please enter a ZIP Code
                ApexPages.addMessage(myMsg);
                return;      
            }
        }
        //HTTP call out is made for finding all the volunteers based on their 
        //zip code and distance from event location
        HttpRequest request = new HttpRequest();
        Integration_Endpoints__c integrationDetails = 
        Integration_Endpoints__c.getAll().get('Zip Code Search'); 
        //Getting ZIP code search End Point
        String sURL=integrationDetails.Endpoint_URL__c;
        sURL+=integrationDetails.Authorization_Code__c;
        if(sZIPCode.length()>5)
        sZIPCode=sZIPCode.subString(0,5);
        if(bIsSearchByEvent==false)
        sURL+='/radius.json/'+sZIPCode+'/'+sSelectedDistance+'/'+'km';
        else{
            if(mapZipCodeEvent.get(sSelectedEvent).length()>5)
            sURL+='/radius.json/'+mapZipCodeEvent.get
            (sSelectedEvent).subString(0,5)+'/'+
            sSelectedDistanceByEvent+'/'+'mile';
            else
            sURL+='/radius.json/'+mapZipCodeEvent.get(sSelectedEvent)+'/'+
            sSelectedDistanceByEvent+'/'+'mile'; 
        }
        if(sSelectedEvent!=null)
        bIsNew=true;
        else
        bIsNew=false;
       
        Http http= new Http();
        request.setEndPoint(sURL);
        request.setMethod('POST');
        HTTPResponse response = http.send(request);
        if(response.getStatusCode()!=200 ){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.ErrorOccoredInZipSearch);
    //Some Error Occurred in Searching ZIP Code.Please check the zip code again.
            ApexPages.addMessage(myMsg);
            if(lstAccountWrapper.size()>0){
                bShowAdvocates=true;
            }
            bIsSearchByEvent=false;
            return; 
        }
  //Creating a lst which stores the response for volunteer lst provided in JSON
        List<String> lstMatchedZipCode=new List<String>();
        String sResponseString=response.getBody();
        JsonHandler.ZipCodeSearchData zipData = (JsonHandler.ZipCodeSearchData)
        JSON.deserialize(sResponseString ,JsonHandler.ZipCodeSearchData .class);
        for(JsonHandler.ZipCodeDetails zipDetails:zipData.zip_codes){
            lstMatchedZipCode.add(zipDetails.zip_code+'%');
              
        }
        //SOQL to retrieve all Account information for the identified volunteers
        //Shanu- Added RecordTypeId in the query for COR0001494                    
        List<Account> lstMatchedAccount=new List<Account>();
        lstMatchedAccount=[select Id,RecordTypeId,Account_Full_Name__c,Name,BillingStreet,
        BillingCity,BillingState,BillingCountry,BillingPostalCode,ShippingCity,
        ShippingState,ShippingStreet,Personal_Email__c,Work_Email__c,
        /*Business_Phone__c,Preferred_Email__c,/Migration */
        ShippingCountry,ShippingPostalCode,Mailing_Country__c,
        Mailing_State_Province__c,Mailing_Street__c,Mailing_City__c,
        Business_Email__c,Preferred_Email_Address__c,
        Mailing_Zip_Postal_Code__c,Do_not_Email__c,C_o_Biling_Address__c,
        C_o_Mailing_Address__c,C_o_Physical_Address__c,Business_Phone__c,
        Preferred_Phone_No__c,First_Name__c, (select Id,Name,
        Volunteer_Appeals_Email_Opt_Out__c,Volunteer_Appeals_Active__c 
        from Communication_Preferences__r ) from Account 
        where ((ADV_Preferred_Zip_Code__c like :lstMatchedZipCode)
       )   and Preferred_Email_Address__c!=null];
       
       //Shanu- Nov 2015 Changes made for COR0001494 
        List<Account> lstActiveAdvocateAccount=new List<Account>();
        if(lstMatchedAccount.size()>0)
            lstActiveAdvocateAccount=FilterActivePartnerSupporterAccounts(lstMatchedAccount);
                
        //If the corresponding volunteers are not found suitable message is 
        //displayed to the user.
        lstMatchedAccount=lstActiveAdvocateAccount;
        if(lstMatchedAccount.size()==0){
            if(!bIsSearchByEvent){
                ApexPages.Message myMsg = new ApexPages.Message
                (ApexPages.Severity.ERROR,System.label.NoAdvocateFound);
 //No Advocate found.Please check Zip code and filter criteria. NoAdvFoundByEL
                ApexPages.addMessage(myMsg);
            }
            else{
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.NoAdvFoundByEL);
 //No Advocate found.Please check Zip code and filter criteria. NoAdvFoundByEL
                ApexPages.addMessage(myMsg);
            }
            if(lstAccountWrapper.size()>0){
                bShowAdvocates=true;
            }
            bIsSearchByEvent=false;   
            return;
        }
        //Creating an instance of account wrapper and adding all identified
        //volunteer information in the same.
        if((lstAccountWrapper==null)||(lstAccountWrapper.size()==0))
        lstAccountWrapper=new List<AccountWrapper>();
        for(Account accountVar:lstMatchedAccount){
           AccountWrapper accountWrapperVar=new AccountWrapper(accountVar,true);
            lstAccountWrapper.add(accountWrapperVar);
        }
        if(lstAccountWrapper.size()>0)
        lstAccountWrapper=removeDuplicateAccount(lstAccountWrapper);
        iNoOfAdvocate= lstAccountWrapper.size();
        bShowAdvocates=true;
        bIsSearchByEvent=false;
    }
    /**
    * Method name  : getAccountByEmails
    * Description  :This getter method is used to retrieve pin code lst based on 
    *              the event and use it for finding volunteers located around by.
    * Return Type  : void
    * Parameter    : void
    **/
    public void getAccountByEmails(){
        if(sEmailIds==''){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.AddMinOneEmail);//Please enter at least one email
            ApexPages.addMessage(myMsg);
            return;      
        }
        List<String> lstEmailId=new List<String>();
        if(sEmailIds!=null)
        lstEmailId=sEmailIds.split('\n');
        if(lstEmailId.size()>50){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.SpecialMessageMaxEmailLimit);
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
        sQuery+='} IN EMAIL FIELDs RETURNING Account(Name,RecordTypeId,Id,Account_Full_Name__c,Personal_Email__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode, ShippingCity,ShippingState,ShippingStreet,Preferred_Email__c,ShippingCountry,ShippingPostalCode,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_City__c,Business_Email__c,Type,Preferred_Email_Address__c,Mailing_Zip_Postal_Code__c,Do_not_Email__c,C_o_Biling_Address__c,C_o_Mailing_Address__c,C_o_Physical_Address__c,Business_Phone__c ,First_Name__c,Preferred_Phone_No__c,SUP_Service_Level__c,Work_Email__c where Preferred_Email_Address__c!=null AND ((Do_Not_Contact__c=false) AND (Do_not_Email__c=false)) )';
        
        //SOQL to retrieve all Account information for the identified volunteers
        //for receiving emails.
        List<Account> lstMatchedAccount=new List<Account>();
        
        
        List<List<sObject>> lstAllAccount=new List<List<sObject>>();
        lstAllAccount=search.query(sQuery);
        if(lstAllAccount.size()>0)
        lstMatchedAccount=(List<Account>)lstAllAccount[0];
        Set<String> setAccountIds=new Set<String>();
        
        //Shanu- Nov 2015 Changes made for COR0001494 
        List<Account> lstActiveAdvocateAccount=new List<Account>();
        if(lstMatchedAccount.size()>0)
        lstActiveAdvocateAccount=FilterActivePartnerSupporterAccounts(lstMatchedAccount);
         
        lstMatchedAccount=lstActiveAdvocateAccount;
        
        if(lstMatchedAccount.size()==0){
            ApexPages.Message myMsg = new
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.NoAdvocateFoundEmail); 
            //No Advocate found.Please check the email address.
            ApexPages.addMessage(myMsg);
            if(lstAccountWrapper.size()>0){
                bShowAdvocates=true;
            }
            bIsSearchByEvent=false;
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
        iNoOfAdvocate= lstAccountWrapper.size();
        bShowAdvocates=true;
        bIsSearchByEvent=false;
    }
    /**
    * Method name  : back
    * Description  :This method is used to go back to the main page if nothing 
    *                has to be done by the User.
    * Return Type  : void
    * Parameter    : void
    **/
    public void back()
    {
        bShowSecondPage=false;
    } 
    
    
    
    
    
    
    /**
    * Method name  : gotoSecondPage
    * Description  :This method is used to go to the second page for the User
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public void gotoSecondPage(){
        lstSelectedAccountWrapper=new List<AccountWrapper>();
        iNoOfSelectedAdvocate=0;
        for(AccountWrapper accountVar:lstAccountWrapper) {
            if(accountVar.bIsSelected==true) {  
                lstSelectedAccountWrapper.add(accountVar);
                iNoOfSelectedAdvocate++;
            }
        }
        //Condition to check if any Advocates has been identified if no then
        //provide a User friendly message
        if(lstAccountWrapper.size()==0){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.NoAdvocateFound);
            //No Advocate to proceed.Please verify zip code filter.
            ApexPages.addMessage(myMsg);
            return;
        }
        //Condition to check if any Advocates has been selected by the user if
        //no then provide a User friendly message
        else if(iNoOfSelectedAdvocate==0){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.SelectOneVolunteer); 
            //Please select at least one advocate to proceed
            ApexPages.addMessage(myMsg);
            return;
        }
        bShowSecondPage=true;
        bShowAdvocates=false;
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
    * Description  :This method is used to send final email
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public void sendEmail(){
        boolean bIsAnyEventChecked=false;
         if((sSpecialNote!=null)&&(sSpecialNote.contains('\n')))
        sSpecialNote=sSpecialNote.replace('\n','<br/>');
        /*//Apurva - Changes made for COR0001535
        Integer countDoubleQuotes = 0;
        if((sSpecialNote!=null)&&(sSpecialNote.contains('"')))
            countDoubleQuotes = sSpecialNote.countMatches('"');
        
         if((sSpecialNote!=null) && sSpecialNote.length() + countDoubleQuotes >3999){
            
            Integer iExceedingLength = (sSpecialNote.length() + countDoubleQuotes) - 3999;
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.Error,
            'Email length is greater than 4000 characters. Please reduce message by '+iExceedingLength+' characters.'
            +'If email contains ", it will be calculated as 2 characters while sending message');
            ApexPages.addMessage(myMsg);
            bIsContionueBatch=false;
            iTotalSize=0;
            return;
        }
        System.debug('Special Msg Length : '+ sSpecialNote.length());*/
        
        if(lstCampaignWrapper.size()>0){
            for(CampaignWrapper campaignWrpVar: lstCampaignWrapper){
                if(campaignWrpVar.bIsSelected==true)
                bIsAnyEventChecked=true;
            }
        }
        if( bIsAnyEventChecked==false){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.Error,
        System.label.SelectOneCampaign);//Please select at least one Campaign.
            ApexPages.addMessage(myMsg);
            bIsContionueBatch=false;
            iTotalSize=0;
            
            return;
        }
        Integer iNoOfSelectedVolunteer=0;          
        String sShiftRuleVar; 
        List<Account> lstSelectedAccount=new List<Account>();
        List<AccountWrapper> lstSelecetedAccoutWrapperFinal = 
        new List<AccountWrapper>();
       
String sShiftRule='<p><font size=\'2\' face=\'Arial, Helvetica, sans-serif\'><strong>';
        String sLocationText='';
        String sIdString='';
        for(CampaignWrapper campaignVar: lstCampaignWrapper){
            if(campaignVar.bIsSelected){
               
                sIdString+=campaignVar.campaign.Id+'#';
            }
        }
        
        sIdString=sIdString.subStringbeforeLast('#');
        //Adding Other recipient in accountWrapper
        for(AccountWrapper lstAccountWrappervar: lstAccountWrapperTemp){
            AccountWrapper accountWrapperVar = 
            new AccountWrapper(new Account(),true);
            accountWrapperVar.account.Compassion_Background__c = 
            (sSpecialNote!='')?sSpecialNote:null;
            accountWrapperVar.account.Hobbies__c=null;
            accountWrapperVar.account.Business_Type__c=sIdString;
            accountWrapperVar.account.Research_Comments__c = 
            lstAccountWrapperVar.account.Id;
            accountWrapperVar.account.T_Shirt_Size__c = 
    lstAccountWrapperVar.account.Id.getSObjectType().getDescribe().getName(); 
            accountWrapperVar.account.Occupation_Details__c = 
        lstCampaignWrapper[0].Campaign.Published_Volunteer_Coordinator_Email__c;
            accountWrapperVar.account.Segment_Type__c=userVar.FirstName ;
            accountWrapperVar.account.VEN_Service__c=userVar.LastName;
            accountWrapperVar.account.Social_Profile_s__c=null;
            accountWrapperVar.account.Mailing_State_Province__c = 
        EVET_Template_Id__c.getAll().get('EVETSpecialMessage').Template_ID__c;
            accountWrapperVar.account.Business_Phone__c = userVar.Phone;
            accountWrapperVar.account.Business_Email__c = 
            lstAccountWrapperVar.account.Preferred_Email_Address__c;
            accountWrapperVar.account.Id=lstAccountWrapperVar.account.Id;
            accountWrapperVar.account.First_Name__c = 
            (lstAccountWrapperVar.account.First_Name__c!=null)?
            lstAccountWrapperVar.account.First_Name__c:
            lstAccountWrapperVar.account.Account_Full_Name__c;
            lstSelecetedAccoutWrapperFinal.add(accountWrapperVar);
           
        }
        
        if((LstSelectedAccountWrapper.size()>0)&&(isLastBatch)){
            Account accountVar=new Account();
           
            accountVar.Compassion_Background__c = 
            (sSpecialNote!='')?sSpecialNote:null;
            accountVar.Hobbies__c=null;
            accountVar.Occupation_Details__c = 
        lstCampaignWrapper[0].Campaign.Published_Volunteer_Coordinator_Email__c;
            accountVar.Segment_Type__c=userVar.FirstName;
            accountVar.VEN_Service__c=userVar.LastName;
            accountVar.Social_Profile_s__c=null;
            accountVar.Business_Type__c=sIdString;
            accountVar.Research_Comments__c=userVar.Id;
            accountVar.T_Shirt_Size__c=userVar.Id.getSObjectType().getDescribe().getName(); 
            accountVar.Mailing_State_Province__c = 
        EVET_Template_Id__c.getAll().get('EVETSpecialMessage').Template_ID__c;
            accountVar.Id=null;
            accountVar.First_Name__c = 
        lstCampaignWrapper[0].Campaign.Published_Volunteer_Coordinator_Name__c+' (Notification)';
            accountVar.Business_Phone__c = userVar.Phone;
            accountVar.Business_Email__c = 
        lstCampaignWrapper[0].Campaign.Published_Volunteer_Coordinator_Email__c;
        lstSelecetedAccoutWrapperFinal.add(new AccountWrapper(accountVar,true));  
        }
        
        for(AccountWrapper accountWrapperVar: lstSelecetedAccoutWrapperFinal){
            lstSelectedAccount.add(accountWrapperVar.account);
        }
       
// Check for identifying if no volunteer has been selected for sending the email
        Integer iRecpNo=1;
        for(Account accountVar: lstSelectedAccount){
            accountVar.Recognitions_and_Accomplishments__c = 
            String.valueOf(lstSelectedAccount.size());
            accountVar.Country_Of_Origin__c=String.valueOf(iRecpNo);
            iRecpNo++;
        }
        
        boolean bStatus=SendEmailUsingXMPie.sendEmail(lstSelectedAccount);
       if(!bStatus){
       
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
            System.Label.ErrorOccoredInEmailSending);
            ApexPages.addMessage(myMsg); 
       bIsContionueBatch=false;
            iTotalSize=0;

       }
        return;
    }
    public void hideSearchResult(){
        if(bIsHidden==true)
        bIsHidden=false;
        else
        bIsHidden=true;
    }
    /**
    * Class name  : AccountWrapper
    * Description  :This wrapper class is used to hold account related 
    *                information and their selection by user.
    * Return Type  : void
    * Parameter    : void
    **/
    public class AccountWrapper{
        public Account account{get;set;}
        public boolean bIsSelected{get;set;}
        public AccountWrapper(Account acc,boolean isSelected){
            account=acc;
            bIsSelected=isSelected;
        }
    }
    /**
    * Class name  : CampaignWrapper
    * Description  :This wrapper class is used to hold campaign related 
    *                information and their selection by user.
    * Return Type  : void
    * Parameter    : void
    **/
    public class CampaignWrapper{
        public Campaign campaign{get;set;}
        public boolean bIsSelected{get;set;}
        public String sStartDate{get;set;}
        public String sEnddate{get;set;}
        public CampaignWrapper(Campaign camp,boolean isSelected){
            campaign=camp;
            bIsSelected=isSelected;
            sStartDate=(camp.StartDate!=null)?(camp.StartDate.format()+' '+
            (camp.EVE_Start_Time__c!=null?camp.EVE_Start_Time__c:'')):'';
            sEndDate=(camp.EndDate!=null)?(camp.EndDate.format()+' '+
            (camp.EVE_End_Time__c!=null?camp.EVE_End_Time__c:'')):'';
        }
    }
    /**
    * Method name  : removeDuplicateAccount
    * Description  : Use this method to remove duplicate account if added to 
    *                volunteer lst twice.
    * Return Type  : List<AccountWrapper>
    * Parameter    : List<AccountWrapper>
    **/  
    private List<AccountWrapper> removeDuplicateAccount(List<AccountWrapper> 
    lstAccountWrapper){
        Map<Id,AccountWrapper> mapAccountWrapper=new Map<Id,AccountWrapper>();
        for(AccountWrapper accountWrapperVar: lstAccountWrapper)
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