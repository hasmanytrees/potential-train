/*****************************************************************************************
    Name             : AccountBORESTServices_Test
    Description      : This REST webservice is used to Call to query all Account and related Contact for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class AccountBORESTServices_Test{

  //Creating Test Data
        private Static List<Account> getAccountData()
    {    
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
           //----------------
        User user6 = new User();
        user6.Username= 'testusertest66@test.com';
        user6.Email= 'test6@test.com';
        user6.Lastname= 'user';
        user6.Firstname= 'test66';
        user6.isActive = true;
        user6.Alias= 'test';
        user6.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user6.TimeZoneSidKey= 'GMT';
        user6.LocaleSidKey= 'en_US';
        user6.Managerid = userinfo.getuserid();
        user6.EmailEncodingKey= 'ISO-8859-1';
        user6.LanguageLocaleKey= 'en_US';
        user6.Authorized_Campaign_Owner__c=true;
        user6.UserPermissionsMobileUser = true;
        insert user6;
        //--------------

        List<Account> lstAccountTestData=new  List<Account>();
        Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='1',ownerid = user6.id);
        Account oAccountVar2=new Account(Type='Individual',Status__c='Active',Name='Testdata2',Business_Email__c='testdata2@testdata.com',Legacy_Supporter_Id__c='2',ownerid = user6.id);
        Account oAccountVar3=new Account(Type='Foundation',Status__c='Active',Name='Testdata3',Business_Email__c='testdata3@testdata.com',Legacy_Supporter_Id__c='3',ownerid = user6.id);
        Account oAccountVar4=new Account(Type='Association',Status__c='Active',Name='Testdata4',Business_Email__c='testdata4@testdata.com',Legacy_Supporter_Id__c='4',ownerid = user6.id); 
        
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        lstAccountTestData.add(oAccountVar3);
        lstAccountTestData.add(oAccountVar4);
        
        return  lstAccountTestData;
    }
    
    //Covers AccountBORESTServices class
         public testMethod static void getAccountBO()
     { 
       Test.StartTest() ; 
       
     //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       List<Account> lstAccountTestData=getAccountData();
       insert lstAccountTestData;
       Contact contact=new Contact(AccountId=lstAccountTestData[0].Id,LastName='Test Contact');
       insert contact;
       
       system.assertEquals('Test Contact',contact.LastName);
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount?personid='+lstAccountTestData[0].Legacy_Supporter_Id__c;
        req.addParameter('personid', lstAccountTestData[0].Legacy_Supporter_Id__c);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        req.addParameter('personid', lstAccountTestData[1].Legacy_Supporter_Id__c);        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        req.addParameter('personid', '7678ZZZZXXXFDDDDG8**');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        
        req.addParameter('personid', '11111111111111111111111111111111111111111');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        
        req.addParameter( NULL, NULL );        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
      //  System.assertEquals(RestContext.response.responseBody.toString(),'No Account Found');
       Test.StopTest() ; 
     }
     // check exception 
     public testMethod static void getAccountBO2()
     { 
       Test.StartTest() ; 
       
     //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       List<Account> lstAccountTestData=getAccountData();
       insert lstAccountTestData;
       Contact contact=new Contact(AccountId=lstAccountTestData[0].Id,LastName='Test Contact');
       insert contact;
       
       Field_Group__c grpDelete = [ Select ID from Field_Group__c where name = 'AccountBOResponseProcessGroup']  ; 
           delete grpDelete ; 
       
       system.assertEquals('Test Contact',contact.LastName);
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount?personid='+lstAccountTestData[0].Legacy_Supporter_Id__c;
        req.addParameter('personid', lstAccountTestData[0].Legacy_Supporter_Id__c);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        req.addParameter('personid', lstAccountTestData[1].Legacy_Supporter_Id__c);        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        req.addParameter('personid', '7678ZZZZXXXFDDDDG8**');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        
        req.addParameter('personid', '11111111111111111111111111111111111111111');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
        
        req.addParameter( NULL, NULL );        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
      //  System.assertEquals(RestContext.response.responseBody.toString(),'No Account Found');
       Test.StopTest() ; 
     }
     
     //Covers AccountBORESTServices class
         public testMethod static void getAccountBONegative()
     { 
       Test.StartTest() ; 
       
     //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       List<Account> lstAccountTestData=getAccountData();
       insert lstAccountTestData;
       Contact contact=new Contact(AccountId=lstAccountTestData[0].Id,LastName='Test Contact');
       insert contact;
       
       system.assertEquals('Test Contact',contact.LastName);
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount?personid='+lstAccountTestData[0].Legacy_Supporter_Id__c;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        AccountBORESTServices.getAccountBO();
        
       Test.StopTest() ; 
     }

}