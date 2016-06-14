/*******************************************************************************
    Name             : OpportunitySummaryDashboardController
    Description      : This class is vf controller for 
                       OpportunitySummaryDashboard which shows no of Opportunity
                       per stage               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014       Created
Subhojit                29/01/2015       Modified for code re-factoring & 
                                         optimization
*******************************************************************************/
public with Sharing class OpportunitySummaryDashboardController{

    Public List <OpportunityWrapper> lstOppWrapper{get;set;}
    public boolean bShowTable{get;set;}
    public OpportunitySummaryDashboardController(){
        lstOppWrapper=new List <OpportunityWrapper>();
        List<AggregateResult> lstOpportunitySummary=new List<AggregateResult>();
        lstOpportunitySummary=[select StageName,count(Id) noOfOpportunity,
        SUM(Actual_Revenue__c) TotalRevenue from Opportunity 
        where CreatedDate=THIS_FISCAL_YEAR group by StageName];
        //Getting Opportunity and Total no of record grouped by Stage
        
        for(AggregateResult oAggrVar: lstOpportunitySummary){
            lstOppWrapper.add(new OpportunityWrapper((Integer)oAggrVar.get
            ('noOfOpportunity'),(String)oAggrVar.get('StageName'),
            (Double.valueOf(oAggrVar.get('TotalRevenue'))!=null)?Double.valueOf
            (oAggrVar.get('TotalRevenue')):0.0));
        }
        //Below block and boolean variable handles visibility of table in 
        //absence of any open opportunity.    
        if(lstOpportunitySummary.size()==0)
        bShowTable=false;
        else
        bShowTable=true;
    }
    //Wrapper Class for Opportunity and its Count per stage
    public class OpportunityWrapper{

        Public Double dbTotalSum{get;set;}
        public String sGroupName{get;set;}
        public Integer iRecordCount{get;set;}

        Public OpportunityWrapper(Integer iRecordCount,String sGroupName,
        Double dbTotalSum){
            this.dbTotalSum=dbTotalSum;
            this.sGroupName=sGroupName;
            this.iRecordCount=iRecordCount;

        }
    }
}