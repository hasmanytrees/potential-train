/*****************************************************************************************
    Name             : ContactBORESTServices_Test
    Description      : This REST webservice is used to Call to query all Slot for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class ContactBORESTServices_Test{


      public testMethod static void testGetContactBO()
  {
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        Test.StartTest() ; 
        
        List<Account> lstAccount=new List<Account>();
        Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Legacy_Supporter_Id__c='123',Name='Test1',Status__c='Active',Business_Email__c='test1@test.com',Preferred_Email__c='Business',Type='Individual');
        Account volunteerTest2=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Legacy_Supporter_Id__c='1234',Name='Test1',Status__c='Active',Business_Email__c='test1@test.com',Preferred_Email__c='Business',Type='Advocate');
        lstAccount.add(volunteerTest1);
        lstAccount.add(volunteerTest2);
        
        insert lstAccount;
        system.assertEquals('Individual',volunteerTest1.Type);
        List<Relationship_Group__c > lstRelGroup=new List<Relationship_Group__c >();
        Relationship_Group__c regGroup1=new Relationship_Group__c(Supporter__c=lstAccount[0].Id,Group__c=lstAccount[1].Id);
        lstRelGroup.add(regGroup1);
        Relationship_Group__c regGroup2=new Relationship_Group__c(Group__c=lstAccount[1].Id,Supporter__c=lstAccount[0].Id);
        lstRelGroup.add(regGroup2);
        
        insert lstRelGroup;
        Contact contactTest=new Contact(AccountId=lstAccount[0].Id,LastName='test Contact');
        Contact contactTest2=new Contact(AccountId=lstAccount[1].Id,LastName='test Contact');
        insert contactTest;
        insert contactTest2;
        System.Assert ( contactTest2.ID != NULL ) ; 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('organizationid', lstAccount[1].Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', lstAccount[0].Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', contactTest.Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        delete volunteerTest1;
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', contactTest.Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        Test.StopTest() ; 
  }

           public testMethod static void testGetContactBO2()
  {
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        Test.StartTest() ; 
        
        List<Account> lstAccount=new List<Account>();
        Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Legacy_Supporter_Id__c='123',Name='Test1',Status__c='Active',Business_Email__c='test1@test.com',Preferred_Email__c='Business',Type='Individual');
        lstAccount.add(volunteerTest1) ; 
        upsert lstAccount;
        
        Account volunteerTest2 =new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Legacy_Supporter_Id__c='1234',Name='Test1',Status__c='Active',Business_Email__c='test1@test.com',Preferred_Email__c='Business',Type='Individual', ParentID = volunteerTest1.ID);
        lstAccount.add(volunteerTest2) ; 
        upsert lstAccount;
        
        system.assertEquals('Individual',volunteerTest1.Type);
        List<Relationship_Group__c > lstRelGroup=new List<Relationship_Group__c >();
        Relationship_Group__c regGroup1=new Relationship_Group__c(Supporter__c=lstAccount[0].Id,Group__c=lstAccount[1].Id);
        lstRelGroup.add(regGroup1);
        Relationship_Group__c regGroup2=new Relationship_Group__c(Group__c=lstAccount[1].Id,Supporter__c=lstAccount[0].Id);
        lstRelGroup.add(regGroup2);
        
        insert lstRelGroup;
        Contact contactTest=new Contact(AccountId=lstAccount[0].Id,LastName='test Contact');
        Contact contactTest2=new Contact(AccountId=lstAccount[1].Id,LastName='test Contact');
        insert contactTest;
        insert contactTest2;
        System.Assert ( contactTest2.ID != NULL ) ; 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('organizationid', lstAccount[1].Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', lstAccount[0].Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', contactTest.Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        delete volunteerTest1;
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', contactTest.Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        Test.StopTest() ; 
  }

    public testMethod static void testGetContactBO3()
  {
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        Test.StartTest() ; 
        JSON_Process__c oDeleteJSON = [Select ID from JSON_Process__c where Name = 'ContactBOResponseProcess' ] ;
        delete oDeleteJSON ;  
        List<Account> lstAccount=new List<Account>();
        Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Legacy_Supporter_Id__c='123',Name='Test1',Status__c='Active',Business_Email__c='test1@test.com',Preferred_Email__c='Business',Type='Individual');
        lstAccount.add(volunteerTest1) ; 
        upsert lstAccount;
        
        Account volunteerTest2 =new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Legacy_Supporter_Id__c='1234',Name='Test1',Status__c='Active',Business_Email__c='test1@test.com',Preferred_Email__c='Business',Type='Individual', ParentID = volunteerTest1.ID);
        lstAccount.add(volunteerTest2) ; 
        upsert lstAccount;
        
        system.assertEquals('Individual',volunteerTest1.Type);
        List<Relationship_Group__c > lstRelGroup=new List<Relationship_Group__c >();
        Relationship_Group__c regGroup1=new Relationship_Group__c(Supporter__c=lstAccount[0].Id,Group__c=lstAccount[1].Id);
        lstRelGroup.add(regGroup1);
        Relationship_Group__c regGroup2=new Relationship_Group__c(Group__c=lstAccount[1].Id,Supporter__c=lstAccount[0].Id);
        lstRelGroup.add(regGroup2);
        
        insert lstRelGroup;
        Contact contactTest=new Contact(AccountId=lstAccount[0].Id,LastName='test Contact');
        Contact contactTest2=new Contact(AccountId=lstAccount[1].Id,LastName='test Contact');
        insert contactTest;
        insert contactTest2;
        System.Assert ( contactTest2.ID != NULL ) ; 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('organizationid', lstAccount[1].Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', lstAccount[0].Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', contactTest.Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        delete volunteerTest1;
        req = new RestRequest(); 
        res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons/persondetails';
        req.addParameter('personid', contactTest.Id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ContactBORESTServices.getContactBO();
        
        Test.StopTest() ; 
  }

}