/*****************************************************************************************
    Name             : DeleteSBCCommRestServices_Test
    Description      : This test class is used for covering all the test scneario 
                       related to the DeleteSBCCommRestServices                
    Modification Log : 
---------------------------------------------------------------------------
    Developer              Date              Description
---------------------------------------------------------------------------
    Jeevan                 15/10/2015            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class DeleteSBCCommRestServices_Test
{
       private static testMethod void testSBCRecorddeletion1()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
            Account oBen = TestDataUtility.createBeneficiary () ;
            Account oSupporter =  TestDataUtility.createSupporter () ;
            SBC_Communications__c oSBCVar = TestDataUtility.createSBCCommRecord ( oBen ,oSupporter,'Beneficiary To Supporter' ) ; 
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/deleteSBCComm';
            String sInputJSON = '{ "CommunicationDeletion" : [ { "GlobalCommId" : "XYZ678678"  }]}' ; 
            req.requestBody=Blob.valueOf(sInputJSON);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.assertEquals('POST', req.httpMethod);
            
            DeleteSBCCommRestServices.deleteSBCComm () ; 
            
        }  
        
         
        
        private static testMethod void testSBCRecorddeletion2()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
            Account oBen = TestDataUtility.createBeneficiary () ;
            Account oSupporter =  TestDataUtility.createSupporter () ;
            SBC_Communications__c oSBCVar = TestDataUtility.createSBCCommRecord ( oBen ,oSupporter,'Beneficiary To Supporter' ) ; 
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/deleteSBCComm';
            String sInputJSON = '{ "CommunicationDeletion" : [ { "GlobalCommId" : "%^&$W$"  }]}';             
            req.requestBody=Blob.valueOf(sInputJSON);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.assertEquals('POST', req.httpMethod);
            
            DeleteSBCCommRestServices.deleteSBCComm () ; 
            
        }  
        
        private static testMethod void testSBCRecorddeletion3()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
            Account oBen = TestDataUtility.createBeneficiary () ;
            Account oSupporter =  TestDataUtility.createSupporter () ;
            SBC_Communications__c oSBCVar = TestDataUtility.createSBCCommRecord ( oBen ,oSupporter,'Beneficiary To Supporter' ) ; 
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/deleteSBCComm';
            String sInputJSON = '{ "CommunicationDeletion" : [ { "GlobalCommId" : "TTZ678678" }]}';             
            req.requestBody=Blob.valueOf(sInputJSON);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.assertEquals('POST', req.httpMethod);
            
            DeleteSBCCommRestServices.deleteSBCComm () ; 
            
        } 
        
        private static testMethod void testSBCRecorddeletion4()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
            Account oBen = TestDataUtility.createBeneficiary () ;
            Account oSupporter =  TestDataUtility.createSupporter () ;
            SBC_Communications__c oSBCVar = TestDataUtility.createSBCCommRecord ( oBen ,oSupporter,'Beneficiary To Supporter' ) ; 
            JSON_Process__c oJsonProcessDel = [ Select ID from JSON_Process__c where name = 'SBCCommunicationDeletionResponseProcess' ] ; 
            delete oJsonProcessDel ; 
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/deleteSBCComm';
            String sInputJSON = '{ "CommunicationDeletion" : [ { "GlobalCommId" : "XYZ678678"  }]}' ; 
            req.requestBody=Blob.valueOf(sInputJSON);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.assertEquals('POST', req.httpMethod);
            
            DeleteSBCCommRestServices.deleteSBCComm () ; 
            
        } 
}