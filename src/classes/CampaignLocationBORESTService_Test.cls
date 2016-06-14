/*****************************************************************************************
    Name             : CampaignLocationBORESTService_Test
    Description      : This REST webservice is used to Call to query all Slot for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class CampaignLocationBORESTService_Test{

  
  public testMethod static void testCampaignLocationBO(){
  
  //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
  
  Test.startTest();
 
    Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
  insert ven;
  System.assertEquals('Venue test',ven.Name);
   Campaign EventTest=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven.Id,
        endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true,Published_Location_Name__c = 'test Location', 
        Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
  insert EventTest;
  System.assertEquals('Test Event Location2',EventTest.Name);
    
  
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/search?filterdatestart='+Date.today().Month()+'/'+Date.today().Day()+'/'+Date.today().Year();
    req.addParameter('filterdatestart',Date.today().Month()+'/'+Date.today().Day()+'/'+Date.today().Year() );  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    CampaignLocationBORESTService.getCampaignLocation();
    req = new RestRequest(); 
    res = new RestResponse();
   req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/search?eventlocationid='+EventTest.Id; 
   req.addParameter('eventlocationid', EventTest.Id);  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    CampaignLocationBORESTService.getCampaignLocation();
   delete EventTest;
    CampaignLocationBORESTService.getCampaignLocation();
    //System.assertEquals(RestContext.response.responseBody.toString(),'No Event Location Found');
  
  Test.stopTest();
  
  
  }
  
  public testMethod static void testCampaignLocationBO2(){
  
  //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
  Field_Group__c grpDelete = [ Select ID from Field_Group__c where name = 'CampaignLocationBOVenueResponseGroup']  ; 
           delete grpDelete ; 
           
  Test.startTest();
 
    Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
  insert ven;
  System.assertEquals('Venue test',ven.Name);
   Campaign EventTest=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven.Id,
        endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true,Published_Location_Name__c = 'test Location', 
        Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
  insert EventTest;
  System.assertEquals('Test Event Location2',EventTest.Name);
    
  
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/search?filterdatestart='+Date.today().Month()+'/'+Date.today().Day()+'/'+Date.today().Year();
    req.addParameter('filterdatestart',Date.today().Month()+'/'+Date.today().Day()+'/'+Date.today().Year() );  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    CampaignLocationBORESTService.getCampaignLocation();
    req = new RestRequest(); 
    res = new RestResponse();
   req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/search?eventlocationid='+EventTest.Id;
    req.addParameter('eventlocationid', EventTest.Id);
    req.addParameter('filterdatestart',Date.today().Month()+'/'+Date.today().Day()+'/'+Date.today().Year() );
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    CampaignLocationBORESTService.getCampaignLocation();
   delete EventTest;
    CampaignLocationBORESTService.getCampaignLocation();
    //System.assertEquals(RestContext.response.responseBody.toString(),'No Event Location Found');
  
  Test.stopTest();
  
  
  }

}