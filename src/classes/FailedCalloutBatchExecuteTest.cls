/******************************************************************************
Name             : FailedCalloutBatchExecuteTest
Description      : Test class for FetchBeneficaryISLRESTServices                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class FailedCalloutBatchExecuteTest{
    
    public testMethod static void FailedCalloutBatchExecute (){  
        
         Error_Log__c oErrorData = new Error_Log__c ( Endpoint_URL__c = 'test', IsRepeatEnabled__c = false, Integration_Name__c = 'test',
                                                      Method__c = 'POST', Number_Of_Iterations__c = 1 , JSON__c = '{ "test" : "test" }' ) ;
        
        List<Error_Log__c> oErrorDatalist = new List<Error_Log__c> () ; 
        oErrorDatalist.add(oErrorData) ; 
        insert oErrorDatalist ; 
        
        Error_Log_Repeats__c oErrorLogRepeat = new Error_Log_Repeats__c ( Name = 'test' , Maximum_Iterations__c  = 2 ) ; 
        insert oErrorLogRepeat ;
        
        Test.StartTest() ; 
        
            FailedCalloutBatchExecute oTestBatchClass = new FailedCalloutBatchExecute () ; 
            Database.BatchableContext BC ; 
            oTestBatchClass.start ( BC ) ;  
            oTestBatchClass.execute ( BC , oErrorDatalist ) ; 
            oTestBatchClass.finish ( BC ) ; 
            
        Test.StopTest() ;         
    }
}