/******************************************************************************
    Name             : SurveySummaryByIndividualController
    Description      : This is used a vf controller for page 
                      SurveySummaryByIndividual which shows summary of survey 
                      analysis by each participant.                 
    Modification Log : 
---------------------------------------------------------------------------
Developer          Date              Description
---------------------------------------------------------------------------
Subhojit           30/10/2014        Created
Subhojit           29/01/2015        Modified for code re-factoring & optimization
******************************************************************************/
Public with Sharing class SurveySummaryByIndividualController{
    public SurveyTaker__c  oSurveyTakerVar{get;set;}
    Public String sVolunteerName{get;set;}
    public String sVolunteerId{get;set;}
    public String sEventLocName{get;set;}
    public String sEventLocId{get;set;}
    public String sSurveyEmail{get;set;}
    public Map<String,List<String>> mapQuestionRelatedAnswer{get;set;} 
    //Map to store Question and related Answer
   public Map<String,Map<String,boolean>> mapQuestionRelatedUserAnswer{get;set;}  
    //Map to Store Question and Answer given by individualAnswer
    public Map<String,String> mapQuestionType{get;set;}   
    // Map to Store Question and Type of Question
    public Map<String,String> mapFreeTextFieldAnswer{get;set;}
    public Map<Integer,String> mapQuestionOrder{get;set;}   
    //Map to store related or of each Question
    public SurveySummaryByIndividualController(ApexPages.StandardController 
    controller) {
        mapQuestionRelatedAnswer=new Map<String,List<String>>();
        mapQuestionRelatedUserAnswer=new Map<String,Map<String,boolean>>();
        mapQuestionType=new Map<String,String>();
        mapFreeTextFieldAnswer=new Map<String,String>();
        mapQuestionOrder=new Map<Integer,String>();
        oSurveyTakerVar=new SurveyTaker__c  ();
        String sSurveyTakerId=controller.getId();
       //Querying Survey Details for Particular Person based on his Recipient Id
        oSurveyTakerVar=[select Id,Event_Location__r.Name,Event_Location__c,
        Recipient__r.Id,Recipient__r.Campaign__c,Recipient__r.Campaign__r.Name,
        Recipient__r.Collected__c,Recipient__r.DateSendInvitation__c,
        Recipient__r.EmailAddress__c, Recipient__r.InvitationSent__c,
        Recipient__r.isAnonymous__c,Recipient__r.Type__c,
        Recipient__r.RelatedAccount__c,
        Recipient__r.RelatedAccount__r.Account_Full_Name__c,
        Recipient__r.RelatedAccount__r.First_Name__c,
        Recipient__r.RelatedAccount__r.Name,Recipient__r.RelatedAccount__r.Type,
        Recipient__r.Survey__c,Recipient__r.Survey_URL__c from SurveyTaker__c
        where Id =:sSurveyTakerId];
        sVolunteerName = 
        oSurveyTakerVar.Recipient__r.RelatedAccount__r.Account_Full_Name__c;
        sVolunteerId=oSurveyTakerVar.Recipient__r.RelatedAccount__c;
        sEventLocName=oSurveyTakerVar.Event_Location__r.Name;
        sEventLocId=oSurveyTakerVar.Event_Location__c;
        sSurveyEmail=oSurveyTakerVar.Recipient__r.EmailAddress__c;
        //Querying Survey Answer given by any person based on his recipient Id
        List<SurveyQuestionResponse__c> lstSurveyTaken = new 
        List<SurveyQuestionResponse__c  >();
        lstSurveyTaken=[select  Id,Total_Responses__c,Response__c,
        Survey_Answer_Details__c,Survey_Question_Details__c,SurveyTaker__c,
        Survey_Question__r.Type__c,Survey_Question__r.OrderNumber__c
        from SurveyQuestionResponse__c  where SurveyTaker__c=:sSurveyTakerId 
        order by Survey_Question__r.OrderNumber__c desc];
        system.debug('@@@@'+sSurveyTakerId);
        for( SurveyQuestionResponse__c oSurveyQuestionResponseVar: 
        lstSurveyTaken){
     mapQuestionType.put(oSurveyQuestionResponseVar.Survey_Question_Details__c,
            oSurveyQuestionResponseVar.Survey_Question__r.Type__c);
            Map<String,boolean> mapAnswerVar=new Map<String,boolean>();
   if(!oSurveyQuestionResponseVar.Survey_Question__r.Type__c.contains
   ('Free Text')){
            //This block only works for Question with not Free Text type.
            List<String> lstAnswerVar=new List<String>();
            for(String sChoiceVar: 
            oSurveyQuestionResponseVar.Survey_Answer_Details__c.split('\n')){
                lstAnswerVar.add(sChoiceVar.trim());  
                //Forming all possible answer choice for related Question
            }
    mapQuestionOrder.put((Integer)oSurveyQuestionResponseVar.Survey_Question__r
    .OrderNumber__c+1,oSurveyQuestionResponseVar.Survey_Question_Details__c); 
    // Setting Questions and related order they appear in Survey 
    mapQuestionRelatedAnswer.put
    (oSurveyQuestionResponseVar.Survey_Question_Details__c,lstAnswerVar);
    //Finding out which answer was chosen by user among available Answers per 
    //Question.
    for(String sChoiceVar:lstAnswerVar){
        if(oSurveyQuestionResponseVar.Response__c==sChoiceVar){
            //Forming map of Question and related Answer by that Recipient
            mapAnswerVar.put(oSurveyQuestionResponseVar.Response__c,true);
            mapQuestionRelatedUserAnswer.put(oSurveyQuestionResponseVar
            .Survey_Question_Details__c,mapAnswerVar);
        }
                else{
                    mapAnswerVar.put(sChoiceVar,false);
                    mapQuestionRelatedUserAnswer.put
                    (oSurveyQuestionResponseVar.Survey_Question_Details__c,
                    mapAnswerVar);
                    }
                    system.debug('>>>>>>>'+mapQuestionRelatedUserAnswer);
                }
            }
            else{
                //This block only works for Question only of Free Text type.
        mapQuestionOrder.put((Integer)oSurveyQuestionResponseVar
        .Survey_Question__r.OrderNumber__c+1,
        oSurveyQuestionResponseVar.Survey_Question_Details__c);
        mapAnswerVar.put(oSurveyQuestionResponseVar.Response__c,false);
        mapQuestionRelatedUserAnswer.put(oSurveyQuestionResponseVar
        .Survey_Question_Details__c,mapAnswerVar);
        mapFreeTextFieldAnswer.put(oSurveyQuestionResponseVar
        .Survey_Question_Details__c,oSurveyQuestionResponseVar.Response__c);
        mapQuestionRelatedAnswer.put(oSurveyQuestionResponseVar
        .Survey_Question_Details__c,new 
        List<String>{oSurveyQuestionResponseVar.Response__c});
            }
            system.debug(mapQuestionRelatedUserAnswer);
        }
    }
}