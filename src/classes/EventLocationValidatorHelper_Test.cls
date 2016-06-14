@isTest(seeAllData=true)
private class EventLocationValidatorHelper_Test
{  

            public static testMethod void testEventLocationValidatorHelper_false() 
        {
         test.starttest(); 
         //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
         boolean bIsUpdate = false;
    
         //  ---------------
        User user19 = new User();
        user19.Username= 'testusertest19@test.com';
        user19.Email= 'test19@test.com';
        user19.Lastname= 'user';
        user19.Firstname= 'test19';
        user19.Alias= 'test';
        user19.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user19.TimeZoneSidKey= 'GMT';
        //   user19.Managerid = user.id;
        user19.LocaleSidKey= 'en_US';
        user19.EmailEncodingKey= 'ISO-8859-1';
        user19.LanguageLocaleKey= 'en_US';
        user19.Authorized_Campaign_Owner__c=true;
        user19.UserPermissionsMobileUser = true;
       insert user19;
        //----------------  
        system.assertEquals('testusertest19@test.com',user19.Username);        
        
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar;// Initializing Prgram record
        system.assertEquals('Test Program',ProgramTestVar.Name);
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        system.assertEquals('Venue test',ven.Name);      
        
        List<Campaign> listEvent=new List<Campaign>();
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1',  status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');//EVE_Origin__c = EventOrigin.id,
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');
        listEvent.add(EventTest1);
        listEvent.add(EventTest2);
        insert listEvent; // Initializing Event Record
        
        List<Campaign> listEventLocation=new List<Campaign>();
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc1', status ='Scheduled', EVE_End_Time__c = '09:30 AM',
        Event__c = EventTest1.id,Venue__c = ven.id, Volunteer_Coordinator__c = user19.id, ownerid =user19.id,//EVE_Volunteer_Manager__c = user19.id,EVE_Start_Time__c = '09:15 AM', 
        Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel',StartDate = System.today().addDays(-33),EndDate = System.today().addDays(0) );
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,EVE_End_Time__c = '09:30 AM',
        Venue__c = ven.id, Volunteer_Coordinator__c = null, //EVE_Volunteer_Manager__c = user19.id, ownerid = user19.id, Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true,EVE_Start_Time__c = '09:15 AM', 
        Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel',StartDate = System.today().addDays(0),EndDate = System.today().addDays(31));    
        
        listEventLocation.add(EventLocationTest1);
        listEventLocation.add(EventLocationTest2);
        insert listEventLocation;
        system.assertEquals('Scheduled',EventLocationTest2.status);
    
           List<Campaign> listNewCampaign=new List<Campaign>();
            Map<Id,Campaign> mapNewCampaign=new Map<Id,Campaign>();
            
            for(Campaign c:listEventLocation){
            mapNewCampaign.put(c.id,c);
            }
            
            EventLocationValidatorHelper EvLocValHelpVar = new EventLocationValidatorHelper();
        
            try{   EventLocationValidatorHelper.checkIfEventUsedBefore(listEventLocation,bIsUpdate,mapNewCampaign);}
            catch (Exception e) 
            {
            }            
            
          
            
       
        test.stoptest();
        }
    
            public static testMethod void testEventLocationValidatorHelper_true()
        {
        test.starttest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        boolean bIsUpdate = true;
    
     //  ---------------
        User user19 = new User();
        user19.Username= 'testusertest19@test.com';
        user19.Email= 'test19@test.com';
        user19.Lastname= 'Campaign';
        user19.Firstname= 'Test';
        user19.Alias= 'test';
        user19.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user19.TimeZoneSidKey= 'GMT';
      //   user19.Managerid = user.id;
        user19.LocaleSidKey= 'en_US';
        user19.EmailEncodingKey= 'ISO-8859-1';
        user19.LanguageLocaleKey= 'en_US';
        user19.Authorized_Campaign_Owner__c=true;
        user19.UserPermissionsMobileUser = true;
       insert user19;
        //----------------  
        system.assertEquals('testusertest19@test.com',user19.Username);        
        
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar;// Initializing Prgram record
        system.assertEquals('Test Program',ProgramTestVar.Name);
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        system.assertEquals('Venue test',ven.Name);     
             
        List<Campaign> listEvent=new List<Campaign>();
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1',  status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel'); //EVE_Origin__c = EventOrigin.id,
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');
        listEvent.add(EventTest1);
        listEvent.add(EventTest2);
        insert listEvent; // Initializing Event Record
        system.assertEquals('Draft',EventTest1.status);
        
        List<Campaign> listEventLocation=new List<Campaign>();
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc1', status ='Scheduled', 
        Event__c = EventTest1.id,Venue__c = ven.id, Volunteer_Coordinator__c = user19.id, ownerid =user19.id,//EVE_Volunteer_Manager__c = user19.id, EVE_End_Time__c = '09:30 AM',EVE_Start_Time__c = '09:15 AM', 
        Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel',StartDate = System.today().addDays(-31),EndDate = System.today().addDays(0) );
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, //EVE_Volunteer_Manager__c = user19.id, ownerid = user19.id, Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true,EVE_End_Time__c = '09:30 AM',EVE_Start_Time__c = '09:15 AM', 
        Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel',StartDate = System.today().addDays(0),EndDate = System.today().addDays(31), Override_Venue_Conflict__c = false);    
        
        listEventLocation.add(EventLocationTest1);
        listEventLocation.add(EventLocationTest2);
        insert listEventLocation;
        system.assertEquals('Scheduled',EventLocationTest2.status);    
  
        Map<Id,Campaign> mapNewCampaign=new Map<Id,Campaign>();
        Map<String,Campaign>  mapStringToCampaign = new Map<String,Campaign> ();
        mapStringToCampaign.put('Test Campaign', EventLocationTest1);
        
        for(Campaign c:listEventLocation){
        mapNewCampaign.put(c.id,c);
        }
    
      EventLocationValidatorHelper EvLocValHelpVar = new EventLocationValidatorHelper();
    
     EventLocationValidatorHelper.checkIfEventUsedBefore(listEventLocation,bIsUpdate,mapNewCampaign);
     EventLocationValidatorHelper.checkIfEventUsedBefore(listEventLocation,false,mapNewCampaign);
     EventLocationValidatorHelper.updateVolunteerCoordinatorLookup(mapStringToCampaign);
    test.stoptest();
    }
   
}