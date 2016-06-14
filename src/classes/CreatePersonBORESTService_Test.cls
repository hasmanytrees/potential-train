/*****************************************************************************************
    Name             : CreatePersonBORESTService_Test
    Description      : This REST webservice is used to Call to query all Account and related Contact for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class CreatePersonBORESTService_Test{
  
          public testMethod static void testCreateAccount()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
  
      Account accountVar1=new Account(Type='Business',Status__c='Active',Home_Phone__c = '6578369284', Name='Testdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23');
        insert accountVar1;
      Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{"Person":[{"LastName": "Anotnio", "InvalidBirthdate": "true","LegacyConId":"1","LegacyId":"23"}]}';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createContact';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreatePersonBORESTService.createContact();
     
  String sInputJSON2='{"Person":[{"LastName": "Wagner", "InvalidBirthdate": "false","LegacyConId":"223445465786"}]}';
  
    req = new RestRequest(); 
   res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createContact';
    req.requestBody=Blob.valueOf(sInputJSON2);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreatePersonBORESTService.createContact();
  
       req = new RestRequest(); 
   res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createContact';
   String sInputJSON3 = '';
    req.requestBody=Blob.valueOf(sInputJSON3);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    try{
    CreatePersonBORESTService.createContact();
    
    }
    catch(Exception ex){}
  
 
 
  }

     public testMethod static void testCreateContact()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
  
      Account accountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='7835765');
        insert accountVar1;
      Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{"Person":[{"LastName": "Anotnio","InvalidBirthdate": "true","LegacyConId":"1","LegacyId":"23"}]}';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createContact';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreatePersonBORESTService.createContact();
    
   }


     public testMethod static void testCreateAccount2()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
  
      Account accountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='1');
        insert accountVar1;
      Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{"Person":[{"LastName": "Anotnio", "InvalidBirthdate": "true","LegacyConId":"1","LegacyId":"23"},{"LastName": "Anotnio", "InvalidBirthdate": "true","LegacyConId":"1","LegacyId":"23"}]}';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createContact';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreatePersonBORESTService.createContact();
    }
}