public with Sharing class EVETEventDetailsEmailController{
    /**************************************************************************
    Name             : EVETEventDetailsEmailController
    Description      : Class used to handle Email Sending to various Advocates 
                        and Volunteers.                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Subhojit              30/10/2014         Created
    Subhojit              29/01/2015         Modified for code re-factoring & 
                                             optimization
    Apurva                09/03/2015         Changes made for INC0066556                
    ***************************************************************************
    */
    //Class variable defined for use both inside the controller and on the page
    //for rendering the required values.
    public Campaign campaignOwner{get;set;}
    public boolean bSuccess{get;set;}
    public List<SelectOption> lstAllDistance{get;set;}
    public String sEventIdSelected{get;set;}
    public String sSelectedDistance{get;set;}
    public List<Campaign> lstAllActiveCampaign{get;set;}
    public List<VolunteerWrapper> lstVolunteerWrapper{get;set;}
    public String sEventId{get;set;}
    public List<CampaignWrapper> lstCampaignWrapper{get;set;}
    Map<Id,Campaign> mapEvent{get;set;}
    public boolean bShowAdvocates{get;set;}
    public boolean  bShowSecondPage{get;set;}
    public Integer iNoOfVolunteer{get;set;}
    public  Map<Id,List<Volunteer_Slot__c>> mapEventVSlot{get;set;}
    public boolean bShowVolunteer{get;set;}
    public String sSpecialNote{get;set;}
    public boolean bIsNoRecord{get;set;}
    public boolean bIsSystemAdmin{get;set;}
    user userVar;
    public boolean bIsHidden{get;set;}
    List<VolunteerWrapper> lstSelectedVolunteerWrapper{get;set;}
    List<VolunteerWrapper> lstVolunteerWrapperTemp{get;set;}
    Static Final Integer BATCH_CHUNK_LIMIT=Integer.valueOf(System.Label.EVETBatchLimit);
    List<Volunteer_Slot__c> lstrelatedVolunteerSlot {get;set;}
     public boolean  bIsContionueBatch{get;set;}
    public Integer iTotalSize{get;set;}
    public Integer iTotalEmailCount{get;set;}
      public boolean isLastBatch{get;set;}
    /**
    * Method name  : Constructor
    * Description  :This method is initiate constructor related methods and 
    *               class variable values assignment.
    * Return Type  : void
    * Parameter    : void
    **/   
    public EVETEventDetailsEmailController(){
        campaignOwner=new Campaign();
         try{
         bIsContionueBatch=false;
         iTotalSize=0;
         iTotalEmailCount=0;
        Profile oProfile=[SELECT Id, Name, Description
                            FROM Profile
                            WHERE  PermissionsAuthorApex = true and Id=:UserInfo.getProfileId() ];
        if( oProfile!=null)
          bIsSystemAdmin=true;                 
       }
       catch(Exception ex){
       
        bIsSystemAdmin=false;
       }
      campaignOwner.Published_Volunteer_Coordinator_Name__c = 
      UserInfo.getName();
        lstAllDistance=new List<SelectOption>{new SelectOption('5','5'),
        new SelectOption('10','10'),new SelectOption('20','20')};
        sSelectedDistance='5';
        bShowAdvocates=false;
        bShowSecondPage=false;
        mapEvent=new Map<Id,Campaign>();
        init();
    }
    /**
    * Method name  : init
    * Description  :This method is initiate certain conditions for execution 
    *                initially
    * Return Type  : void
    * Parameter    : void
    **/   
    public void init(){
        lstAllActiveCampaign=new List<Campaign>();
        bSuccess=false;
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
        //SOQL to retrieve the event location record Type
        Recordtype recordtype=[select Id from Recordtype where 
        sObjectType='Campaign' and DeveloperName='Event_Location'];
        //SOQL to retrieve detailed record for the concerned event location
        lstAllActiveCampaign=[select Address_1__c,Address_2__c,Address_3__c,
        Campaign__c,Event__r.Name,Id,VEN_Name__c,Venue__C,Name,OwnerId,City__c,
        State__c,ZIP_Code__c,Country__c,Volunteer_Coordinator__c,
        Volunteer_Coordinator__r.Name,Volunteer_Coordinator__r.FirstName,
        Published_Location_Name__c,Dress_Code__c,Primary_Compassion_Contact__c,
        Primary_Compassion_Contact_Name__c,
        Primary_Compassion_Contact_Cell_Phone__c,
        Primary_Compassion_Contact_Email__c,EVE_Start_Time__c,EVE_End_Time__c,
        Volunteer_Coordinator__r.LastName,Volunteer_Coordinator__r.Email,
        Volunteer_Coordinator__r.Phone,Status,StartDate,EndDate,(select Id,
        Start_Time__c,End_Time__c,Date__c from Volunteer_Shift__r)
        from Campaign  where Publish_To_Web__c=true and 
        recordtypeId=:recordtype.Id and status='Confirmed' and EndDate>=
        TODAY and Published_Volunteer_Coordinator_Name__c =: 
        campaignOwner.Published_Volunteer_Coordinator_Name__c];
        List<Volunteer_Slot__c> lstVolunteerSlot=new List<Volunteer_Slot__c> ();
        try{
            userVar=[select Id,Email,Phone,FirstName,LastName,Name from User
            where Name=:campaignOwner.Published_Volunteer_Coordinator_Name__c];
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.InvalidVolunteerCoordinator);//Please enter a ZIP Code
            ApexPages.addMessage(myMsg);
            
        }
        Set<Id> setCampaignId=new Set<Id>();
        for(Campaign oCampaignVar: lstAllActiveCampaign)
        setCampaignId.add(oCampaignVar.Id);
        //SOQL to retrieve the Volunteer Slot records for the corresponding 
        //event location
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
        Volunteer_Shift__r.EventLocation__r.Primary_Compassion_Contact_Email__c,
        //Added by Apurva E.L Start/End Date and Time
        Volunteer_Shift__r.EventLocation__r.StartDate,
        Volunteer_Shift__r.EventLocation__r.EVE_Start_Time__c,
        Volunteer_Shift__r.EventLocation__r.EndDate,
        Volunteer_Shift__r.EventLocation__r.EVE_End_Time__c       
                              
        from Volunteer_Slot__c where Volunteer_Shift__r.EventLocation__c 
        IN :setCampaignId and Volunteer_Email_Update__c!=null];
        mapEventVSlot=new Map<Id,List<Volunteer_Slot__c>>();
        if(lstAllActiveCampaign.size()==0)
        bIsNoRecord=true;
        else
        bIsNoRecord=false;
        bShowVolunteer=false;
      Map<Id,Volunteer_Slot__c > mapVounteerId=new Map<Id,Volunteer_Slot__c >();
        for(Volunteer_Slot__c oVSlotVar: lstVolunteerSlot){
            mapVounteerId.put(oVSlotVar.Volunteer__c,oVSlotVar);
        }
      
        
   //Loop is executed for adding volunteer slots records for the event location
        for(Campaign oEventVar: lstAllActiveCampaign){
            mapEvent.put(oEventVar.Id,oEventVar);
            List<Volunteer_Slot__c> lstVolunteerSlotVar = 
            new List<Volunteer_Slot__c>();
            for(Volunteer_Slot__C oVolunteerSlotVar: lstVolunteerSlot){
                if(oVolunteerSlotVar.Volunteer_Shift__r.EventLocation__c == 
                oEventVar.Id){
                    lstVolunteerSlotVar.add(oVolunteerSlotVar);
                }
            }
            mapEventVSlot.put(oEventVar.Id,lstVolunteerSlotVar);
        }
        bIsHidden=false;
    }
    /**
    * Method name  : showVolunteers
    * Description  :This method is use to display the list of volunteers for the
    *               concerned location with their preferences for communication
    * Return Type  : void
    * Parameter    : void
    **/   
    public void showVolunteers(){
        bShowVolunteer=false;
        lstVolunteerWrapper=new List<VolunteerWrapper>();
        Set<VolunteerWrapper> setVolunteerWrapper=new Set<VolunteerWrapper>();
        //Iteration to check for the volunteers; communication preferences
        for(Volunteer_Slot__c oVolunteerVar: mapEventVSlot.get(sEventId)){
            if((oVolunteerVar.Status__c!=null)&&
            (oVolunteerVar.Status__c.equalsIgnoreCase(System.label.Approved))){
             setVolunteerWrapper.add(new volunteerWrapper(oVolunteerVar,true));
            } 
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
        lstVolunteerWrapper.addAll(setVolunteerWrapper);
        lstVolunteerWrapper=removeDuplicateAccount(lstVolunteerWrapper);
        iNoOfVolunteer=lstVolunteerWrapper.size();
        bShowVolunteer=true;
    }
    /**
    * Method name  : sendEmail
    * Description  :This method is used for sending email to the Volunteers 
    *                based on their communication preferences.
    * Return Type  : void
    * Parameter    : void
    **/ 
    
    
    public void getEmailBatch(){
        Integer iBatchSize=0;
         bIsContionueBatch=true;
         iTotalEmailCount=lstVolunteerWrapper.size();
        lstVolunteerWrapperTemp=new List<VolunteerWrapper > ();
        if((sSpecialNote!=null)&&(sSpecialNote.contains('\n')))
        sSpecialNote=sSpecialNote.replace('\n','<br/>');
        lstSelectedVolunteerWrapper=new List<VolunteerWrapper >();
        List<VolunteerWrapper > lstSelectedVolunteerWrapperTmp=new List<VolunteerWrapper >();
        lstrelatedVolunteerSlot = 
        new List<Volunteer_Slot__c>();
        Set<Id>  setVolunteerSelectdId=new Set<Id>();
        for(VolunteerWrapper volunteerVar: lstVolunteerWrapper){
          if(volunteerVar.bIsSelected){
           setVolunteerSelectdId.add(volunteerVar.volunteerSlot.Volunteer__c);
           lstSelectedVolunteerWrapperTmp.add(volunteerVar);
          }
        }
        lstrelatedVolunteerSlot=[select Id,Date__c,Volunteer__c,Start_Time__c,
        End_Time__c,Volunteer_Role__c from Volunteer_Slot__c where Volunteer__c 
        In :setVolunteerSelectdId and Volunteer_Shift__r.EventLocation__c =: 
        sEventIdSelected and Volunteer_Email_Update__c!=null
        order by Volunteer_Slot_Start_Date__c ASC]; //Apurva Added order by Volunteer_Slot_Start_Date__c ASC
        isLastBatch=false;
        for(Integer iIndex=iTotalSize;iIndex<lstSelectedVolunteerWrapperTmp.size();iIndex++ ){
        
           
           if((iBatchSize<BATCH_CHUNK_LIMIT)&&(iTotalSize<=lstSelectedVolunteerWrapperTmp.size())){
           
           
             if(lstVolunteerWrapper[iIndex]!=null){
             
                 if(iTotalEmailCount-iTotalSize<=BATCH_CHUNK_LIMIT)
                   isLastBatch=true; 
                 lstVolunteerWrapperTemp.add(lstSelectedVolunteerWrapperTmp[iIndex]);
             
              iTotalSize++;
              iBatchSize++;
             }
          }
          else
          break;
        
        
        
        }
        
         if(lstSelectedVolunteerWrapperTmp.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.ERROR,System.label.MissingVolunteer);
            //Please select at least one volunteer to proceed
            ApexPages.addMessage(myMsg);
             bIsContionueBatch=false;
            iTotalSize=0;
            return;
        }
    
   if(( lstVolunteerWrapperTemp.size()>0)&&(iTotalSize<=lstSelectedVolunteerWrapperTmp.size()))
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
    
    
    
    
    
    
    
    
      
    public void sendEmail(){
        Integer iNoOfSelectedVolunteer=0;
         List<Account> lstSelectedAccount=new List<Account>();
        String sShiftRuleVar;
     //   String sLocationText='';//Apurva-commenting and moving inside for block
      //Loop for execution of the volunteer specific details and identification
      //the required email body to be send  to each volunteer.
        for(VolunteerWrapper volunteerVar: lstVolunteerWrapperTemp){
            String sLocationText='';//Apurva moved inside for block - INC0066556
            if(volunteerVar.bIsSelected==true){
                lstSelectedVolunteerWrapper.add(volunteerVar);
                iNoOfSelectedVolunteer++;
                Account accountVar=new Account();
                //Creating shiftRule for XMPie message
        String sShiftRule='<p><font size=\'2\' face=\'Arial, Helvetica,sans-serif\'><strong>';
                for(Volunteer_Slot__c vSlotVar: lstrelatedVolunteerSlot){
                System.debug('Apurva vSlotVar'+ vSlotVar);
                if(vSlotVar.Volunteer__c == 
                volunteerVar.volunteerSlot.Volunteer__c){
                if((vSlotVar.End_Time__c!=null )&&
                (vSlotVar.Start_Time__c!=null) && vSlotVar.Date__c != null){
                String sStartDate =vSlotVar.Date__c.month()+
                '/'+vSlotVar.Date__c.day()+'/'+vSlotVar.Date__c.year();
                sShiftRule+='<li>'+vSlotVar.Volunteer_Role__c+' - '
                +sStartDate+' '+vSlotVar.Start_Time__c+' – '+ 
                vSlotVar.End_Time__c+'</li>';
                if(sLocationText== '')// Apurva if condition added
                {
                String sELStartDate =volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.StartDate.month()+
                '/'+volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.StartDate.day()+
                '/'+volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.StartDate.year();
                String sELEndDate =volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.EndDate.month()+
                '/'+volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.EndDate.day()+
                '/'+volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.EndDate.year();

                sLocationText=Utility.getLocationText
              (volunteerVar.volunteerSlot.Volunteer_Shift__r
              .EventLocation__r.Published_Location_Name__c,
//Apurva - Updated values being sent for INC0066556
//EL Start Date and End Date need to be sent in Event Information section
//                sStartDate+' '+volunteerVar.volunteerSlot.Start_Time__c, 
//                volunteerVar.volunteerSlot.End_Time__c,              
//              sStartDate+' '+vSlotVar.Start_Time__c,vSlotVar.End_Time__c,
sELStartDate + ' ' 
+ volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.EVE_Start_Time__c,
sELEndDate + ' '
+ volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.EVE_End_Time__c,
volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.Venue__r.Name,
volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.Venue__r.Address__c,
volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.Partner_Website__c,
false,0,true,
volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.Dress_Code__c,
            volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r
            .Primary_Compassion_Contact_Name__c,
            volunteerVar.volunteerslot.Volunteer_Shift__r.EventLocation__r
            .Primary_Compassion_Contact_Email__c,
            volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r
            .Primary_Compassion_Contact_Cell_Phone__c);
            }
                        }
                    }
                }
        sShiftRule+='</strong></font></p>';
        sShiftRuleVar=sShiftRule;
        //Adding Volunteer Co ordinator as default recipient
        accountVar.Compassion_Background__c = 
        (sSpecialNote!='')?sSpecialNote:null;
        accountVar.Hobbies__c = (sLocationText!='')?sLocationText:NULL;
        accountVar.Occupation_Details__c = volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c;
        accountVar.Segment_Type__c =  userVar.FirstName;
        accountVar.VEN_Service__c = userVar.LastName;
        accountVar.Social_Profile_s__c = 
        (sShiftRule!='')?sShiftRule:NULL;
        accountVar.Business_Type__c = 
        volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__c;
        accountVar.Research_Comments__c = 
        volunteerVar.volunteerSlot.Volunteer__c;
        accountVar.T_Shirt_Size__c = 
        volunteerVar.volunteerSlot.Volunteer__c.getSObjectType()
        .getDescribe().getName(); 
        accountVar.Mailing_State_Province__c = 
        EVET_Template_Id__c.getAll()
        .get('EVETEventDetailsEmail').Template_ID__c;
        accountVar.Id=volunteerVar.VolunteerSlot.Volunteer__c;
        accountVar.First_Name__c = 
        (volunteerVar.VolunteerSlot.Volunteer__r.First_Name__c!=null)?
        volunteerVar.VolunteerSlot.Volunteer__r.First_Name__c:
        volunteerVar.VolunteerSlot.Volunteer__r.Account_Full_Name__c;
        accountVar.Business_Phone__c=userVar.Phone;
        accountVar.Business_Email__c = 
        volunteerVar.VolunteerSlot.Volunteer_Email_Update__c;
        lstSelectedAccount.add(accountVar);
            }
        }
        if((lstSelectedAccount.size()>0)&&(isLastBatch)){ 
            Account accountVar=new Account();
            accountVar.Compassion_Background__c = 
            (sSpecialNote!='')?sSpecialNote:null;
            accountVar.Hobbies__c=lstSelectedAccount[0].Hobbies__c;
            accountVar.Occupation_Details__c = lstVolunteerWrapper[0].volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c;
            accountVar.Segment_Type__c=userVar.FirstName;
            accountVar.VEN_Service__c=userVar.LastName;
            accountVar.Social_Profile_s__c = 
            (sShiftRuleVar!='')?sShiftRuleVar:NULL;
            accountVar.Business_Type__c=lstVolunteerWrapper[0]
            .volunteerSlot.Volunteer_Shift__r.EventLocation__c;
            accountVar.Research_Comments__c=userVar.Id;
            accountVar.T_Shirt_Size__c=userVar.Id.getSObjectType().getDescribe().getName(); 
            accountVar.Mailing_State_Province__c=EVET_Template_Id__c.getAll()
            .get('EVETEventDetailsEmail').Template_ID__c;
            accountVar.Id=null;
            accountVar.Business_Phone__c=userVar.Phone;
            accountVar.First_Name__c = 
            lstVolunteerWrapper[0].volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Name__c+' (Notification)';
            accountVar.Business_Email__c=lstVolunteerWrapper[0].volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c;
            lstSelectedAccount.add(accountVar);
        }
        Integer iRecpNo=1;
        for(Account oAccountVar: lstSelectedAccount){
            oAccountVar.Recognitions_and_Accomplishments__c = 
            String.valueOf(lstSelectedAccount.size());
            oAccountVar.Country_Of_Origin__c=String.valueOf(iRecpNo);
            iRecpNo++;
        }
        // Check for identifying if no volunteer has been selected for sending 
        //the email.
        if(iNoOfSelectedVolunteer==0){
            ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.ERROR,System.label.MissingVolunteer);
            //Please select at least one volunteer to proceed
            ApexPages.addMessage(myMsg);
             bIsContionueBatch=false;
            iTotalSize=0;
            return;
        }
       boolean bStatus= SendEmailUsingXMPie.sendEmail(lstSelectedAccount); 
         if(!bStatus){
       
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
            System.Label.ErrorOccoredInEmailSending); 
       bIsContionueBatch=false;
            iTotalSize=0;
            ApexPages.addMessage(myMsg);

       }
        //Sending Email using ESB 
    }
    public void hideSearchResult(){
        if(bIsHidden==true)
        bIsHidden=false;
        else
        bIsHidden=true;
    }
    /**
    * Wrapper Class name  : VolunteerWrapper
    * Description  :This wrapper class is used for keeping the volunteer slots 
    *               details along with the User's selection for sending mail. 
    * Return Type  : void
    * Parameter    : void
    **/   
    public class VolunteerWrapper{
        public Volunteer_Slot__c volunteerSlot{get;set;}
        public boolean bIsSelected{get;set;}
        public VolunteerWrapper(Volunteer_Slot__c volunteer,
        boolean isSelected){
            volunteerSlot=volunteer;
            bIsSelected=isSelected;
        }
    }
    /**
    * Wrapper Class name  : CampaignWrapper
    * Description  :This class is for keeping in all campaign details and some 
    *               other information like dates and selection made by the user
    * 
    * 
    **/   
    public class CampaignWrapper{
        public Campaign campaign{get;set;}
        public boolean bIsSelected{get;set;}
        public Date dtStartDate{get;set;}
        public Date dtEndDate{get;set;}
        public CampaignWrapper(Campaign camp,boolean isSelected){
            campaign=camp;
            bIsSelected=isSelected;
        }
    }
    /**
    * Method name  : removeDuplicateAccount
    * Description  : Use this method to remove duplicate account if added to 
    *                volunteer lst twice.
    * Return Type  : List<AccountWrapper>
    * Parameter    : List<AccountWrapper>
    **/  
    private List<VolunteerWrapper> removeDuplicateAccount(List<VolunteerWrapper> 
    lstVolunteerWrapper){
        Map<Id,VolunteerWrapper> mapVolunteerWrapper = 
        new Map<Id,VolunteerWrapper>();
        for(VolunteerWrapper volunteerWrapperVar: lstVolunteerWrapper)
        mapVolunteerWrapper.put(volunteerWrapperVar.volunteerSlot.Volunteer__c,
        volunteerWrapperVar);        
        return mapVolunteerWrapper.values();
    }    
}