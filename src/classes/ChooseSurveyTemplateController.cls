/******************************************************************************
    Name             : ChooseSurveyTemplateController
    Description      : It is used as controller for ChooseSurveyTemplate vf page       
    Modification Log : 
---------------------------------------------------------------------------
Developer           Date              Description
---------------------------------------------------------------------------
Subhojit            30/10/2014        Created
Subhojit            29/01/2015        Modified for code re-factoring & 
                                      optimization
****************************************************************************/
public with Sharing class ChooseSurveyTemplateController{

    public List<Survey__c> lstSurvey{get;set;}
    public List<SelectOption> lstSurveyOption{get;set;}
    public String sSelectedSurvey{get;set;}
    public String sSelectedSurveyName{get;set;}
    public String sEventLocationId{get;set;}
    public boolean bIsDisplayed{get;set;}

    public survey__c oSurveyVar{get;set;}
    public  ChooseSurveyTemplateController(){

        lstSurvey=new List<Survey__c> ();
        oSurveyVar=new Survey__c();
        lstSurveyOption=new List<SelectOption>();
        sEventLocationId=Id.valueOf(ApexPages.currentPage().getParameters()
        .get('elocationId').subStringBefore('?parent_domain'));
        //Getting event location 
        RecordType recordtype=[select Id from RecordType where 
        DeveloperName='Survey_Templete' and sObjectType='Survey__c'];  
        // Retrieving sample Survey template
        lstSurvey=[select Id,Name from Survey__c where 
        recordTypeId=:recordtype.Id and URL__c!='Undefined' limit 1];
        bIsDisplayed=true;
        
        for(Survey__c oSurveyVar: lstSurvey)
        lstSurveyOption.add(new SelectOption(oSurveyVar.Id,oSurveyVar.Name));
        if(lstSurveyOption.size()>0){
            
            sSelectedSurvey=lstSurveyOption[0].getValue();
            sSelectedSurveyName=lstSurveyOption[0].getLabel();
            
        }
        else{
            
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,
            System.Label.NOServeyTemplateFound )); //'No Survey Template found.'
            bIsDisplayed=false;
        }
    }
    /**
    * Method name  : createSurvey
    * Description  : This method is used to create Survey header and Related 
                     Survey Question from Template.
    * Return Type  : PageReference
    * Parameter    : void
    **/ 
    public pageReference createSurvey(){

        if(sSelectedSurvey==null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
            System.Label.SelectATemplate));//Please select a survey Template
            return null;
        }
        
        
        try{ 
            Campaign event=[select Id,Event__r.EndDate from Campaign where 
            Id=:sEventLocationId limit 1];
            if(event.Event__r.EndDate==null){
                
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
            System.Label.EventMissingEndDate));
            //Event End Date is missing.Please specify Event End Date.
                return null;
                
            }
            if(event.Event__r.EndDate.addDays(30)<Date.today()){
                
                
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            System.Label.SurveyEndDateLessThanToday));
            //Survey End Date Can not be less than Today.Please check.
             return null;
                
                
            }
           oSurveyVar.Last_Date_of_Survey__c=event.Event__r.EndDate.addDays(30);
            oSurveyVar.MultipleAllowed__c =false;
            Id eLocIdVar=CloneSurveyHelper.cloneSurveyTemplate
            (Id.valueOf(sSelectedSurvey),Id.valueOf(sEventLocationId),
            oSurveyVar.Last_Date_of_Survey__c,oSurveyVar.MultipleAllowed__c);
            //Cloning Survey header and Survey Questions
            CloneSurveyHelper.addReceipients(eLocIdVar,
            Id.valueOf(sEventLocationId));
//Adding Participant to Survey.Participant will be copied from Volunteer Slot.
            
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
            System.Label.SurveySuccess ));//Survey created
        }
        catch(Exception ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,
            System.Label.ErrorOccoredInCreate+ex.getMessage()));
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'
            +ex.getStackTraceString(),'Survey__c',sEventLocationId,
            'ChooseSurveyTemplateController','createSurvey','Application',
            UserInfo.getUserId(), null,null);
        }
        return null;
    }

}