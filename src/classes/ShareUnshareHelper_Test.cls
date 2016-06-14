@isTest(seeAllData=true)
    private class ShareUnshareHelper_Test
    { 
        public static testMethod void ShareUnshareHelper_true_test()
        {  
            test.startTest();
                List<User> listUser = new list<User>();
                User user = new User();
                user.Username= 'testusertest2323@test.com';
                user.Email= 'test23236@test.com';
                user.Lastname= 'user';
                user.Managerid = userinfo.getuserid();
                user.Firstname= 'test2323';
                user.Alias= 'test';
                user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
                user.TimeZoneSidKey= 'GMT';
                user.LocaleSidKey= 'en_US';
                user.EmailEncodingKey= 'ISO-8859-1';
                user.LanguageLocaleKey= 'en_US';
                user.Authorized_Campaign_Owner__c=true;
                user.UserPermissionsMobileUser = true;
                insert user;
                system.assertEquals('testusertest2323@test.com',user.Username);
        
                Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
                insert Agency;
                system.assertEquals('Test',Agency.Name);
                 
                Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
                insert ProgramTestVar;  
                system.assertEquals('Test Program',ProgramTestVar.Name);
                          
                List<Campaign> listCampaign = new List<Campaign>();        
                Campaign CampaignTest1=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), status = 'Completed', Name = 'Test Campaign1', type = 'Acquisition',endDate = date.today(),
                Launch_Date__c = date.today(), Program__c = ProgramTestVar.id,Project_Manager__c = user.id, ownerid = user.id,StartDate = date.today(),Agency__c = Agency.id);//Overview__c = 'abcd',
                Campaign CampaignTest2=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), Launch_Date__c = System.today(), status = 'Completed', Name = 'Test Campaign2', type = 'Acquisition', endDate = date.today(),
                Program__c = ProgramTestVar.id,Project_Manager__c = user.id, ownerid = user.id,StartDate = date.today(), Agency__c = Agency.id); //Overview__c = 'abcd',
                listCampaign.add(CampaignTest1);
                listCampaign.add(CampaignTest2);
                insert listCampaign;
                system.assertEquals('Completed',CampaignTest1.status);
           
                List<Contact> listContact = new List<Contact>();        
                Contact ContactTest1=new Contact(ownerid = user.id, accountid = Agency.id, LastName = 'test LastName1');
                Contact ContactTest2=new Contact(ownerid = user.id, accountid = Agency.id, LastName = 'test LastName2');
                listContact.add(ContactTest1);
                listContact.add(ContactTest2);
                insert listContact; 
                          
                //---creating Deliverable record start---------      
                List<Deliverable__c> listDeliverable=new List<Deliverable__c>();
                Deliverable__c DeliverableTest1=new Deliverable__c(RecordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'), Campaign__c = listCampaign[0].id, 
                Name = 'Test Deliverable1',Status__c ='Confirmed',Type__c= 'tooling',Agency__c = Agency.id,Do_Not_Auto_Populate_Tasks__c=false );
                Deliverable__c DeliverableTest2=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'),Campaign__c = listCampaign[1].id, 
                Name = 'Test Deliverable2', Status__c ='Confirmed', Type__c= 'Inventory',Agency__c = Agency.id,Do_Not_Auto_Populate_Tasks__c=false);
                listDeliverable.add(DeliverableTest1);
                listDeliverable.add(DeliverableTest2);
                insert listDeliverable;
                system.assertEquals('Confirmed',DeliverableTest2.Status__c);
                //---creating Deliverable record end------------    
         
                Set<Id> setCampaignId = new set<id>();
                                      
                for(Campaign c:listCampaign)
                {        
                    setCampaignId.add(c.id);
                }
            
                ShareUnshareHelper shareUnsharVar = new ShareUnshareHelper(); //Calling class n methods
                ShareUnshareHelper.shareUnShareCampaign(listCampaign,true);
                ShareUnshareHelper.shareUnshareDeliverable(listDeliverable,setCampaignId,true);
            
            Test.Stoptest();
        }
        
    
        public static testMethod void ShareUnshareHelper_False_test() 
        { 
            test.startTest();
                //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
          
                List<User> listUser = new list<User>();
                User user = new User();
                user.Username= 'testusertest2323@test.com';
                user.Email= 'test23236@test.com';
                user.Lastname= 'user';
                user.Managerid = userinfo.getuserid();
                user.Firstname= 'test2323';
                user.Alias= 'test';
                user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
                user.TimeZoneSidKey= 'GMT';
                user.LocaleSidKey= 'en_US';
                user.EmailEncodingKey= 'ISO-8859-1';
                user.LanguageLocaleKey= 'en_US';
                user.Authorized_Campaign_Owner__c=true;
                user.UserPermissionsMobileUser = true;
                insert user;
                system.assertEquals('testusertest2323@test.com',user.Username);
            
                Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
                insert Agency;
                system.assertEquals('Test',Agency.Name);
             
                Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
                insert ProgramTestVar;  
                system.assertEquals('Test Program',ProgramTestVar.Name);
                              
                List<Campaign> listCampaign = new List<Campaign>();        
                Campaign CampaignTest1=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), Launch_Date__c = System.today(), Overview__c = 'abcd', status = 'Completed', Name = 'Test Campaign1', type = 'Acquisition',endDate = date.today(),
                Program__c = ProgramTestVar.id,Project_Manager__c = user.id, ownerid = user.id,StartDate = date.today(),Agency__c = Agency.id);    // 
                Campaign CampaignTest2=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), Launch_Date__c = System.today(), status = 'Completed', Name = 'Test Campaign2', type = 'Acquisition', endDate = date.today(),
                Program__c = ProgramTestVar.id,Project_Manager__c = user.id, ownerid = user.id,StartDate = date.today(),Overview__c = 'abcd', Agency__c = Agency.id); //
                listCampaign.add(CampaignTest1);
                listCampaign.add(CampaignTest2);
                insert listCampaign;
                system.assertEquals('Completed',CampaignTest1.status);
                       
                Set<Id> setCampaignId = new set<id>();        
                             
                List<Deliverable__c> listDeliverable=new List<Deliverable__c>();
                Deliverable__c DeliverableTest1=new Deliverable__c(RecordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'), Campaign__c = listCampaign[0].id, 
                Name = 'Test Deliverable1',Status__c ='Confirmed',Type__c= 'tooling',Agency__c = Agency.id,Do_Not_Auto_Populate_Tasks__c=false );
                Deliverable__c DeliverableTest2=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'),Campaign__c = listCampaign[1].id, 
                Name = 'Test Deliverable2', Status__c ='Confirmed', Type__c= 'Inventory',Agency__c = Agency.id,Do_Not_Auto_Populate_Tasks__c=false);
                listDeliverable.add(DeliverableTest1);
                listDeliverable.add(DeliverableTest2);
                insert listDeliverable;
                system.assertEquals('Confirmed',DeliverableTest2.Status__c);
                           
                for(Campaign c:listCampaign)
                {        
                setCampaignId.add(c.id);
                }  
                   
                List<Contact> listContact = new List<Contact>();        
                Contact ContactTest1=new Contact(ownerid = user.id, accountid = Agency.id, LastName = 'test LastName1');
                Contact ContactTest2=new Contact(ownerid = user.id, accountid = Agency.id, LastName = 'test LastName2');
                listContact.add(ContactTest1);
                listContact.add(ContactTest2);
                insert listContact; 
                 
                System.runAs(user)
                {
                  //  UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'Partner' limit 1]; 
                    
                    User user1 = new User();
                    user1.Username= 'testuser1test2323@test.com';
                    user1.Email= 'test23236@test.com';
                    user1.Lastname= 'user1';
                 //   user1.UserRoleId = ur.Id;
                    user1.Managerid = userinfo.getuserid();
                    user1.Firstname= 'test2323';
                    user1.Alias= 'test';
                    user1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'].Id;
                    user1.TimeZoneSidKey= 'GMT';
                    user1.LocaleSidKey= 'en_US';
                    user1.EmailEncodingKey= 'ISO-8859-1';
                    user1.LanguageLocaleKey= 'en_US';
                    user1.Authorized_Campaign_Owner__c=true;
                    user1.UserPermissionsMobileUser = true;
                    user1.ContactId = listContact[0].Id;
                    insert user1;
                    
                    CampaignShare oCampaignShare = new CampaignShare(UserOrGroupId = user1.id,CampaignId = listCampaign[0].Id);
                    
                    ShareUnshareHelper.shareUnshareDeliverable(listDeliverable,setCampaignId,False);
                }
                //---creating Deliverable record start---------      
                
                //---creating Deliverable record end------------       
                    
                
                ShareUnshareHelper shareUnsharVar = new ShareUnshareHelper();
                ShareUnshareHelper.shareUnShareCampaign(listCampaign,False);
                ShareUnshareHelper.shareUnshareDeliverable(listDeliverable,setCampaignId,False);
            test.StopTest();
       }
    
    
 }