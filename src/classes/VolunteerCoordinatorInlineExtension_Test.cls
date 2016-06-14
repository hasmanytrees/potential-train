@isTest(seeAllData=true)
    private class VolunteerCoordinatorInlineExtension_Test
    {   
    
            public static testMethod void VolunteerCoordinaitor_test() 
        {
            test.startTest();
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            
            list<User> lstUser = new list<User>();
            User user1 = new User();
            user1.Username= 'testusertest1@test.com';
            user1.Email= 'test@test.com';
            user1.Lastname= 'user';
            user1.Firstname= 'test1';
            user1.Alias= 'test';
            user1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            user1.TimeZoneSidKey= 'GMT';
            user1.LocaleSidKey= 'en_US';
            user1.EmailEncodingKey= 'ISO-8859-1';
            user1.LanguageLocaleKey= 'en_US';
            user1.Authorized_Campaign_Owner__c=true;
            user1.UserPermissionsMobileUser = true;
            user1.isActive = true;
            insert user1;
            lstUser.add(user1);
            
              User user6 = new User();
            user6.Username= 'testusertest66@test.com';
            user6.Email= 'test6@test.com';
            user6.Lastname= 'user';
            user6.Firstname= 'test66';
            user6.Alias= 'test';
            user6.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            user6.TimeZoneSidKey= 'GMT';
            user6.LocaleSidKey= 'en_US';
            user6.Managerid = userinfo.getuserid();
            user6.EmailEncodingKey= 'ISO-8859-1';
            user6.LanguageLocaleKey= 'en_US';
            user6.Authorized_Campaign_Owner__c=true;
            user6.UserPermissionsMobileUser = true;
            user6.isActive = true;
            insert user6;
            lstUser.add(user6);
        
            Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Alaska', ZIP_Code__c='400059', Country__c='United States');
            insert Ven; // Initializing Venue Record
            
            Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1',status ='Draft',
            type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Cancellation_Reason__c = 'test Cancel');
            insert EventTest1;
            
            System.assertEquals('Radio',EventTest1.EVE_Channel__c );
            
            Campaign EventLocationTest=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest1.id,
            Venue__c = ven.id, Volunteer_Coordinator__c = null, //Event_Volunteer_Manager__c = user1.id, ownerid = user1.id, Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true,
            Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel');    
            insert EventLocationTest;
            
            System.assertEquals(23,EventLocationTest.Estimated_Audience_Size__c);
            
            //pw_ccpro__CountryObject__c oCountryISOCode= new pw_ccpro__CountryObject__c(Name = 'United States Of America', pw_ccpro__IsoCode_2__c = 'US', pw_ccpro__IsoCode_3__c = 'USA' );
            //insert oCountryISOCode;
            
            //pw_ccpro__State__c oStateISOCode= new pw_ccpro__State__c(Name = 'Alaska', pw_ccpro__IsoCode__c = 'AK', pw_ccpro__Country__c = oCountryISOCode.id );
            //insert oStateISOCode;
            
            Volunteer_Coordinator_Assignment__c vca = new Volunteer_Coordinator_Assignment__c(Name = '13762784634',CoOrdinator__c = 'Subhojit Chakraborty' ,States__c = 'all',Role__c = 'Volunteer Coordinator' );
            insert vca;
            Volunteer_Coordinator_Assignment__c vca1 = new Volunteer_Coordinator_Assignment__c(Name = '1090909089',CoOrdinator__c = 'Subhojit Chakraborty' ,States__c = 'all',Role__c = 'Manager' );
            insert vca1;
            
            System.assertEquals( 'Manager',vca1.Role__c );
            
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(EventLocationTest);
            
            VolunteerCoordinatorInlineExtension fvcle=new VolunteerCoordinatorInlineExtension(sc);  
            fvcle.sSelectedVC = user6.id;
            fvcle.showInput();
            fvcle.save();      
            test.StopTest();
            
        }
        
   }