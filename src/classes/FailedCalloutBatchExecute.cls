global class FailedCalloutBatchExecute implements Database.Batchable<sObject>
{
    global string sQuery;
    //global static final Integer iRecordLimit = Integer.valueOf(System.Label.Maximum_Allowed_Iteration);
    
    public FailedCalloutBatchExecute()
    {
       //Integer iMaxValue = Integer.valueOf(System.Label.Maximum_Allowed_Iteration);
       sQuery = 'select id, Endpoint_URL__c, IsRepeatEnabled__c, Integration_Name__c, Method__c, Number_Of_Iterations__c, JSON__c from Error_Log__c where IsRepeatEnabled__c=true order by LastModifiedDate asc'; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<Error_Log__c> lstErrorLogs)
    {
        Map<Id,Error_Log__c> mapErroLogsToUpdate = new Map<Id,Error_Log__c>();  
        for(Error_Log__c oError : lstErrorLogs)
        {
            if(Error_Log_Repeats__c.getValues(oError.Integration_Name__c) <> null && Error_Log_Repeats__c.getValues(oError.Integration_Name__c).Maximum_Iterations__c > oError.Number_Of_Iterations__c)
            {
                mapErroLogsToUpdate.put(oError.id,oError);
            }
       }
        if(!mapErroLogsToUpdate.isEmpty()) 
        {
        QueueHandler handlerReference = new QueueHandler('Generic', 'Error_Log__c', mapErroLogsToUpdate.keyset());     
        System.enqueueJob(handlerReference);    
        }
           
    }
    
    global void finish(Database.BatchableContext info){
        //This method will be used to perform any action that 
        //needs to be executed once Batch is completed
    }
}