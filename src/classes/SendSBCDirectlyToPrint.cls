global class  SendSBCDirectlyToPrint implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    global string sQuery;
   
    public SendSBCDirectlyToPrint()
    {
       //Integer iMaxValue = Integer.valueOf(System.Label.Maximum_Allowed_Iteration);
       sQuery = Utility.retrieveAllFieldsDynamicallyFromObjectForSOQL('SBC_Communications__c');
        
        if(sQuery <> null && sQuery <> '')
        sQuery = sQuery + ' where SBC_Global_Id__c <> null and Batch_Id__c <> null and Sequence_ID__c <> null and Date_Physical_Received__c <> null and Send_For_Print_Using_Batch__c = false';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<SBC_Communications__c> lstSBCRecords)
    {
        List<SBC_Communications__c> lstRecordsSendForPrint = new List<SBC_Communications__c>();  
        Map<String, List<SBC_Communications__c>> mapBatchWiseSBCRecords = new Map<String, List<SBC_Communications__c>>();
        for(SBC_Communications__c oSBCVar : lstSBCRecords)
        {
            
            if(System.Now() >= oSBCVar.LastModifiedDate || Test.IsRunningTest() )
            {
                if(mapBatchWiseSBCRecords.containsKey(oSBCVar.Batch_Id__c))
                {
                    mapBatchWiseSBCRecords.get(oSBCVar.Batch_Id__c).add(oSBCVar);
                }
                
                else
                {
                    lstRecordsSendForPrint = new List<SBC_Communications__c>();
                    lstRecordsSendForPrint.add(oSBCVar);
                    mapBatchWiseSBCRecords.put(oSBCVar.Batch_Id__c, lstRecordsSendForPrint);
                }
            }
       }
       Integer i = 0;
       List<SBC_Communications__c> lstSendSBC = new List<SBC_Communications__c>();
       for(String sBatchId : mapBatchWiseSBCRecords.keyset())
       {
          if(i<=100)
          {
              SendEmailUsingXMPie.sendEmailForSBC(mapBatchWiseSBCRecords.get(sBatchId),true); 
              i++;
              lstSendSBC.addAll(mapBatchWiseSBCRecords.get(sBatchId));
          }         
       }
       if(!lstSendSBC.isEmpty())
        {
            //lstSendSBC.addAll(mapBatchWiseSBCRecords.values());
            for(SBC_Communications__c oSBCVar: lstSendSBC)
            {
                oSBCVar.Send_For_Print_Using_Batch__c = true;
                oSBCVar.Status__c = 'Complete Delivered';
            }
            update lstSendSBC;
        }   
    }
    
    global void finish(Database.BatchableContext info){
    
        //This method will be used to perform any action that 
        //needs to be executed once Batch is completed
        
        
    }
}