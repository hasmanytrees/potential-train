/******************************************************************************
    Name             : ViewSurveyResultsComponentController 
    Description      : 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               1/9/2015        Created
Subhojit               1/27/2015        Modified for code re-factoring & 
                                                       optimization
*******************************************************************************/
public with sharing class ViewSurveyResultsComponentController {

public String surveyId {get;set;}


public String reportId {get;set;}
public PageReference results;

public ViewSurveyResultsComponentController()
{
    ReportFinderUtil rfu = new ReportFinderUtil();
    reportId = rfu.findReportId('Survey with Questions and Responses'); 

}


public pageReference getResults()
{
    surveyId = surveyId.substring(0,15);
    return new PageReference('/' + reportId + '?pv0=' + surveyId);
}

private static testmethod void testResultController()
{
    Survey__c mySurvey = new Survey__c();
    mySurvey.Submit_Response__c = 'empty';  
    insert mySurvey;
    
    viewSurveyResultsComponentController vsr = 
    new viewSurveyResultsComponentController();
    vsr.surveyId = mySurvey.Id;
    
    String mySurveyId = mySurvey.Id;
    PageReference pageRef = new PageReference ('/' + vsr.reportId + '?pv0=' + 
    mySurveyId.substring(0,15));
    System.assertEquals(pageRef.getURL(),vsr.getResults().getURL());
    
}

}