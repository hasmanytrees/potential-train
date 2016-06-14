/****************************************************************************
    Name             : CloneSurveyHelper
    Description      : It is used as helper class for controller for 
                      ChooseSurveyTemplateController.It handles surveyTemplate 
                      cloning functionality       
    Modification Log : 
---------------------------------------------------------------------------
Developer         Date              Description
---------------------------------------------------------------------------
Subhojit          30/10/2014        Created
Subhojit          29/01/2015        Modified for code re-factoring & optimization
*****************************************************************************/
public with Sharing class CloneSurveyHelper{

    /**
    * Method name  : cloneSurveyTemplate
    * Description  : This method is used to create Survey header and Related 
                     Survey Question from Template
    * Return Type  : Id
    * Parameter    : Id,Id,Datetime,boolean
    **/ 
    public static Id cloneSurveyTemplate(Id surveyId,Id eventLocationId,
    Datetime dtSurveyLastDate,boolean bIsMultipleAllowed){

     List<Survey_Question__c > lstSurveyQuestion=new List<Survey_Question__c>();
    Survey__c oSurveyVar=[select Name,Hide_Survey_Name__c,isAvailable__c,
    MultipleAllowed__c,Last_Date_of_Survey__c,Submit_Response__c,
    Survey_Container_CSS__c,Survey_Header__c,thankYouLink__c,Thank_You_Text__c,
    thankYouText__c,URL__c,(select Choices__c,OrderNumber__c,Question__c,
    Required__c,Survey__c,Total_Responses__c,Type__c from SurveyQuestions__r)
    from Survey__c  where Id =:surveyId];
    
    Campaign oEventLoaction=[select Id,Name,Event__r.Name from Campaign where 
    Id=:eventLocationId];

        
        Recordtype recordtype=[select Id from Recordtype where 
        DeveloperName='Survey' and sObjectType='Survey__c']; 
        // Fetching recordtype type info for new Survey
        //Setting Various Field Value for Survey Header
        oSurveyVar.Id=null;
        oSurveyVar.Last_Date_of_Survey__c=dtSurveyLastDate;
        oSurveyVar.MultipleAllowed__c=bIsMultipleAllowed;
        oSurveyVar.recordtypeId=recordtype.Id;
        oSurveyVar.isAvailable__c=true;
        oSurveyVar.EVEL__c=eventLocationId;
        oSurveyVar.Name='Event - '+oEventLoaction.Event__r.Name;
        try
        {
            insert oSurveyVar;
        }
        catch(Exception ex)
        {
            //Creating a new Error Log record whenever any exception is 
            //encountered while performing DML Operation.
      
               Utility.insertErrorLogApplication(ex.getMessage()+'\n'
               +ex.getStackTraceString(),'Volunteer_Slot__c',eventLocationId,
               'CloneSurveyHelper','cloneSurveyTemplate','Application',
               UserInfo.getUserId(), String.valueOf(oSurveyVar),null);
        }
        
        // Cloning Survey Question
      for(Survey_Question__c oSurveyQuestionVar: oSurveyVar.SurveyQuestions__r){
            Survey_Question__c  oSurveyQuestionVar2=oSurveyQuestionVar.clone();
            oSurveyQuestionVar2.Survey__c=oSurveyVar.Id;
            lstSurveyQuestion.add(oSurveyQuestionVar2);
            
        }
        
        if(lstSurveyQuestion.size()>0){
            
            try
            {
                insert  lstSurveyQuestion;
            }
            catch(Exception ex)
            {
                //Creating a new Error Log record whenever any exception is 
                //encountered while performing DML Operation.
               
                String sRelatedRecordIds = '';
                for(Survey_Question__c oSurveyQuestionVar : lstSurveyQuestion)
                {
                    sRelatedRecordIds += oSurveyQuestionVar.id ;
                }
              
             Utility.insertErrorLogApplication(ex.getMessage()+'\n'
             +ex.getStackTraceString(),'Volunteer_Slot__c',sRelatedRecordIds,
             'CloneSurveyHelper','cloneSurveyTemplate','Application',
             UserInfo.getUserId(), String.valueOf(lstSurveyQuestion),null);
            }   
         }
          
        return oSurveyVar.Id;  //Returning newly created Survey Id

    }
    /**
    * Method name  : addReceipients
    * Description  : This method is used to add receipient for Survey based on 
                    Volunteers added in Volunteer Slot of related Event Location.
    * Return Type  : Void
    * Parameter    : Id,Id
    **/ 
    public static void addReceipients(Id surveyId,Id eventLoactionId){

    List<Survey_Question__c > lstSurveyQuestion=new List<Survey_Question__c >();
    Map<Id,Recipient__c> mapVolunteerSlot=new Map<Id,Recipient__c>();
    Campaign oEventLoaction=[select Id,Name from Campaign where 
    Id=:eventLoactionId];
        
    List<Volunteer_Shift__c> lstVolunteerShifts=new List<Volunteer_Shift__c>();
    //Getting Volunteer Shift and related Volunteer Slots with Volunteer Details
    lstVolunteerShifts=[select Id,Name,(select Id,Volunteer__r.Name,
    Volunteer__r.Preferred_Email__c,Volunteer__r.Work_Email__c,
    Volunteer__r.Personal_Email__c,Volunteer__r.Business_Email__c,Status__c 
    from Volunteer_Slots__r) from  Volunteer_Shift__c where 
    EventLocation__c=: eventLoactionId]; 
        
        List<Recipient__c> lstRecipient=new List<Recipient__c>();
       
        for(Volunteer_Shift__c oVolunteerShiftVar: lstVolunteerShifts){
            
    for(Volunteer_Slot__c oVolunteerSlotVar:
    oVolunteerShiftVar.Volunteer_Slots__r){
        if((oVolunteerSlotVar.Status__c!=null)&&
        ((oVolunteerSlotVar.Status__c.equalsIgnoreCase(System.label.Completed))
        ||(oVolunteerSlotVar.Status__c.equalsIgnoreCase
        (System.label.VolunteerSlotStatus_Approved)))){
            //Creating Recipient Record for Volunteer along with Emails.
            Recipient__c oRecipientVar=new Recipient__c ();
            oRecipientVar.InvitationSent__c=true;
            oRecipientVar.isAnonymous__c=true;
            oRecipientVar.Type__c='Account';
            oRecipientVar.Collected__c=false;
           
            oRecipientVar.Survey__c=surveyId;
            oRecipientVar.Campaign__c=eventLoactionId;
            oRecipientVar.RelatedAccount__c=oVolunteerSlotVar.Volunteer__c;
            oRecipientVar.WhoId__c=UserInfo.getUserId();
            oRecipientVar.DateSendInvitation__c=Datetime.now();
              
            //Below block of code fetches preferred Email Type
            if((oVolunteerSlotVar.Volunteer__c!=null)&&
            (oVolunteerSlotVar.Volunteer__r.Preferred_Email__c!=null)&&
            (oVolunteerSlotVar.Volunteer__r.Preferred_Email__c.equalsIgnoreCase
            (System.label.Business))&&
            (oVolunteerSlotVar.Volunteer__r.Business_Email__c !=null)){
            oRecipientVar.EmailAddress__c = 
            oVolunteerSlotVar.Volunteer__r.Business_Email__c;
                        
       mapVolunteerSlot.put(oVolunteerSlotVar.Volunteer__r.Id,oRecipientVar);
                        
                    }
    else if ((oVolunteerSlotVar.Volunteer__c!=null)&&
    (oVolunteerSlotVar.Volunteer__r.Preferred_Email__c!=null)&&
    (oVolunteerSlotVar.Volunteer__r.Preferred_Email__c
    .equalsIgnoreCase(System.label.Personal))&&
    (oVolunteerSlotVar.Volunteer__r.Personal_Email__c!=null)){
oRecipientVar.EmailAddress__c=oVolunteerSlotVar.Volunteer__r.Personal_Email__c;
        
        mapVolunteerSlot.put(oVolunteerSlotVar.Volunteer__r.Id,oRecipientVar);
        
    }
    else if ((oVolunteerSlotVar.Volunteer__c!=null)&&
    (oVolunteerSlotVar.Volunteer__r.Preferred_Email__c!=null)&&
    (oVolunteerSlotVar.Volunteer__r.Preferred_Email__c.equalsIgnoreCase
    (System.label.Work))&&(oVolunteerSlotVar.Volunteer__r.Work_Email__c!=null)){
    oRecipientVar.EmailAddress__c=oVolunteerSlotVar.Volunteer__r.Work_Email__c;
        
        mapVolunteerSlot.put(oVolunteerSlotVar.Volunteer__r.Id,oRecipientVar);
                        
                    }
                    
                }   
                
            }
        }
      
        if(mapVolunteerSlot.size()>0){
            lstRecipient.addAll(mapVolunteerSlot.values());
            try{
                insert lstRecipient;     // inserting recipient List        
            }
            catch(Exception ex){
                
                String sRelatedRecordIds='';
                for(Recipient__c oRepVar: lstRecipient){
                
                  sRelatedRecordIds+=oRepVar.Id+',';
                }
            //Creating a new Error Log record whenever any exception is 
            //encountered while performing DML Operation.
                
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Volunteer_Slot__c',sRelatedRecordIds,
                'CloneSurveyHelper','addReceipients','Application',
                UserInfo.getUserId(), String.valueOf(lstRecipient),null);
            }   
        }  
        
    }

}