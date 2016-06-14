/******************************************************************************
Name             : SBCSchedulerForBatchApexTest
Description      : Test class for FetchBeneficaryISLRESTServices                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=false)
public class SBCSchedulerForBatchApexTest{
    
    public testMethod static void ErrorSchedulerForBatchApex(){  
        List<Batch_Scheduler__c> lstBatchScheduler = new List<Batch_Scheduler__c> () ; 
        Batch_Scheduler__c  oBatchData = new Batch_Scheduler__c () ; 
        oBatchData.Name = 'SBCCommunication' ; 
        oBatchData.Frequency_In_Days__c = 1 ; 
        oBatchData.Threshold_Limit_In_Minutes__c = 100 ; 
        oBatchData.Next_Schedule_Run_Time__c = System.Now() ; 
        oBatchData.Batch_Size__c = 100 ; 
        
        Batch_Scheduler__c  oBatchData1 = new Batch_Scheduler__c () ; 
        oBatchData1.Name = 'XMPieScheduler' ; 
        oBatchData1.Frequency_In_Days__c = 1 ; 
        oBatchData1.Threshold_Limit_In_Minutes__c = 100 ; 
        oBatchData1.Next_Schedule_Run_Time__c = System.Now() ; 
        oBatchData1.Batch_Size__c = 100 ; 
        
        Batch_Scheduler__c  oBatchData2 = new Batch_Scheduler__c () ; 
        oBatchData2.Name = 'Deletion Scenario' ; 
        oBatchData2.Frequency_In_Days__c = 1 ; 
        oBatchData2.Threshold_Limit_In_Minutes__c = 100 ; 
        oBatchData2.Next_Schedule_Run_Time__c = System.Now() ; 
        oBatchData2.Batch_Size__c = 100 ; 
        
        lstBatchScheduler.add( oBatchData ) ;
        lstBatchScheduler.add( oBatchData1 ) ;
        lstBatchScheduler.add( oBatchData2 ) ;
            insert lstBatchScheduler; 
        
        List<Batch_Scheduler__c > batch =[select id,Name, Frequency_In_Days__c,Next_Schedule_Run_Time__c,Threshold_Limit_In_Minutes__c,Batch_Size__c 
                     from Batch_Scheduler__c  limit 100];
                     
        Test.StartTest() ; 
            SBCSchedulerForBatchApex oErroSchedule = new SBCSchedulerForBatchApex () ; 
            SchedulableContext sc ; 
            SBCSchedulerForBatchApex.scheduleRetryCall () ; 
         //   oErroSchedule.execute ( sc ) ;
        Test.StopTest() ; 
    }
    
    public testMethod static void ErrorSchedulerForBatchApex1 (){  
        List<Batch_Scheduler__c> lstBatchScheduler = new List<Batch_Scheduler__c> () ; 
        Batch_Scheduler__c  oBatchData = new Batch_Scheduler__c () ; 
        oBatchData.Name = 'SBCCommunication' ; 
        oBatchData.Frequency_In_Days__c = 1 ; 
        oBatchData.Threshold_Limit_In_Minutes__c = 100 ; 
        oBatchData.Next_Schedule_Run_Time__c = System.Now() ; 
        oBatchData.Batch_Size__c = 100 ; 
        
        Batch_Scheduler__c  oBatchData1 = new Batch_Scheduler__c () ; 
        oBatchData1.Name = 'XMPieScheduler' ; 
        oBatchData1.Frequency_In_Days__c = 1 ; 
        oBatchData1.Threshold_Limit_In_Minutes__c = 100 ; 
        oBatchData1.Next_Schedule_Run_Time__c = System.Now() ; 
        oBatchData1.Batch_Size__c = 100 ; 
        
        Batch_Scheduler__c  oBatchData2 = new Batch_Scheduler__c () ; 
        oBatchData2.Name = 'Deletion Scenario' ; 
        oBatchData2.Frequency_In_Days__c = 1 ; 
        oBatchData2.Threshold_Limit_In_Minutes__c = 100 ; 
        oBatchData2.Next_Schedule_Run_Time__c = System.Now() ; 
        oBatchData2.Batch_Size__c = 100 ; 
        
        lstBatchScheduler.add( oBatchData ) ;
        lstBatchScheduler.add( oBatchData1 ) ;
        lstBatchScheduler.add( oBatchData2 ) ;
            insert lstBatchScheduler; 
        
        List<Batch_Scheduler__c > batch =[select id,Name, Frequency_In_Days__c,Next_Schedule_Run_Time__c,Threshold_Limit_In_Minutes__c,Batch_Size__c 
                     from Batch_Scheduler__c limit 100  ];
                     
        Test.StartTest() ; 
            SBCSchedulerForBatchApex oErroSchedule = new SBCSchedulerForBatchApex () ; 
            SchedulableContext sc ;  
            oErroSchedule.execute ( sc ) ;
        Test.StopTest() ; 
    }
    
    
}