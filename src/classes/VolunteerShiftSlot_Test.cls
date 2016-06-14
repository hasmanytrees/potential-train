/*****************************************************************************************
    Name             : VolunteerShiftSlot_Test
    Description      : Test Class to cover both Volunteer Slot and Volunteer Shift scenarios               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAlldata=true)
global class VolunteerShiftSlot_Test 
{      

        private static List<Volunteer_Shift__c> createTestData()
    {
            //Create Data
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'),Name='Test Event',Status='Draft');
            insert campaignTestVar;
            
            System.assertEquals('Draft',campaignTestVar.Status);
            
            List<Volunteer_Shift__c> listVSTest=new List<Volunteer_Shift__c>();
            
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=campaignTestVar.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5, Volunteer_Role__c='Developer', Start_Time__c = '11:00 AM', End_Time__c = '11:30 AM');
            Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=campaignTestVar.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6, Volunteer_Role__c='Coach',Start_Time__c = '11:00 AM', End_Time__c = '11:30 AM');
            listVSTest.add(VSTest1);
            listVSTest.add(VSTest2);
            return listVSTest;
    }
    
    private static testMethod void updateVolunteerShift()
    {
            //Create Data
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'),Name='Test Event',Status='Draft');
            insert campaignTestVar;
            
            System.assertEquals('Draft',campaignTestVar.Status);
            
            List<Volunteer_Shift__c> listVSTest=new List<Volunteer_Shift__c>();
            
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=campaignTestVar.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5, Volunteer_Role__c='Developer', Start_Time__c = '11:00 AM', End_Time__c = '11:30 AM');
            insert VSTest1;
            VSTest1.Start_Time__c = '09:00 AM';
            update VSTest1;
    }
        public static testMethod void createVolunteerShift()
    {
    
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            Map<Id,Volunteer_Slot__c> mapNewVSlot = new Map<Id,Volunteer_Slot__c>();
            Map<Id,Volunteer_Slot__c> mapOldVSlot = new Map<Id,Volunteer_Slot__c>();
            
            Map<Id,Volunteer_Shift__c> mapVshift = new Map<Id,Volunteer_Shift__c>();
        
            VolunteerShiftHelper vsHelper=new VolunteerShiftHelper();//Covering Constructor
           
            VolunteerShiftHandler vsHandler=new VolunteerShiftHandler();//Covering Constructor
            VolunteerSlotTriggerHandler vSlotHandler=new VolunteerSlotTriggerHandler ();//Covering Constructor
            VolunteerSlotTriggerHelper vSlotHelper = new VolunteerSlotTriggerHelper();
            VolunteerSlotValidationHelper vSlotValHelper = new VolunteerSlotValidationHelper();
           
           
            Set<Id> setVShiftIds=new Set<Id> ();
            List<Volunteer_Shift__c> listVSTest=createTestData();
            insert listVSTest;   //Inserting Volunteer Shifts records and It will create Volunteer Slot records using trigger.
            Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
            insert volunteerTest;   //Creating Volunteer
            
            for(Volunteer_Shift__c vsVar: listVSTest)
            {setVShiftIds.add(vsVar.Id);
            mapVshift.put(vsVar.Id,vsVar);            
            }
             VolunteerShiftHelper.updateVolunteerSlots(mapVshift);
            test.startTest();
            List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c, Volunteer_Shift__c  from Volunteer_Slot__c where Volunteer_Shift__c = :listVSTest[0].Id]; //Getting newly created Volunteer Slots
          
           for(Volunteer_Slot__c lvs: listVSlotTest)
           {
           mapOldVSlot.put(lvs.id, lvs);
           }
           
            listVSlotTest[0].Volunteer__c=volunteerTest.Id;
            listVSlotTest[0].Status__c='Approved';
            
            update listVSlotTest[0];
            listVSlotTest[1].Volunteer__c=volunteerTest.Id;
            listVSlotTest[1].Status__c='Approved';
            
            update listVSlotTest[1];
            
              System.assertEquals('Approved',listVSlotTest[1].Status__c );
              
            Volunteer_Slot__c vSlotTest=new Volunteer_Slot__c(Volunteer_Shift__c=listVSTest[0].Id,Volunteer__c=volunteerTest.Id,Status__c='Approved');
            insert vSlotTest;
            mapNewVSlot.put(listVSlotTest[0].id, listVSlotTest[0]);
            mapNewVSlot.put(listVSlotTest[1].id, listVSlotTest[1]);
            // mapNewVSlot.put(vSlotTest.id, vSlotTest);
            VolunteerSlotTriggerHelper.checkDuplicateVolunteer(listVSlotTest,mapOldVSlot, mapOldVSlot, true );
            VolunteerSlotValidationHelper.checkForDuplicateVolunteer(listVSlotTest);
            try
            {    
                upsert listVSlotTest; //Upserting Volunteer Slot records to run Duplicate Volunteer check.
            } 
            catch(DMLException ex)
            {
            }
            test.stopTest();
    }

}