/*****************************************************************************************
    Name             : SearchAccountByZipCodeController_Test
    Description      : This class is visual force controller for page SearchAccountByZipCode which is used to search account based on zip code and radius
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
global class SearchAccountByZipCodeController_Test  implements HttpCalloutMock{
   
   Static String sSelectedEventLocaion;
   
      global HttpResponse respond(HTTPRequest req) 
  {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       //if(req.getEndpoint()==Integration_Endpoints__c.getAll().get('Zip Code Search').Endpoint_URL__c+'?api_key='+Integration_Endpoints__c.getAll().get('Zip Code Search').Authorization_Code__c){
       // System.assertEquals(Integration_Endpoints__c.getAll().get('Zip Code Search').Endpoint_URL__c+'?api_key='+Integration_Endpoints__c.getAll().get('Zip Code Search').Authorization_Code__c, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"zip_codes": [{"zip_code": "93109","distance": 3.744,"city": "Santa Barbara","state": "CA"}]}');
        res.setStatusCode(200);
        return res;
        
     //  }
       
       return null;
    }
    
    
      @isTest static  void createTestData()
  {  
     Test.startTest();
     List<Account> listAccount=new List<Account>();
         Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test1',Business_Email__c='test1@test.com',Preferred_Email__c='Business',BillingPostalCode='93109');
         Account volunteerTest2=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test2',Work_Email__c='test2@test.com',Preferred_Email__c='Work',BillingPostalCode='93109');
         Account volunteerTest3=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test3',Personal_Email__c='tes3t@test.com',Preferred_Email__c='Personal',BillingPostalCode='93109');
         listAccount.add(volunteerTest1);
         listAccount.add(volunteerTest2);
         listAccount.add(volunteerTest3);
        
         insert listAccount;
         System.assertEquals('Test1',volunteerTest1.Name);
      Test.stopTest();  
  }  
  
      @isTest  static void testSearchAccountByZipCode()
  {
  
  //createTestData();
   
      PageReference pageRef=Page.SearchAccountByZipCode;
      Test.setCurrentPage(pageRef);   
      
      Test.setMock(HttpCalloutMock.class, new SearchAccountByZipCodeController_Test());
      Test.startTest(); 
      SearchAccountByZipCodeController controller=new SearchAccountByZipCodeController() ;   
      controller.sZIPCode='93130';
      controller.getNearByPinCodeList();
      controller.sZIPCode='';
      controller.getNearByPinCodeList();
      controller.bFlag=true;
      controller.bShowPopUp=true;
      controller.sRecordId='sRecordId';
      controller.sMessage='sMessage';
      
      System.assertEquals('sMessage',controller.sMessage);
      
      Test.stopTest(); 
  }

}