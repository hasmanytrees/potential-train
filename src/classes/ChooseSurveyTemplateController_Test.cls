/*****************************************************************************************
    Name             : ChooseSurveyTemplateController
    Description      : It is used as controller for ChooseSurveyTemplate vf page       
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)

 public class ChooseSurveyTemplateController_Test
 {
        private static void createTestData()
        {    
          //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
            survey__c survey = new survey__c(RecordtypeId=Utility.getRecordType('Survey Templete','Survey__c'),Submit_Response__c = 'test response' ,URL__c='test.salesforce.com' );
            insert Survey;
            System.assertEquals('test response',survey.Submit_Response__c);
                    
            List<Survey_Question__c> listSurveyQuestion = new List<Survey_Question__c>();
            Survey_Question__c SurveyQuestion = new Survey_Question__c(Survey__c = survey.id, Question__c = 'I found out about this event through.SingleRelect', OrderNumber__c = 0, Choices__c = 'An Email', Type__c = 'Single Select--Vertical');
            insert SurveyQuestion;
            Survey_Question__c SurveyQuestion1 = new Survey_Question__c(Survey__c = survey.id, Question__c = 'I found out about this event through. MultiSelect', OrderNumber__c = 1, Choices__c = 'Searching in My Account', Type__c = 'Multi-Select--Vertical');
            insert SurveyQuestion1;
            Survey_Question__c SurveyQuestion2 = new Survey_Question__c(Survey__c = survey.id, Question__c = 'I found out about this event through.Free Text', OrderNumber__c = 2,  Type__c = 'Free Text');
            insert SurveyQuestion2;        
            
            System.assertEquals('I found out about this event through.SingleRelect',SurveyQuestion.Question__c);
            System.assertEquals('I found out about this event through. MultiSelect',SurveyQuestion1.Question__c);
            System.assertEquals('I found out about this event through.Free Text',SurveyQuestion2.Question__c);
        
        }
 
        public testMethod static void testChooseSurvey()
        {
            test.startTest();
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      
            Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), StartDate=Date.today(),EndDate=Date.today().addDays(5),Name = 'Test Event Loc1786786786786787678667878678678786786786786786786786988978978789', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
            insert EventTest1;
            System.assertEquals('Draft',EventTest1.Status);
            
            Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
            insert Ven; // Initializing Venue Record
            System.assertEquals('Venue test',ven.Name);
            
            Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), StartDate=Date.today().addDays(1),EndDate=Date.today().addDays(4),Name = 'Test Event Loc1786786786786787678667878678678786786786786786786786988978978789', status ='Scheduled', 
            Event__c = EventTest1.id, Venue__c = ven.id,Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, 
            Cancellation_Reason__c = 'test Cancel' );
            
            insert EventLocationTest1;
            System.assertEquals('Scheduled',EventLocationTest1.status);
            
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
            Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
                    
            insert VSTest1;
            System.assertEquals('Developer',VSTest1.Volunteer_Role__c);
            
            
          
            List<Account> listAccount=new List<Account>();
            Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test1',Business_Email__c='test1@test.com',Preferred_Email__c='Business');
            Account volunteerTest2=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test2',Work_Email__c='test2@test.com',Preferred_Email__c='Work');
            Account volunteerTest3=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test3',Personal_Email__c='tes3t@test.com',Preferred_Email__c='Personal');
            listAccount.add(volunteerTest1);
            listAccount.add(volunteerTest2);
            listAccount.add(volunteerTest3);
            
            insert listAccount;
            System.assertEquals('Business',volunteerTest1.Preferred_Email__c);
            
            
            List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c=:VSTest1.Id]; //Getting newly created Volunteer Slots
            
            listVSlotTest[0].Volunteer__c=listAccount[0].Id;
            listVSlotTest[0].Status__c='Approved';
            listVSlotTest[1].Volunteer__c=listAccount[1].Id;
            listVSlotTest[1].Status__c='Approved';
            listVSlotTest[2].Volunteer__c=listAccount[2].Id;
            listVSlotTest[2].Status__c='Approved';
            update listVSlotTest;
            System.assertEquals('Approved',listVSlotTest[0].Status__c);                 
            
            
            PageReference pageRef=Page.ChooseSurveyTemplate;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('elocationId',EventLocationTest1.Id+('?parent_domain'));
    
            try{
                ChooseSurveyTemplateController controller=new ChooseSurveyTemplateController();
                controller.createSurvey();
            }
            catch(Exception ex){
            }
   
            createTestData();
            ChooseSurveyTemplateController controller=new ChooseSurveyTemplateController();
            controller.createSurvey();
            
            EventTest1.StartDate=Date.today().AddDays(-60);
            EventTest1.EndDate=Date.Today().addDays(-35);
            update EventTest1;
            controller=new ChooseSurveyTemplateController();
            controller.createSurvey();
            
            EventTest1.EndDate=null;
            update EventTest1;

            controller=new ChooseSurveyTemplateController();
            controller.createSurvey();
           
            test.stopTest();
        }
  
  
        public testMethod static void testChooseSurveyExeptionScenario()
        {
            test.startTest();
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      
            Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), StartDate=Date.today(),EndDate=Date.today().addDays(5),Name = 'Test Event Loc1786786786786787678667878678678786786786786786786786988978978789', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
            insert EventTest1;
            System.assertEquals('Draft',EventTest1.Status);
            
            Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
            insert Ven; // Initializing Venue Record
            System.assertEquals('Venue test',ven.Name);
            
            Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), StartDate=Date.today().addDays(1),EndDate=Date.today().addDays(4),Name = 'Test Event Loc1786786786786787678667878678678786786786786786786786988978978789', status ='Scheduled', 
            Event__c = EventTest1.id, Venue__c = ven.id,Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, 
            Cancellation_Reason__c = 'test Cancel' );
            
            insert EventLocationTest1;
            System.assertEquals('Scheduled',EventLocationTest1.status);
            
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
            Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
                    
            insert VSTest1;
            System.assertEquals('Developer',VSTest1.Volunteer_Role__c);
            
            
          
            List<Account> listAccount=new List<Account>();
            Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test1',Business_Email__c='test1@test.com',Preferred_Email__c='Business');
            Account volunteerTest2=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test2',Work_Email__c='test2@test.com',Preferred_Email__c='Work');
            Account volunteerTest3=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test3',Personal_Email__c='tes3t@test.com',Preferred_Email__c='Personal');
            listAccount.add(volunteerTest1);
            listAccount.add(volunteerTest2);
            listAccount.add(volunteerTest3);
            
            insert listAccount;
            System.assertEquals('Business',volunteerTest1.Preferred_Email__c);
            
            
            List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c=:VSTest1.Id]; //Getting newly created Volunteer Slots
            
            listVSlotTest[0].Volunteer__c=listAccount[0].Id;
            listVSlotTest[0].Status__c='Approved';
            listVSlotTest[1].Volunteer__c=listAccount[1].Id;
            listVSlotTest[1].Status__c='Approved';
            listVSlotTest[2].Volunteer__c=listAccount[2].Id;
            listVSlotTest[2].Status__c='Approved';
            update listVSlotTest;
            System.assertEquals('Approved',listVSlotTest[0].Status__c);                 
            
            
            PageReference pageRef=Page.ChooseSurveyTemplate;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('elocationId',EventLocationTest1.Id+('?parent_domain'));
    
            try{
                ChooseSurveyTemplateController controller=new ChooseSurveyTemplateController();
                controller.createSurvey();
            }
            catch(Exception ex){
            }
   
            createTestData();
            ChooseSurveyTemplateController controller=new ChooseSurveyTemplateController();
            controller.createSurvey();
            
            EventTest1.StartDate=Date.today().AddDays(-60);
            EventTest1.EndDate=Date.Today().addDays(-35);
            update EventTest1;
            controller=new ChooseSurveyTemplateController();
            controller.createSurvey();
            
            EventTest1.EndDate=null;
            update EventTest1;

            controller=new ChooseSurveyTemplateController();
            controller.sSelectedSurvey = 'xyz' ; 
            controller.sEventLocationId = NULL ; 
            controller.createSurvey();
           
            test.stopTest();
        }
  
 
 }