/*****************************************************************************************
    Name             : AddEditInfluencerController_Test
    Description      : Test class to cover scenario of New Influencer Creation/updation/Deletion           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Vibhuti               30/10/2014            Created
Vibhuti               29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
private class AddEditInfluencerController_Test 
{
    
    private static String sEventLocationId;
     
    
    // Create Test Data to be used in AddEditInfluencer Coverage class
    private static List<Influencer__c> createTestData()
    {   
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
    
        List<Influencer__c>  lstAllsourceCode_influencer = new List<Influencer__c>();    
        Influencer__c oInfluencer = new Influencer__c();
        
        AddEditInfluencerController addEdit = new AddEditInfluencerController();
        addEdit.sNoRecordsInInfuencerTableErrorMessage = 'NoRecordsInInfuencerTableErrorMessage';
        addEdit.oInfluencerRecord = oInfluencer;
        addEdit.lstAddNewInfluencer = lstAllsourceCode_influencer;
        
        User user = new User();
        user.Username= 'testusertest2@test.com';
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
        //user.UserPermissionsMobileUser = true;
        insert user;
        
        system.assertEquals(true,user.Authorized_Campaign_Owner__c);
        
        Campaign oCampaignTestVar = new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'),Name='Test Event',Status='Draft',ownerId=user.Id);
        insert oCampaignTestVar; 
        sEventLocationId = oCampaignTestVar.Id;
        Source_Code__c SCode = new Source_Code__c(Campaign__c = oCampaignTestVar.id );
        insert Scode;
        
        List<Account> lstAccountTest=new List<Account>();
        Account oAccntTest=new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test',Business_Email__c='test@test.com');
        Account oAccntTest1=new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test1',Business_Email__c='test@test.com');
        Account oAccntTest2=new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test2',Business_Email__c='test@test.com');
        lstAccountTest.add(oAccntTest);
        lstAccountTest.add(oAccntTest1);
        lstAccountTest.add(oAccntTest2);
        insert  lstAccountTest;
        
        system.assertEquals('Test',oAccntTest.Name);
        
        Influencer__c oInfluencerTest1=new Influencer__c(Influencer__c = oAccntTest.id, Campaign__c = oCampaignTestVar.id, Credit__c=false, Source_Code__c = SCode.id );
        Influencer__c oInfluencerTest2=new Influencer__c(Influencer__c = oAccntTest1.id, Campaign__c = oCampaignTestVar.id, Credit__c=false, Source_Code__c = SCode.id );
        Influencer__c oInfluencerTest3=new Influencer__c(Influencer__c = oAccntTest2.id, Campaign__c = oCampaignTestVar.id, Credit__c=true, Source_Code__c = SCode.id);
        Influencer__c oInfluencerTest4=new Influencer__c(Influencer__c = oAccntTest2.id, Campaign__c = oCampaignTestVar.id, Credit__c=false, Source_Code__c = SCode.id);
        Influencer__c oInfluencerTest5=new Influencer__c(Influencer__c = oAccntTest2.id, Campaign__c = oCampaignTestVar.id, Credit__c=true, Source_Code__c = SCode.id);
        
        lstAllsourceCode_influencer.add(oInfluencerTest1);
        lstAllsourceCode_influencer.add(oInfluencerTest2);
        lstAllsourceCode_influencer.add(oInfluencerTest3);
        lstAllsourceCode_influencer.add(oInfluencerTest4);
        lstAllsourceCode_influencer.add(oInfluencerTest5);
        
        return lstAllsourceCode_influencer;        
    }
    
    //test method for coverage of whole AddEditInfluencerController class
    static testmethod void InfluencerUnique_test()
    {   
        test.startTest();
            //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            List<Influencer__c>  lstAllsourceCode_influencer = createTestData(); 
            
            integer i = 0;
            
            for(i = 0; i < lstAllsourceCode_influencer.size() - 1; i++)
            {
                insert lstAllsourceCode_influencer[i];// inserts Influencer records under Event Location
            }
            
            Account oAccntTest=new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test',Business_Email__c='test@test.com');
            insert oAccntTest;
            system.assertEquals('Test',oAccntTest.Name);
            PageReference pageRef=Page.AddEditInfluencer;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('eventLocationId',sEventLocationId);//passing id of Parent Event Location record to class
            AddEditInfluencerController addInfluencerRef = new AddEditInfluencerController();
            
            addInfluencerRef.AddEditInfluencer(); 
            addInfluencerRef.saveInfluencerTable();
            addInfluencerRef.iRowToRemove=addInfluencerRef.lstInfluencerWrapper[0].iIndex;
            addInfluencerRef.deleteInfluencer(); // covering method deleteInfluencer
            
            // addInfluencerRef.saveInfluencerTable();
            addInfluencerRef.AddNewInfluencer();    // covering method AddNewInfluencer
            addInfluencerRef.AddNewInfluencer();
            addInfluencerRef.iRowToRemove=addInfluencerRef.lstInfluencerWrapper[addInfluencerRef.lstInfluencerWrapper.size()-1].iIndex;
            addInfluencerRef.deleteInfluencer(); 
            PageReference pgRef=addInfluencerRef.GoBacktoEventLocation();// covering method GoBacktoEventLocation
            
            Influencer__c oInfluencerTest1=new Influencer__c (Influencer__c = oAccntTest.id, Campaign__c = sEventLocationId, Credit__c=false);
            addInfluencerRef.lstInfluencerWrapper[addInfluencerRef.lstInfluencerWrapper.size()-1]=new AddEditInfluencerController.InfluencerWrapper(oInfluencerTest1,addInfluencerRef.iIndexValue ++);
                
            try{
            pageRef=addInfluencerRef.saveInfluencerTable();
            }
            catch(Exception ex){}
            AddEditInfluencerController addInfluencerRef2=new AddEditInfluencerController();
            addInfluencerRef2.saveInfluencerTable();  
            AddEditInfluencerController addInfluencerRef3=new AddEditInfluencerController();
            Influencer__c InfluencerTest2=new Influencer__c (Influencer__c = oAccntTest.id, Campaign__c = sEventLocationId, Credit__c=true);
            addInfluencerRef3.lstInfluencerWrapper.add(new AddEditInfluencerController.InfluencerWrapper(InfluencerTest2,0));
            addInfluencerRef3.saveInfluencerTable();  
            AddEditInfluencerController addInfluencerRef4=new AddEditInfluencerController();
            Influencer__c InfluencerTest3=new Influencer__c (Influencer__c = oAccntTest.id, Campaign__c = sEventLocationId, Credit__c=true);
            addInfluencerRef4.lstInfluencerWrapper.add(new AddEditInfluencerController.InfluencerWrapper(InfluencerTest3,1));
                    
            addInfluencerRef4.saveInfluencerTable();     // covering method saveInfluencerTable
            Influencer__c InfluencerTest4=new Influencer__c (Influencer__c = oAccntTest.id, Campaign__c = sEventLocationId, Credit__c=true);
            addInfluencerRef4.lstInfluencerWrapper.add(new AddEditInfluencerController.InfluencerWrapper(InfluencerTest4,2));
            addInfluencerRef4.saveInfluencerTable();
            
            addInfluencerRef4.saveInfluencerTable();  
            addInfluencerRef4.lstEditInfluencer.add(InfluencerTest3);  
            addInfluencerRef4.cancelInfluencerTable();    // covering method cancelInfluencerTable
            addInfluencerRef4.refreshPage();
             
        test.StopTest();
     }  
     
     //test method for coverage of whole AddEditInfluencerController class
    static testmethod void InfluencerUniquecasetwo_test()
    {   
        test.startTest();
            //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            List<Influencer__c>  lstAllsourceCode_influencer = createTestData(); 
            
            integer i = 0;
            
            for(i = 0; i < lstAllsourceCode_influencer.size() - 1; i++)
            {
                insert lstAllsourceCode_influencer[i];// inserts Influencer records under Event Location
            }
            
            Account oAccntTest=new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test',Business_Email__c='test@test.com');
            insert oAccntTest;
            system.assertEquals('Test',oAccntTest.Name);
            PageReference pageRef=Page.AddEditInfluencer;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('eventLocationId',sEventLocationId);//passing id of Parent Event Location record to class
            AddEditInfluencerController addInfluencerRef4= new AddEditInfluencerController();
            
            Influencer__c InfluencerTest4=new Influencer__c (Influencer__c = oAccntTest.id, Campaign__c = sEventLocationId, Credit__c=true);
            addInfluencerRef4.lstInfluencerWrapper.add(new AddEditInfluencerController.InfluencerWrapper(InfluencerTest4,0));
            addInfluencerRef4.saveInfluencerTable();
            addInfluencerRef4.lstInfluencerWrapper= new List<AddEditInfluencerController.InfluencerWrapper> ( ) ;
            addInfluencerRef4.lstInfluencerWrapper.add(new AddEditInfluencerController.InfluencerWrapper(InfluencerTest4,0));
            addInfluencerRef4.lstInfluencerWrapper[0].oInfluencerReference.Credit__c = false ;  
            addInfluencerRef4.saveInfluencerTable();         
            
            addInfluencerRef4.lstInfluencerWrapper= new List<AddEditInfluencerController.InfluencerWrapper> ( ) ;
            addInfluencerRef4.lstInfluencerWrapper.add(new AddEditInfluencerController.InfluencerWrapper(InfluencerTest4,0));
            addInfluencerRef4.lstInfluencerWrapper[0].oInfluencerReference.Credit__c = true ; 
            addInfluencerRef4.lstInfluencerWrapper.add(new AddEditInfluencerController.InfluencerWrapper(InfluencerTest4,0));
            addInfluencerRef4.saveInfluencerTable(); 
            addInfluencerRef4.lstInfluencerWrapper = new List<AddEditInfluencerController.InfluencerWrapper> ( ) ;
            addInfluencerRef4.saveInfluencerTable(); 
            addInfluencerRef4.cancelInfluencerTable();    // covering method cancelInfluencerTable
            addInfluencerRef4.refreshPage();
             
        test.StopTest();
     }  
     
    
     
 }