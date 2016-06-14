/*******************************************************************************
    Name             : EventTriggerHelper_Test
    Description      : Test Claas for covering all Trigger Helper class used to handle multiple 
                       scenario of Campaign .                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Sumeet                 11/1/2014            Created
   ***************************************************************************/

@isTest(SeeAllData=true)
public class EventTriggerHelper_Test
{
    public static testMethod void EventTriggerHelperCampaignCoverage()
    {
        Test.startTest();
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar;
        
        Campaign CampaignTest1=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), status = 'Completed', Name = 'Test Campaign1', type = 'Acquisition',
        endDate=date.today(),Program__c=ProgramTestVar.id,Launch_Date__c= date.today(),Overview__c='abcd',StartDate = date.today());
        insert CampaignTest1;
        
        List<Goals__c> goalsList = new List<Goals__c>();
        Goals__c GoalsTest1=new Goals__c(Campaign__c=campaignTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23);
        Goals__c GoalsTest2=new Goals__c(Campaign__c=campaignTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        goalsList.add(GoalsTest1);
        goalsList.add(GoalsTest2);
        insert goalsList;
        
        goalsList[0].Rate__c = 100;
        goalsList[1].Target_Number__c = 500;
        goalsList[0].Product__c = 'Continuity';
        goalsList[1].Product__c = 'Number';
        update goalsList;
        
        EventTriggerHelper ht = new EventTriggerHelper();
        List<Campaign> c = new List<Campaign>();
        c.add(CampaignTest1);
        Set<Id> pId = new Set<Id>();
        pId.add(ProgramTestVar.id);
        
        ht.UpdateProgramEventCampaignRollup(c, pId);
        
        Test.stopTest();    
    }
    
    public static testMethod void EventTriggerHelperCoverageForEvent()
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
        
        goalsList[0].Rate__c = 100;
        goalsList[1].Target_Number__c = 500;
        goalsList[0].Product__c = 'Continuity';
        goalsList[1].Product__c = 'Number';
        update goalsList;
        
        Test.stopTest();    
    }
    
    public static testMethod void EventTriggerHelperCoverageForEventLocation()
    {
        Test.startTest();
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location');
        insert EventTest2;
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id);    
        insert EventLocationTest2;
        
        List<Goals__c> goalsList = new List<Goals__c>();
        Goals__c GoalsTest1=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23);
        Goals__c GoalsTest2=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        goalsList.add(GoalsTest1);
        goalsList.add(GoalsTest2);
        insert goalsList;
        
        goalsList[0].Rate__c = 100;
        goalsList[0].Product__c = 'Continuity';
        goalsList[1].Product__c = 'Number';
        update goalsList;
        
        Test.stopTest();    
    }
    
    public static testMethod void EventTriggerHelperCoverageForEventCancellation()
    {
        Test.startTest();
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location');
        insert EventTest2;
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id);    
        insert EventLocationTest2;
        
        List<Goals__c> goalsList = new List<Goals__c>();
        Goals__c GoalsTest1=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23);
        Goals__c GoalsTest2=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        goalsList.add(GoalsTest1);
        goalsList.add(GoalsTest2);
        insert goalsList;
        
        EventTest2.Status = 'Cancelled';
        EventTest2.Cancellation_Reason__c = 'Act Of God';
        update EventTest2;
        
        Test.stopTest();    
    }
    
    public static testMethod void deleteCampaignScenario()
    {
        Test.startTest();
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event');
        insert EventTest2;
        
        List<Goals__c> goalsList = new List<Goals__c>();
        Goals__c GoalsTest1=new Goals__c(Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23);
        goalsList.add(GoalsTest1);
        insert goalsList;
        
        
        
        delete EventTest2;
        
        Test.stopTest();
    }
    
    
    public static testMethod void EventTriggerHelperCoverageForEventLocationCancellation()
    {
        Test.startTest();
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location');
        insert EventTest2;
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id);    
        insert EventLocationTest2;
        
        List<Goals__c> goalsList = new List<Goals__c>();
        Goals__c GoalsTest1=new Goals__c(Campaign__c=EventLocationTest2.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23);
        goalsList.add(GoalsTest1);
        insert goalsList;
        
        Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventLocationTest2.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5, Volunteer_Role__c='Developer', Start_Time__c = '11:00 AM', End_Time__c = '11:30 AM');
        insert VSTest1;
        
        EventLocationTest2.Status = 'Cancelled';
        EventLocationTest2.Cancellation_Reason__c = 'Act Of God';
        update EventLocationTest2;
        
        Test.stopTest();    
    }
}