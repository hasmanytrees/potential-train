public with Sharing class EVETThankYouEmailController{                                                 
    /***************************************************************************
    Name             : EVETThankYouEmailController
    Description      : Class used to handle Special Email Message Sending to 
                        various Advocates and Volunteers.                                  
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Subhojit                30/10/2014            Created
    Subhojit                29/01/2015            Modified for code re-factoring 
                                                & optimization
    Apurva                  1/9/2015            Changes to prevent duplicate thank you emails
    **************************************************************************/   
    public Campaign campaignOwner{get;set;}
    public boolean bSuccess{get;set;}
    public boolean bIsSystemAdmin{get;set;}
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
    user uservar;
    public boolean bIsHidden{get;set;}
    Public String sNoOfChild{get;set;}
    public String sSpecialNote{get;set;}
    public boolean bIsNoRecord{get;set;}
    List<VolunteerWrapper> lstSelectedVolunteerWrapper{get;set;}
    public boolean  bIsContionueBatch{get;set;}
   
    List<VolunteerWrapper> lstVolunteerWrapperTemp{get;set;}
    Static Final Integer BATCH_CHUNK_LIMIT=Integer.valueOf(System.Label.EVETBatchLimit);
    List<Volunteer_Slot__c> lstrelatedVolunteerSlot {get;set;}
   
    public Integer iTotalSize{get;set;}
    public Integer iTotalEmailCount{get;set;}
    public boolean isLastBatch{get;set;}
    /**
    * Method name  : Constructor
    * Description  :This method is initiate constructor related methods and 
    class
    *               variable values assignment.
    *                
    * Return Type  : void
    * Parameter    : void
    **/   
    public EVETThankYouEmailController(){
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
            new SelectOption('10','10'),
            new SelectOption('20','20')};
        sSelectedDistance='5';
        bShowAdvocates=false;
        bShowSecondPage=false;
        mapEvent=new Map<Id,Campaign>();
        init();
    }
    /**
    * Method name  : init
    * Description  :This method is initiate certain conditions for execution 
    *               initially
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    public void init(){
        bSuccess=false;
        lstAllActiveCampaign=new List<Campaign>();
        Recordtype recordtype=[select Id from Recordtype where 
        sObjectType='Campaign' and DeveloperName='Event_Location'];
        //SOQL to retrieve all record informations related to the event location
        //in concern
        lstAllActiveCampaign=[select Address_1__c,Address_2__c,Address_3__c,
        Campaign__c,Event__r.Name,Id,VEN_Name__c,Venue__C,Name,OwnerId,City__c,
        State__c,ZIP_Code__c,Country__c,Volunteer_Coordinator__c,
        Volunteer_Coordinator__r.Name,Volunteer_Coordinator__r.FirstName,
        Published_Location_Name__c,Published_Volunteer_Coordinator_Email__c,
        Published_Volunteer_Coordinator_Name__c,EVE_Start_Time__c,
        EVE_End_Time__c,Volunteer_Coordinator__r.LastName,
        Volunteer_Coordinator__r.Email,Volunteer_Coordinator__r.Phone,Status,
        StartDate,EndDate,(select Id,Start_Time__c,
        End_Time__c from Volunteer_Shift__r)
        from Campaign where Publish_To_Web__c=true and 
        recordtypeId=:recordtype.Id and 
        (status='Completed' OR Status='Confirmed') and 
        EndDate=LAST_N_DAYS:30 and 
        Published_Volunteer_Coordinator_Name__c
        =:campaignOwner.Published_Volunteer_Coordinator_Name__c];
        List<Volunteer_Slot__c> lstVolunteerSlot=new List<Volunteer_Slot__c> ();
        Set<Id> setCampaignId=new Set<Id>();
        for(Campaign oCampaignVar: lstAllActiveCampaign)
        setCampaignId.add(oCampaignVar.Id);
        try{
            userVar=[select Id,Email,Phone,FirstName,LastName,Name from User where 
            Name=:campaignOwner.Published_Volunteer_Coordinator_Name__c];
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(
            ApexPages.Severity.ERROR,System.label.InvalidVolunteerCoordinator);
            //Please enter a ZIP Code
            ApexPages.addMessage(myMsg);
            
        }
        //Get all volunteer Slots from retrieved Event Location
        lstVolunteerSlot=[select Id,Volunteer__c,
        Volunteer__r.Preferred_Email_Address__c,Volunteer__r.First_Name__c,
        Volunteer__r.Account_Full_Name__c,Volunteer__r.Business_Phone__c,
        Volunteer__r.Name,Volunteer__r.Business_Email__c,
        Volunteer__r.Work_Email__c,Volunteer__r.Personal_Email__c,
        Volunteer_Shift__r.EventLocation__c,Status__c,
        Start_Time__c,End_Time__c,Volunteer__r.Home_Phone__c,
        Volunteer__r.Do_Not_Contact__c,Volunteer__r.Do_Not_Email__c,Comments__c,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.Email,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.FirstName,
        Volunteer_Email_Update__c,
        Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c,
        Volunteer_Shift__r.EventLocation__r.Published_Location_Name__c,
        Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Name__c,
        Volunteer_Role__c,Volunteer_Shift__r.EventLocation__r.Partner_Website__c,
        Volunteer_Shift__r.EventLocation__r.Venue__r.Name,
        Volunteer_Shift__r.EventLocation__r.Venue__r.Address__c,Date__c,
        /*Volunteer__r.Business_Phone__c/Migration purpose,*/
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.LastName,
        Volunteer_Shift__r.EventLocation__r.Name,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.Phone,
        Volunteer_Shift__r.EventLocation__r.Volunteer_Coordinator__r.Name  
        from Volunteer_Slot__c  where Volunteer_Shift__r.EventLocation__c 
        IN :setCampaignId and Volunteer__c!=null 
        and Volunteer_Email_Update__c!=null];
        mapEventVSlot=new Map<Id,List<Volunteer_Slot__c>>();
        //Variable to Show error message if no Campaign found
        if(lstAllActiveCampaign.size()==0)
        bIsNoRecord=true;
        else
        bIsNoRecord=false;
        bShowVolunteer=false;
        Map<Id,Volunteer_Slot__c > mapVounteerId=
        new Map<Id,Volunteer_Slot__c >();
        for(Volunteer_Slot__c oVSlotVar: lstVolunteerSlot){
            mapVounteerId.put(oVSlotVar.Volunteer__c,oVSlotVar);
        }
        
        for(Campaign oEventVar: lstAllActiveCampaign){
            mapEvent.put(oEventVar.Id,oEventVar);
            List<Volunteer_Slot__c> lstVolunteerSlotVar=
            new List<Volunteer_Slot__c>();
            for(Volunteer_Slot__C oVolunteerSlotVar: lstVolunteerSlot){
                if(oVolunteerSlotVar.Volunteer_Shift__r.EventLocation__c==oEventVar.Id)
                lstVolunteerSlotVar.add(oVolunteerSlotVar);                
            }
            mapEventVSlot.put(oEventVar.Id,lstVolunteerSlotVar);  
            // Creating eventLocation and related volunteer Slot
        }
        bIsHidden=false;
        sNoOfChild=System.label.Many;
    }
    /**
    * Method name  : showVolunteers
    * Description  :This method is used to get volunteer retrieved after user 
    *               search.
    *                
    * Return Type  : void
    * Parameter    : void
    **/   
    public void showVolunteers(){
        bShowVolunteer=false;
        lstVolunteerWrapper=new List<VolunteerWrapper>();
        for(Volunteer_Slot__c oVolunteerVar: mapEventVSlot.get(sEventId)){
            if((oVolunteerVar.Status__c!=null)&&
                        ((oVolunteerVar.Status__c.equalsIgnoreCase(System.label.Completed))
                            ||(oVolunteerVar.Status__c.equalsIgnoreCase
                                (System.label.VolunteerSlotStatus_Approved)))){
                lstVolunteerWrapper.add(new volunteerWrapper(oVolunteerVar,true));      
            } 
        }
        if(lstVolunteerWrapper.size()==0){
            ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.NoCompletedVolunteerFound); 
            //No Completed Volunteer(s) found for this event.
            ApexPages.addMessage(myMsg);
            return;
        }
        iNoOfVolunteer=lstVolunteerWrapper.size();
        bShowVolunteer=true;
    }
    
    
     public void getEmailBatch(){
       
         bIsContionueBatch=true;
         isLastBatch=false;
        List<VolunteerWrapper> lstVolunteerSelected=new   List<VolunteerWrapper> ();
//Apurva - Changes made to prevent duplicate thank you emails        
        
        Set<Id> setVolunteerSelected= new Set<Id>();
        for(Integer iIndex=0;iIndex<lstVolunteerWrapper.size();iIndex++ ){
          if(lstVolunteerWrapper[iIndex].bIsSelected){
            if(!setVolunteerSelected.contains(lstVolunteerWrapper[iIndex].volunteerSlot.Volunteer__c)){
                lstVolunteerSelected.add(lstVolunteerWrapper[iIndex]);
                setVolunteerSelected.add(lstVolunteerWrapper[iIndex].volunteerSlot.Volunteer__c);
            }
            }
        }
         iTotalEmailCount=lstVolunteerSelected.size();
        lstVolunteerWrapperTemp=new List<VolunteerWrapper > ();
       
        lstSelectedVolunteerWrapper=new List<VolunteerWrapper >();
       
        Integer iBatchSize=0;
        for(Integer iIndex=iTotalSize;iIndex<lstVolunteerSelected.size();iIndex++ ){
        
           
           if((iBatchSize<BATCH_CHUNK_LIMIT)&&(iTotalSize<=lstVolunteerSelected.size())){
           
           
             if(lstVolunteerSelected[iIndex]!=null){
                 if(iTotalEmailCount-iTotalSize<=BATCH_CHUNK_LIMIT)
                   isLastBatch=true;
                  
                 lstVolunteerWrapperTemp.add(lstVolunteerSelected[iIndex]);
             
              iTotalSize++;
              iBatchSize++;
             }
          }
          else
          break;
        
        
        
        }
   if(lstVolunteerSelected.size()==0){
    
     ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.SelectOneVolunteer);
            //Please select at least one volunteer to proceed
            ApexPages.addMessage(myMsg);
              bIsContionueBatch=false;
            iTotalSize=0;
            return;
    
    }
   if(( lstVolunteerWrapperTemp.size()>0)&&(iTotalSize<=lstVolunteerSelected.size()))
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
        Integer iNoOfSelectedVolunteer=0;
        lstSelectedVolunteerWrapper=new List<VolunteerWrapper >();
        List<Account> lstSelectedAccount=new List<Account>();
        String sShiftRule=null; 
        for(VolunteerWrapper volunteerVar: lstVolunteerWrapperTemp) {
            if(volunteerVar.bIsSelected==true){
                lstSelectedVolunteerWrapper.add(volunteerVar);
                iNoOfSelectedVolunteer++;
                Account oAccountVar=new Account();
                
                String sLocationText='';
                sLocationText=volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Location_Name__c;
                //Adding Volunteer Co ordinator as default recipient
                oAccountVar.Compassion_Background__c=
                (sNoOfChild!='')?sNoOfChild:null;
                oAccountVar.Hobbies__c=(sLocationText!='')?sLocationText:null;
                oAccountVar.Occupation_Details__c = 
                volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c;
                oAccountVar.Segment_Type__c=userVar.FirstName;
                oAccountVar.VEN_Service__c=userVar.LastName;
                oAccountVar.Social_Profile_s__c=sShiftRule;
                oAccountVar.Business_Type__c=
                volunteerVar.volunteerSlot.Volunteer_Shift__r.EventLocation__c;
                oAccountVar.Research_Comments__c=
                volunteerVar.volunteerSlot.Volunteer__c;
                oAccountVar.T_Shirt_Size__c=
                volunteerVar.volunteerSlot.Volunteer__c.getSObjectType().
                getDescribe().getName();
                oAccountVar.Mailing_State_Province__c=
                EVET_Template_Id__c.getAll
                ().get(system.label.EVETThankYouEmail).Template_ID__c;
                oAccountVar.Business_Email__c = 
                volunteerVar.volunteerSlot.Volunteer_Email_Update__c;
                oAccountVar.Id=volunteerVar.VolunteerSlot.Volunteer__c;
                oAccountVar.First_Name__c
                =(volunteerVar.VolunteerSlot.Volunteer__r.First_Name__c!=null)?
                volunteerVar.VolunteerSlot.Volunteer__r.First_Name__c:
                volunteerVar.VolunteerSlot.Volunteer__r.Account_Full_Name__c;
                oAccountVar.Business_Phone__c=userVar.Phone;
                lstSelectedAccount.add(oAccountVar);
            }
        }
        if((lstSelectedAccount.size()>0)&&(isLastBatch)){ 
            Account oAccountVar=new Account();
            oAccountVar.Compassion_Background__c=(sNoOfChild!='')?sNoOfChild:null;
            oAccountVar.Hobbies__c=lstSelectedAccount[0].Hobbies__c;
            oAccountVar.Occupation_Details__c=
            lstVolunteerWrapper[0].volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c;
            oAccountVar.Segment_Type__c=userVar.FirstName;
            oAccountVar.VEN_Service__c=userVar.LastName;
            oAccountVar.Social_Profile_s__c=sShiftRule;
            oAccountVar.Business_Type__c = 
            lstVolunteerWrapper[0].volunteerSlot.Volunteer_Shift__r.EventLocation__c;
            oAccountVar.Research_Comments__c=uservar.Id;
            oAccountVar.T_Shirt_Size__c=userVar.Id.getSObjectType().getDescribe().getName(); 
            oAccountVar.Mailing_State_Province__c = 
            EVET_Template_Id__c.getAll().get
            (system.label.EVETThankYouEmail).Template_ID__c;
            oAccountVar.Id=null;
            oAccountVar.Business_Phone__c = uservar.Phone;
            oAccountVar.First_Name__c = 
            lstVolunteerWrapper[0].volunteerSlot.volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Name__c +' (Notification)';
            oAccountVar.Business_Email__c = 
            lstVolunteerWrapper[0].volunteerSlot.Volunteer_Shift__r.EventLocation__r.Published_Volunteer_Coordinator_Email__c;
            lstSelectedAccount.add(oAccountVar); 
        } 
         
        if(iNoOfSelectedVolunteer==0){
            ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.SelectOneVolunteer);
            //Please select at least one volunteer to proceed
            ApexPages.addMessage(myMsg);
              bIsContionueBatch=false;
            iTotalSize=0;
            return;
        }
        if(sNoOfChild==null){
            ApexPages.Message myMsg =
            new ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.MissingChildNo); 
            //Please specify number of child.If the number is 
            //unknown or equals 1,leave "many" in the field.
            ApexPages.addMessage(myMsg);
              bIsContionueBatch=false;
            iTotalSize=0;
            return;
        }
        
//Apurva- Changes made to avoid sending multiple Thank you emails-Start
/*        if(oVCAccount != null){
            lstSelectedAccount.add(oVCAccount);   
        }
*/
        Integer iRecpNo=1; 
       
        for(Account oAccountVar: lstSelectedAccount){
            oAccountVar.Recognitions_and_Accomplishments__c = 
            String.valueOf(lstSelectedAccount.size());
            oAccountVar.Country_Of_Origin__c = String.valueOf(iRecpNo);
            iRecpNo++;
            }
        boolean bStatus=SendEmailUsingXMPie.sendEmail(lstSelectedAccount);
//Apurva- Changes made to avoid sending multiple Thank you emails-End
        if(!bStatus){
       
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
            System.Label.ErrorOccoredInEmailSending); 
            ApexPages.addMessage(myMsg);
       bIsContionueBatch=false;
            iTotalSize=0;

       }
        //bSuccess=true;        
    }
    public void hideSearchResult(){
        if(bIsHidden==true)
        bIsHidden=false;
        else
        bIsHidden=true;    
    }
    /**
    * Class name  : VolunteerWrapper
    * Description  :This wrapper class is used to hold account related 
    *               information and their selection by user
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public class VolunteerWrapper{
        public Volunteer_Slot__c volunteerSlot{get;set;}
        public boolean bIsSelected{get;set;}
        public VolunteerWrapper(Volunteer_Slot__c volunteer,boolean isSelected){
            volunteerSlot=volunteer;
            bIsSelected=isSelected;
        }
    }
    /**
    * Class name  : CampaignWrapper
    * Description  :This wrapper class is used to hold campaign related 
    *               information and their selection by user
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public class CampaignWrapper{
        public Campaign campaign{get;set;}  //Basic campaign record holder
        public boolean bIsSelected{get;set;}  // It is used to show check box
        public Date dtStartDate{get;set;}       //Start date  of Campaign
        public Date dtEndDate{get;set;}         // end date of Campaign
        public CampaignWrapper(Campaign camp,boolean isSelected){
            campaign=camp;
            bIsSelected=isSelected;
        }
    }    
}