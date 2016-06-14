/******************************************************************************
Name             : SupporterCommunicationISLRestServiceTest
Description      : Test class for UpsertBenificiaryRESTService                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class SupporterCommunicationISLRestServiceTest{
    
    
    public static void shutDownValidation()
    {
         Trigger_Methods_Activation__c oRef = Trigger_Methods_Activation__c.getAll().get('Commitment Validation Check');
    oRef.Is_Trigger_Method_Required_In_Delete__c=false;
    oRef.Is_Trigger_Method_Required_In_Insert__c=false;
    oRef.Is_Trigger_Method_Required_In_Update__c=false;
    update oRef;
    }
    public testMethod static void getSBCCommunications(){
    
      shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('beneficiaryid', oBenRec.ID);  
            req.addParameter('queryType', 'search'); 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationstwo(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('beneficiaryid', oBenRec.BEN_Local_Id__c );  
            req.addParameter('queryType', 'available'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ; 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationsthree(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

        
       
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('supporterid', oSupRec.ID);  
            req.addParameter('queryType', 'details'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ; 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
        SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ; 
        
        
        SupporterCommunicationISLRestService.getSBCCommunications () ;     
        SBC_Communications__c oSBCRec2 = oSBCRec ;  
        oSBCRec2.SBC_Global_Id__c = oSBCRec2.ID = NULL ; 
      //  insert oSBCRec2 ;  
        SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationsfour(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('supporterid', oSupRec.Legacy_Supporter_Id__c);  
            req.addParameter('queryType', 'read'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ; 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationsfive(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('id', oSBCRec.id);  
            req.addParameter('queryType', 'unread'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ; 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationsSix(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('id', oSBCRec.id);  
            req.addParameter('queryType', 'transit'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ; 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationsSeven(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('id', oSBCRec.id);  
            req.addParameter('queryType', 'history'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ; 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
            oSBCRec.status__c = 'In Translation' ;
                update oSBCRec ;  
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
            req.addParameter('id', '');  
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationsEight(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('id', oSBCRec.id);  
            req.addParameter('queryType', 'summary'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ; 
            RestContext.request = req;
            RestContext.response = res; 
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            
            req.addParameter('id', '');  
            SupporterCommunicationISLRestService.createSBCComm() ; 
            
        Test.StopTest() ; 
              
    }
    
    public testMethod static void getSBCCommunicationsNine(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ; 
       oSBCRec.Date_Physical_Received__c = system.Today() ;  
       update oSBCRec; 
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('id', oSBCRec.id);  
            req.addParameter('queryType', 'details'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ;  
            
            oSBCRec.status__c = 'In Translation' ;
                update oSBCRec ;  
            req.addParameter('commDate', '2010-11-11');  
            req.addParameter('physicalReceivedDate', '2010-11-11');  
            req.addParameter('readyForISLDate', '2010-11-11'); 
            req.addParameter('states', 'In Translation'); 
            req.addParameter('direction', 'b2s'); 
            req.addParameter('sortDirection', 'asc'); 
            req.addParameter('orderBy', 'asc');  
            RestContext.request = req;
            RestContext.response = res; 
              
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
  
  }
  public testMethod static void getSBCCommunicationsten(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ; 
       oSBCRec.Date_Physical_Received__c = system.Today() ;  
       update oSBCRec; 
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('id', oSBCRec.id);  
            req.addParameter('queryType', 'details'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ;  
            
            oSBCRec.status__c = 'In Translation' ;
                update oSBCRec ;  
            req.addParameter('commDate', '2010-11-11');  
            req.addParameter('physicalReceivedDate', '2010-11-11');  
            req.addParameter('readyForISLDate', '2010-11-11'); 
            req.addParameter('states', 'In Translation'); 
            req.addParameter('direction', 'b2s'); 
            req.addParameter('sortDirection', 'asc'); 
            req.addParameter('orderBy', 'asc');  
            req.addParameter('Internal_Perceptive_SequenceNumber', '123'); 
            req.addParameter('Internal_Perceptive_BatchId', '321'); 
            RestContext.request = req;
            RestContext.response = res; 
              
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            System.assertequals(true,req!=null);
  
  }
  
  public testMethod static void getSBCCommunicationseleven(){
    shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ; 
       oSBCRec.Date_Physical_Received__c = system.Today() ;  
       update oSBCRec; 
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/communications?';
            req.addParameter('id', oSBCRec.id);  
            req.addParameter('queryType', 'details'); 
        //    request.params.put ( 'beneficiaryid', oBenRec.ID ) ;  
            
            oSBCRec.status__c = 'In Translation' ;
                update oSBCRec ;  
            req.addParameter('commDate', '2010-11-11');  
            req.addParameter('physicalReceivedDate', '2010-11-11');  
            req.addParameter('readyForISLDate', '2010-11-11'); 
            req.addParameter('states', 'In Translation'); 
            req.addParameter('direction', 's2b'); 
            req.addParameter('sortDirection', 'asc'); 
            req.addParameter('skip', '0'); 
            req.addParameter('take', '1');  
            RestContext.request = req;
            RestContext.response = res; 
              
            SupporterCommunicationISLRestService.getSBCCommunications () ; 
            System.assertequals(true,req!=null);
  
  }
   
}