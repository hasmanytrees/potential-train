/*****************************************************************************************
    Name             : CommunicationPreferenceRESTService_Test
    Description      : This REST webservice is used to Call to query all Account and related Comminication Preferences                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                30/04/2015            Created
******************************************************************************************/
@isTest(SeeAllData=true)
public class CommunicationPreferenceRESTService_Test{

  //Creating Test Data
        private Static Account getAccountData()
    {    
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();

        Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',Do_Not_Email__c = false, Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='1');
        
        return  oAccountVar1;
    }
    
    //Covers AccountBORESTServices class
         public testMethod static void getCommunicationPreferences()
     { 
       Account oAccountTestData=getAccountData();
       insert oAccountTestData;
       Communication_Preference__c oCommPrefVar = new Communication_Preference__c();
       oCommPrefVar.Account__c =  oAccountTestData.id;
       
       System.Assert( oAccountTestData.ID != NULL ) ; 
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getCommunicationPreference?personid='+oAccountTestData.id;
        req.addParameter('personid', oAccountTestData.id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CommunicationPreferenceRESTService.getCommunicationPreference();
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getCommunicationPreference';
        req.addParameter('personid', 'sumeet');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        CommunicationPreferenceRESTService.getCommunicationPreference();
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getCommunicationPreference';
        req.addParameter('personid', ' ');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        System.Assert( req != NULL ) ; 
        RestContext.response = res;
        
        CommunicationPreferenceRESTService.getCommunicationPreference();
        
        
        
     }
     public testMethod static void getCommunicationPreferences2()
     { 
       
       Field_Group__c grpDelete = [ Select ID from Field_Group__c where name = 'AccountCommunicationPreferenceResponseProcessGroup']  ; 
           delete grpDelete ; 
       
       Test.StartTest() ; 
       Account oAccountTestData=getAccountData();
       insert oAccountTestData;
       Communication_Preference__c oCommPrefVar = new Communication_Preference__c();
       oCommPrefVar.Account__c =  oAccountTestData.id;
       
       System.Assert( oAccountTestData.ID != NULL ) ; 
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getCommunicationPreference?personid='+oAccountTestData.id;
        req.addParameter('personid', oAccountTestData.id);  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CommunicationPreferenceRESTService.getCommunicationPreference();
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getCommunicationPreference';
        req.addParameter('personid', 'sumeet');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.response = res;
        CommunicationPreferenceRESTService.getCommunicationPreference();
        
        Field_Group_Element__c ofieldElements = [select id, Field_API_Name__c from Field_Group_Element__c where Field_Group__r.Name = 'OtherCommunicationPreferenceResponseProcessGroup' LIMIT 1];
        ofieldElements.Field_API_Name__c = 'Account__r.Do_Not_Email__c';
        update ofieldElements;
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getCommunicationPreference';
        req.addParameter('personid', ' ');        
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        System.Assert( req != NULL ) ; 
        RestContext.response = res;
        
        CommunicationPreferenceRESTService.getCommunicationPreference();
        
        Test.StopTest() ;
        
     }

}