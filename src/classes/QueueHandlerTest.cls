/******************************************************************************
Name             : QueueHandlerTest
Description      : Test class for FetchBeneficaryISLRESTServices                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class QueueHandlerTest{
    
    public testMethod static void QueueHandler(){  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockMashery());
        Error_Log__c oErrorData = new Error_Log__c ( Endpoint_URL__c = 'test', IsRepeatEnabled__c = false, Integration_Name__c = 'SBCCommitment',
                                                      Method__c = 'POST', Number_Of_Iterations__c = 1 , JSON__c = '{ "test" : "test" }' ) ;
        
        List<Error_Log__c> oErrorDatalist = new List<Error_Log__c> () ; 
        oErrorDatalist.add(oErrorData) ; 
        insert oErrorDatalist ; 
        
        Set<Id> setErrIDs = new Set<ID> () ; 
        setErrIDs.add (oErrorData.ID ) ; 
        Error_Log_Repeats__c oErrorLogRepeat = new Error_Log_Repeats__c ( Name = 'test' , Maximum_Iterations__c  = 2 ) ; 
        insert oErrorLogRepeat ;
        
        List<Error_Log__c > lstErr = TestDataUtility.ErrorlogTestData () ;  
        Set<ID> setRecIDs = new Set<ID> () ; 
        for( Error_Log__c oErrData: lstErr ) {
            setRecIDs.add( oErrData.ID ) ; 
        }
        Test.StartTest() ; 
        QueueHandler oQueueTest = new QueueHandler ( 'Generic', 'Error_Log__c', setRecIDs ) ;
        System.QueueableContext objContext ; 
        oQueueTest.execute ( objContext  ) ; 
        
        oErrorData.Integration_Name__c = 'XMpie';
        update oErrorData;
        Set<Id> setId2 = new Set<Id>();
        setId2.add(oErrorData.id);
        QueueHandler oQueueTest1 = new QueueHandler ( 'Generic', 'Error_Log__c', setId2 ) ;
        System.QueueableContext objContext1 ; 
        oQueueTest1.execute ( objContext1  ) ;  
        
        oErrorData.Integration_Name__c = 'S2BCI';
        update oErrorData;
        Set<Id> setId3 = new Set<Id>();
        setId3.add(oErrorData.id);
        QueueHandler oQueueTest2 = new QueueHandler ( 'Generic', 'Error_Log__c', setId3 ) ;
        System.QueueableContext objContext2 ; 
        oQueueTest2.execute ( objContext2  ) ;  
        Test.StopTest() ; 
    }
    
    public testMethod static void QueueHandler1(){  
        Error_Log__c oErrorData = new Error_Log__c ( Endpoint_URL__c = 'test', IsRepeatEnabled__c = false, Integration_Name__c = 'test',
                                                      Method__c = 'POST', Number_Of_Iterations__c = 1 , JSON__c = '{ "test" : "test" }' ) ;
        
        List<Error_Log__c> oErrorDatalist = new List<Error_Log__c> () ; 
        oErrorDatalist.add(oErrorData) ; 
        insert oErrorDatalist ; 
        
        Set<Id> setErrIDs = new Set<ID> () ; 
        setErrIDs.add (oErrorData.ID ) ; 
        Error_Log_Repeats__c oErrorLogRepeat = new Error_Log_Repeats__c ( Name = 'test' , Maximum_Iterations__c  = 2 ) ; 
        insert oErrorLogRepeat ;
        
        List<Error_Log__c > lstErr = TestDataUtility.ErrorlogTestData () ;  
        Set<ID> setRecIDs = new Set<ID> () ; 
        for( Error_Log__c oErrData: lstErr ) {
            oErrData.Method__c = 'post' ; 
            oErrData.Is_Escalated__c = true; 
            setRecIDs.add( oErrData.ID ) ; 
        }
        update lstErr ;
        Test.StartTest() ; 
        QueueHandler oQueueTest = new QueueHandler ( 'Generic', 'Error_Log__c', setRecIDs ) ;
        System.QueueableContext objContext ; 
        oQueueTest.execute ( objContext  ) ; 
        Test.StopTest() ; 
    }
}