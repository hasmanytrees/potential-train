/*****************************************************************************************
    Name             : GoalsTrigger_Test
    Description      : Test class to cover scenario of Goals Trigger           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                05/02/2014            Created
Subhojit                
******************************************************************************************/
@isTest(seeAllData=true)
private class GoalsTrigger_Test{
    // Create Test Data
        
            private static List<Goals__c> createTestData()
        {
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<Goals__c>  listGoals = new List<Goals__c>();    
        User user = new User();
        user.Username= 'testuser11111test@test.com';
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
        Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),Launch_Date__c = System.today(),Name='Test Campaign',Status='Draft',ownerId=user.Id);
        insert campaignTestVar;
        
        Campaign EventTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'),Name='Test Event',Status='Draft',ownerId=user.Id, type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event');
        insert EventTestVar;
        
        //---------------------------------     
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location');
        insert EventTest2;
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = user.id, ownerid = user.id, Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true,
        Estimated_Audience_Size__c = 23, Actual_Sponsorships_On_FCD__c = 23 , Actual_Revenue_On_FCD__c= 23,
        Actual_Impact__c = 23, Actual_Impact_On_FCD__c = 23, Actual_Continuity_On_FCD__c = 23);    
        insert EventLocationTest2;        
        //-----------------------------------
        
         System.AssertEquals('Test Event2',EventTest2.Name );
         System.AssertEquals('Andheri',ven.City__c );
         System.AssertEquals(23,EventLocationTest2.Number_Of_Booths_Tables__c);
        
        
            Goals__c GoalsTest1=new Goals__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23);
            Goals__c GoalsTest2=new Goals__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest3=new Goals__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Revenue' ,Product__c = 'Number', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest4=new Goals__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'Continuity', Funds__c = 'Bibles', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            
            Goals__c GoalsTest5=new Goals__c(Campaign__c=EventTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest6=new Goals__c(Campaign__c=EventTestVar.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest7=new Goals__c(Campaign__c=EventTestVar.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Revenue' ,Product__c = 'Number', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest8=new Goals__c(Campaign__c=EventTestVar.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'Continuity', Funds__c = 'Bibles', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            
            Goals__c GoalsTest9=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest10=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest11=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Revenue' ,Product__c = 'Number', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            Goals__c GoalsTest12=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'Continuity', Funds__c = 'Bibles', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
            
            listGoals.add(GoalsTest1);
            listGoals.add(GoalsTest2);
            listGoals.add(GoalsTest3);
            listGoals.add(GoalsTest4);
            
            listGoals.add(GoalsTest5);
            listGoals.add(GoalsTest6);
            listGoals.add(GoalsTest7);
            listGoals.add(GoalsTest8);
            
            listGoals.add(GoalsTest9);
            listGoals.add(GoalsTest10);
            listGoals.add(GoalsTest11);
            listGoals.add(GoalsTest12);        
        
        return listGoals;        
    }
    
        static testmethod void Goals_trigger()
    { 
        
        
      // List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
    
      //  list<Campaign> listCamp = createTestData_Camp();
     
        List<Goals__c>  listGoals = createTestData(); 
        insert listGoals;    //Checking insert scenarios.
        List<Goals__c>  listnewGoals = new list<Goals__c>();      
        Map<Id,Goals__c> mapNewGoalsList = new Map<Id,Goals__c>();
      
        listGoals[0].Revenue_Target__c = 27;        
        listGoals[1].Revenue_Target__c = 27;
        listGoals[2].Revenue_Target__c = 27;
        listGoals[3].Revenue_Target__c = 27;
        
        listGoals[4].Revenue_Target__c = 27;        
        listGoals[5].Revenue_Target__c = 27;
        listGoals[6].Revenue_Target__c = 27;
        listGoals[7].Revenue_Target__c = 27;
        
        listGoals[8].Revenue_Target__c = 27;        
        listGoals[9].Revenue_Target__c = 27;
        listGoals[10].Revenue_Target__c = 27;
        listGoals[11].Revenue_Target__c = 27;
        
        listnewGoals.add(listGoals[0]);
        listnewGoals.add(listGoals[1]);
        listnewGoals.add(listGoals[2]);
        listnewGoals.add(listGoals[3]);        
        
        listnewGoals.add(listGoals[4]);
        listnewGoals.add(listGoals[5]);
        listnewGoals.add(listGoals[6]);
        listnewGoals.add(listGoals[7]);        
        
        listnewGoals.add(listGoals[8]);
        listnewGoals.add(listGoals[9]);
        listnewGoals.add(listGoals[10]);
        listnewGoals.add(listGoals[11]);
        test.startTest();
        update listnewGoals;   //Updating Budget in BudgetExpense object.
        
        for(Goals__c g : listnewGoals){
        mapNewGoalsList.put(g.id,g);
        }
        
         System.AssertEquals(27,listGoals[3].Revenue_Target__c);
         System.AssertEquals(27,listGoals[7].Revenue_Target__c);
         System.AssertEquals(27,listGoals[11].Revenue_Target__c);
        
        delete listGoals[0]; // delete BudgetExpense scenario.
        
        EventTriggerHelper.iRecursiveCheck = 1;
        
        GoalsTriggerHandler GTHandler = new GoalsTriggerHandler();    //Covering constructor        
        
        GoalsTriggerHandler.goalsRollUpOnCampaignObjectafterinsert(mapNewGoalsList,listGoals);
      
         test.stopTest();        
    }
    
    
    public static testMethod void performGoalDeletionScenario()
    {
        Test.startTest();
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event');
        insert EventTest2;
        
        List<Goals__c> goalsList = new List<Goals__c>();
        Goals__c GoalsTest1=new Goals__c(Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23);
        Goals__c GoalsTest2=new Goals__c(Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        goalsList.add(GoalsTest1);
        goalsList.add(GoalsTest2);
        insert goalsList;
        
        delete goalsList;
        
        Test.stopTest();    
    }
    
}