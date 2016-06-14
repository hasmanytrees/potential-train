/*******************************************************************************
    Name             : SurveySummaryByIndividualController
    Description      : This is used a vf controller for page 
                    SurveySummaryByIndividual which shows summary of survey
                    analysis by each participant                  
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                        optimization
*******************************************************************************/
public with Sharing class SurveyAnalysisDashBoardController{
    public List<PieWedgeData> lstPieWedgeData{get;set;}
    public Campaign oCampaign{get;set;}
    public boolean bShow{get;set;} //Boolean Variable to control visibility of 
    //Answer analysis section based on whether any answer received for that Survey
    public Integer iNoOfPersonResponded{get;set;}
    //Integer to denote no of Survey Taker Record
    public Integer iNoOfPersonSent{get;set;}
    //Integer to denote no of Recipient Record
    public SurveyAnalysisDashBoardController(){
        lstPieWedgeData=new List<PieWedgeData>();
        bShow=true;
        String sEventLocationId=ApexPages.currentPage().getParameters().get
        ('eventLocationId');
       
        oCampaign=[select Name,Id,(select Id from Surveys__r) from Campaign 
        where Id=:sEventLocationId order by CreatedDate desc];
        String sSurveyId;
        try{
            sSurveyId=oCampaign.Surveys__r.get(0).Id;
           
        }
        catch(Exception ex){
            bShow=false;
            ApexPages.addMessage(new 
            ApexPages.Message(ApexPages.Severity.INFO,System.Label.NoSurveyFound));
            //Survey has not set up for this event location yet.
            return ;
        }
        
        iNoOfPersonResponded=0;
        iNoOfPersonSent=0;
        iNoOfPersonResponded=[select Count() from SurveyTaker__c where 
        Event_Location__c =: sEventLocationId];
        iNoOfPersonSent =[select Count() from Recipient__c where 
        Campaign__c =: sEventLocationId];
        //Querying to get All Question and related Answer given to me for any 
        //Particular Survey
        List<Survey_Question__c> lstSurveyQuestion=[select (Select Id,
        Response__c from Survey_Question_Answers__r),Id,Survey__c,Question__c,
        OrderNumber__c,Choices__c from Survey_Question__c where 
        Survey__c=:sSurveyId and Type__c!='Free Text' order by OrderNumber__c ];
        if(lstSurveyQuestion.size()==0){
            bShow=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
            System.Label.NoQuestionFound));
            //No related Question(s) found for this survey.Please contact System
            //Administrator.
            return;
        }
        for(Survey_Question__c oQuestionVar:   lstSurveyQuestion){
            MAp<String,Integer> mapResponseCount=new  MAp<String,Integer>();
            List<String> lstOption=oQuestionVar.Choices__c.split('\n');
          
            for(String sOptionVar: lstOption)
            mapResponseCount.put(sOptionVar.trim(),0);
            
            for(SurveyQuestionResponse__c oAnswerVar: 
            oQuestionVar.Survey_Question_Answers__r){
                Integer iNoOfResponsesOnQuestion=0;
                if(oAnswerVar.Response__c!=null){
                    //forming map to denote No of Person answered per Question
                    
                    iNoOfResponsesOnQuestion=mapResponseCount.get
                    (oAnswerVar.Response__c.trim());
                    iNoOfResponsesOnQuestion++;
                    mapResponseCount.put(oAnswerVar.Response__c,
                    iNoOfResponsesOnQuestion);
                    
                }
            }
            List<PieWedgeChartData> lstChartData=new List<PieWedgeChartData>();
            for(String oAnswerVar: mapResponseCount.keySet()){
                lstChartData.add(new PieWedgeChartData(oAnswerVar,
                mapResponseCount.get(oAnswerVar)));
            }
            //Forming Wrapper to display data on vf page as dashboard
            lstPieWedgeData.add(new PieWedgeData(oQuestionVar.Question__c,
            lstChartData,oQuestionVar.Question__c,
            (Integer)oQuestionVar.OrderNumber__c));
            if(lstPieWedgeData.size()==0){                
                bShow=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                System.Label.NoResponseFound));
                //No one has yet responded to this survey.Please try after some time.!!
            }            
        }
    }
    // Wrapper class
    public class PieWedgeData {
        public String sName { get; set; }
        public List<PieWedgeChartData> lstData { get; set; } 
        // It denotes Complete Answer and no of response per question
        public String sQuestion{get;set;}  //Variable to denote QuestionName
        public Integer iOrder{get;set;}
        public PieWedgeData(String sName, List<PieWedgeChartData > lstData,
        String sQuestion,Integer iOrder) {
            this.sName = sName;
            this.lstData = lstData;
            this.sQuestion=sQuestion;
            this.iOrder=iOrder;
        }
    }
    // Wrapper class used to display lstData in dashboard for each Answer
    public class PieWedgeChartData {
        public String sNameVal { get; set; }  //Answer Name is set to this variable
        public Integer iDataVal { get; set; } //Variable to Store no of Responses
        public PieWedgeChartData (String sName, Integer iData) {
            this.sNameVal = sName;
            this.iDataVal = iData;
        }
    }
}