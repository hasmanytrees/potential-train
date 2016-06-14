@isTest(seeAllData=false)
private class OpportunitySummaryDashboardControl_Test
{   
    public static testMethod void testOpportunitySummaryDashboardController() {
    
    List<Opportunity> testOpportunitySummary=new List<Opportunity>();     

    for(Integer i=0;i<3;i++){
    Opportunity opp=new Opportunity(Name='Opportunity' + i,Type='Contribute',StageName='Qualified',Actual_Revenue__c = i++, CloseDate=date.parse('2/13/2015'));
    testOpportunitySummary.add(opp);
    }
    
    Opportunity opp=new Opportunity(Name='Opportunity6',Type='Contribute',StageName='Qualified',Actual_Revenue__c = 60, CloseDate=date.parse('2/13/2015'));
    testOpportunitySummary.add(opp);
    
    insert testOpportunitySummary; 
    system.assertEquals('Qualified',opp.StageName);
    system.assertEquals('Contribute',opp.Type);
    
    OpportunitySummaryDashboardController oppsummary=new OpportunitySummaryDashboardController();                  
    }
    
    public static testMethod void testOpportunitySummaryDashboardWithOpportunity() {
      OpportunitySummaryDashboardController oppsummary=new OpportunitySummaryDashboardController();
    
    }
    
}