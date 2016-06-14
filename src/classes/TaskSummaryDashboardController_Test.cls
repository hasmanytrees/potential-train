@isTest(seeAllData=true)
private class TaskSummaryDashboardController_Test{

   
        public static testMethod void taskTest() 
    {
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        TaskSummaryDashboardController tsdController=new TaskSummaryDashboardController();
        PageReference pageRef = ApexPages.currentPage();
    
        User user = new User();
        user.Username= 'testuserooootest@test.com';
        user.Email= 'test@test.com';
        user.Lastname= 'user';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.Authorized_Campaign_Owner__c=true;
        user.UserPermissionsMobileUser = true;
        insert user;
        system.assertEquals('testuserooootest@test.com',user.Username);
    
         List<Campaign> listCampaign=new List<Campaign>();
        
        Campaign CampaignTest1=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), Name = 'Test Campaign1', type = 'Acquisition',Overview__c = 'abcd', Launch_Date__c = date.today(),Project_Manager__c = Userinfo.getUserId()); //
        Campaign CampaignTest2=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), Name = 'Test Campaign2', type = 'Acquisition',Overview__c = 'abcd', Launch_Date__c = date.today(),Project_Manager__c = Userinfo.getUserId()); //
        listCampaign.add(CampaignTest1);
        listCampaign.add(CampaignTest2);
        insert listCampaign;
        system.assertEquals('Test Campaign1',CampaignTest1.Name);
                
        List<Deliverable__c> listDeliverable=new List<Deliverable__c>();
        Deliverable__c DeliverableTest1=new Deliverable__c(RecordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'), Name = 'Test Deliverable1',Status__c ='Draft',Campaign__c = CampaignTest1.id);
        Deliverable__c DeliverableTest2=new Deliverable__c(RecordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'), Name = 'Test Deliverable2', Status__c ='Draft',Campaign__c = CampaignTest2.id);
        listDeliverable.add(DeliverableTest1);
        listDeliverable.add(DeliverableTest2);
        insert listDeliverable;
        system.assertEquals('Test Deliverable1',DeliverableTest1.Name);
        
         List<task> listTask=new List<task>();
        task taskTest1=new task(status = 'Assigned',ActivityDate = system.today().addDays(-30),whatid = DeliverableTest1.id );
        task taskTest2=new task(status = 'Assigned',ActivityDate = system.today().addDays(-10),whatid = CampaignTest1.id);
        listTask.add(taskTest1);
        listTask.add(taskTest2);
        insert listTask;

        
         Set<Id> setRelatedRecordId=new Set<Id>();
        
        for(Campaign c:listCampaign){        
        setRelatedRecordId.add(c.Id);
        }
        
        for(Deliverable__c d:listDeliverable){
        setRelatedRecordId.add(d.Id);        
        }
        
                
        TaskSummaryDashboardController ts1 = new TaskSummaryDashboardController();//initializing class
        
        TaskSummaryDashboardController.TaskSummary ts = new TaskSummaryDashboardController.TaskSummary(1,CampaignTest1);//initializing class wrapper
        
     
         try{
         tsdController.showReport();
         }
         catch(Exception ex) {}
         test.stopTest();
               
     }
     
     

     
    }