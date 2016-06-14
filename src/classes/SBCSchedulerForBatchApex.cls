/******************************************************************************
    Name             : SBCSchedulerForBatchApex 
    Description      : Scheduler class to run the batch job related to SBCCommunication
                       as per Batch Scheduler Configuration                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
*******************************************************************************/

global with sharing class SBCSchedulerForBatchApex implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        Batch_Scheduler__c batch =new  Batch_Scheduler__c();
         batch =[select id,Name, Frequency_In_Days__c,Next_Schedule_Run_Time__c,Threshold_Limit_In_Minutes__c,Batch_Size__c 
                     from Batch_Scheduler__c where Name = 'XMPieScheduler' limit 1];
         //delete batch;
        if((batch.Name == 'Deletion Scenario' && batch.Next_Schedule_Run_Time__c <> null )&&(Math.ABS(((Integer.ValueOf(batch.Next_Schedule_Run_Time__c.getTime())-Integer.ValueOf(System.now().getTime()))/60000))<=(batch.Threshold_Limit_In_Minutes__c )))
        {
            scheduleRetryCall();           
            
        }
        else if((batch.Name == 'SBCCommunication' && batch.Next_Schedule_Run_Time__c <> null )&&(Math.ABS(((Integer.ValueOf(batch.Next_Schedule_Run_Time__c.getTime())-Integer.ValueOf(System.now().getTime()))/60000))<=(batch.Threshold_Limit_In_Minutes__c )))
        {
            Database.executeBatch(new FailedCalloutBatchExecute(), Integer.valueOf(batch.Batch_Size__c));
            //Database.executeBatch(new FailedCalloutBatchExecute(), 200);
            batch.Next_Schedule_Run_Time__c = System.now().addDays(Integer.valueOf(batch.Frequency_In_Days__c));
            try{
                update batch;
            }
            catch(Exception ex){
       
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Batch_Scheduler__c',String.valueOf( batch.ID ),
                'SchedulerForBatchApex','execute','Application',
                UserInfo.getUserId(),String.valueOf(batch),null);
            }
        }
        else if((batch.Name == 'XMPieScheduler' && batch.Next_Schedule_Run_Time__c <> null )&&(Math.ABS(((Integer.ValueOf(batch.Next_Schedule_Run_Time__c.getTime())-Integer.ValueOf(System.now().getTime()))/60000))<=(batch.Threshold_Limit_In_Minutes__c )))
        {
            Database.executeBatch(new SendSBCDirectlyToPrint(), Integer.valueOf(batch.Batch_Size__c));
            //Database.executeBatch(new FailedCalloutBatchExecute(), 200);
            batch.Next_Schedule_Run_Time__c = System.now().addDays(Integer.valueOf(batch.Frequency_In_Days__c));
            try{
                update batch;
            }
            catch(Exception ex){
       
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Batch_Scheduler__c',String.valueOf( batch.ID ),
                'SchedulerForBatchApex','execute','Application',
                UserInfo.getUserId(),String.valueOf(batch),null);
            }
        }
        else
        {
            scheduleRetryCall();
        }
        //System.abortJob(sc.getTriggerId());         
    }
    
    public static void scheduleRetryCall()
    {
        SchedulerMethod();
        //Id BatchId = Database.executeBatch(new FailedCalloutBatchExecute(), 100);           
    } 
    
    public static void SchedulerMethod() 
    {
        Datetime dtSystemTime=System.now();
        dtSystemTime=dtSystemTime.addMinutes(1);
        Integer iHour=dtSystemTime.hour();
        Integer iMinutes=dtSystemTime.Minute();
        Integer iDay=dtSystemTime.Day();
        Integer iMonth=dtSystemTime.Month();
        Integer iYear=dtSystemTime.Year();
        String con_exp= '0 '+' '+iMinutes+' '+iHour+' '+iDay+' '+iMonth+' ? ';
        System.schedule('XMPIE DATA-'+DateTime.now(), con_exp, new SBCSchedulerForBatchApex());        
    }
    
}