/******************************************************************************
    Name             : TaskSummaryDashboardController
    Description      : This is used as vf controller for page 
                       TaskSummaryDashboard page which summarized all open task
                       for logged in user.         
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                         optimization
****************************************************************************/
public with Sharing class TaskSummaryDashboardController{

    public List<TaskSummary> lstTaskSummary{get;set;}
    public String sUserName{get;set;}
    public boolean bShowTable{get;set;}
    public Id userId{get;set;}
    public String sURL{get;set;}
    public taskSummaryDashboardController(){
    
        lstTaskSummary=new List<TaskSummary>();
        List<Campaign> lstCampaign=new List<Campaign> ();
        List<AggregateResult> lstTaskSummaryReport=new List<AggregateResult>();
        Set<Id> setRelatedRecordId=new Set<Id>();
        Map<Id,Integer> mapDeliverableTaskCount=new Map<Id,Integer>();
        Report oReport=[select Id from Report where DeveloperName 
        =: System.label.OverDueTaskReport];
        sURL='/'+oReport.Id+'?pv0='+sUserName;
        Recordtype recordtype=[select Id from  Recordtype where DeveloperName
        =:System.Label.Recordtype_Campaign and 
        sObjectType = :System.Label.Recordtype_Campaign];
        //Getting Campaign Details
        lstCampaign=[select Id,Name,(select Id from Deliverables__r) from 
        Campaign where Project_Manager__c=:(Userinfo.getUserId()) and 
        recordtypeId=:recordtype.Id];
        for(Campaign oCampaignVar: lstCampaign){
            
            setRelatedRecordId.add(oCampaignVar.Id);
            for(Deliverable__c oDelVar: oCampaignVar.Deliverables__r){
                
                setRelatedRecordId.add(oDelVar.Id);
                
            }
        }
        //Getting all open task which is overdue
        lstTaskSummaryReport=[select count(Id) noOfTask,WhatId recordId from 
        Task where Status!= :System.Label.Completed and createdDate = 
        THIS_FISCAL_YEAR and whatId IN :setRelatedRecordId and
        ActivityDate<=TODAY  group by whatId];
        
        sUserName=UserInfo.getName();
        userId=Userinfo.getUserId();
        String sDeliverableObjectPrefix=(new Deliverable__c()).getsObjectType()
        .getDescribe().getKeyPrefix();//Get Deliverable Object Prefix
        //Filtering Query output for logged in user
        for(AggregateResult aggrVar: lstTaskSummaryReport){
            if(((String)aggrVar.get('recordId'))
            .startsWith(sDeliverableObjectPrefix))
            mapDeliverableTaskCount.put((Id)aggrVar.get('recordId'),
            (Integer)aggrVar.get('noOfTask'));
            
        }
        system.debug('####'+lstTaskSummaryReport);
        //Filtering Query output for logged in user's Campaign Only
        for(AggregateResult aggrVar: lstTaskSummaryReport){
            
            Campaign oCampaignTempVar=new Campaign();
            for(Campaign oCampaignVar:  lstCampaign){
                if(oCampaignVar.Id==(ID)aggrVar.get('recordId')){
                    oCampaignTempVar=oCampaignVar;
                    Integer iTaskCount=0;
                    iTaskCount=(Integer)aggrVar.get('noOfTask');
                    for(Deliverable__c oDelVar:  oCampaignVar.Deliverables__r){
                        iTaskCount+=mapDeliverableTaskCount
                        .get(oDelVar.Id)!=null?mapDeliverableTaskCount
                        .get(oDelVar.Id):0;
                        
                    } 
                    lstTaskSummary.add(new TaskSummary(iTaskCount,
                    oCampaignTempVar)); 
                }
            }
        }
        bShowTable=true;
        
        //Below if works if no Task found
        if(lstTaskSummary.size()==0){
            bShowTable=false;
            
            apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Info,
            System.Label.Task_Summary_Error_Message));            
        }
       showReport(); 
    }

    public pageReference showReport(){

        Report oReport=[select Id from Report where DeveloperName=:
        System.label.OverDueTaskReport];
        sURL='/'+oReport.Id+'?pv0='+sUserName;
        return null;
    }

    //Wrapper class used to Show No of Task pending per campaign
    public class TaskSummary{

        public Integer iNoOfTask{get;set;}  //No Of Overdue Task
        public Campaign oCampaign{get;set;}

        public TaskSummary(Integer iNoOfTask,Campaign oCampaign){

            this.iNoOfTask=iNoOfTask;
            this.oCampaign=oCampaign;
        }
    }

}