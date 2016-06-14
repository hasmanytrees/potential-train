/*****************************************************************************************
    Name             : CampaignSlotDashBoardController_Test
    Description      : Test class for Page Controller CampaignSlotDashBoardController           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
    @isTest(seeAllData=true)
    public class CampaignSlotDashBoardController_Test
{
    //Creating Test data     
   
        private static void createTestData()
    {
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();

        List<Campaign> listEventLocationTest=new List<Campaign>();
        List<Volunteer_Shift__c> listVShiftTest=new List<Volunteer_Shift__c>();
        List<Account> listAccount=new List<Account>();
        Set<Id> setVShiftId=new Set<Id>();
        Campaign eventLocationTest1=new Campaign(recordtypeId=Utility.getRecordtype('Event Location','Campaign'),Name='Event Location1',StartDate=System.today().addDays(3),
        Status='Draft',EndDate=system.today().addDays(10),ownerId=Userinfo.getUserId(),Override_Venue_Conflict__c=true);
        
        Campaign eventLocationTest2=new Campaign(recordtypeId=Utility.getRecordtype('Event Location','Campaign'),Name='Event Location2',StartDate=System.today().addDays(3),
        Status='Draft',EndDate=system.today().addDays(10),ownerId=Userinfo.getUserId(),Override_Venue_Conflict__c=true);

        listEventLocationTest.add(eventLocationTest1);
        listEventLocationTest.add(eventLocationTest2);
        insert listEventLocationTest;
        
        System.assertEquals('Draft',eventLocationTest1.Status);
        System.assertEquals('Draft',eventLocationTest2.Status);
        
        for(Campaign campaignVar: listEventLocationTest)
        listVShiftTest.add(new Volunteer_Shift__c(EventLocation__c=campaignVar.Id,    Initial_Number_Of_Slots_Requested__c=2));
        
        insert listVShiftTest;
        
        Account account1=new Account(recordtypeId=Utility.getRecordtype('Partner','Account'),Name='Test1',Business_Email__c='test1@tes.com');
        Account account2=new Account(recordtypeId=Utility.getRecordtype('Partner','Account'),Name='Test2',Business_Email__c='test2@tes.com');
        listAccount.add(account1);
        listAccount.add(account2);
        insert listAccount;
        
        System.assertEquals('test2@tes.com',listAccount[1].Business_Email__c);
        
        List<Volunteer_Slot__c> listVSlot=[select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c =:listVShiftTest[0].Id];
        
        for(Integer i=0;i<listAccount.size();i++)
        {
            listVSlot[i].Volunteer__c=listAccount[i].Id;
            listVSlot[i].Status__c='Approved';
        }
        update listVSlot;            
     }

        public static testMethod void testCampaignDashboardChart()
    {
        Test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        createTestData();  //Creating Event Location with related Volunteer Slot and filling them with volunteer.
        
        //Campaign oCampaign=new Campaign();
                
        CampaignSlotDashBoardController controller=new CampaignSlotDashBoardController ();
      //  delete [select Id from Campaign where OwnerId=:UserInfo.getUserId()]; //Deleting the Event Location.
        controller=new CampaignSlotDashBoardController (); //Covering the message part will shows No Event in Coming 14 Days
        controller.getPieData();
        Test.stopTest();

    }

}