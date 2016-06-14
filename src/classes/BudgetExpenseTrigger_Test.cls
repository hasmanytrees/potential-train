/*****************************************************************************************
    Name             : BudgetExpenseTrigger_Test
    Description      : Test class to cover scenario of BudgetExpense Trigger           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                05/02/2014            Created
Subhojit                
******************************************************************************************/
@isTest(seeAllData=true)
private class BudgetExpenseTrigger_Test {
    // Create Test Data
    
   
    
        private static List<BudgetExpense__c> createTestData()
    {
                
       //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<BudgetExpense__c >  listBudgetExpense = new List<BudgetExpense__c >();    
        User user = new User();
        user.Username= 'testusertest4@test.com';
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
        Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),Launch_Date__c = System.today(), Name='Test Campaign',Status='Draft',ownerId=user.Id);
        insert campaignTestVar;
        
        Campaign EventTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'),Name='Test Event',Status='Draft',ownerId=user.Id);
        insert EventTestVar;
       
         System.AssertEquals('Test Event',EventTestVar.Name);
        
       BudgetExpense__c BudgetExpenseTest1=new BudgetExpense__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign','BudgetExpense__c'),Name='BudgetExpense',Category__c = 'Travel', Budget__c = 23, Expense__c = 23 );
        BudgetExpense__c BudgetExpenseTest2=new BudgetExpense__c(Campaign__c=EventTestVar.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense2',Category__c = 'Postage', Budget__c = 23, Expense__c = 23  );
          BudgetExpense__c BudgetExpenseTest3=new BudgetExpense__c(Campaign__c=EventTestVar.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense3',Category__c = 'Displays', Budget__c = 23, Expense__c = 23  );
        listBudgetExpense.add(BudgetExpenseTest1);
        listBudgetExpense.add(BudgetExpenseTest2);
        listBudgetExpense.add(BudgetExpenseTest3);
        
        return listBudgetExpense;
        
    }
    
        static testmethod void BudgetExpense_trigger()
    { 
        test.starttest(); 
    
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        List<BudgetExpense__c>  listBudgetExpense = createTestData(); 
        insert listBudgetExpense;    //Checking insert scenarios.
        
        
        
         List<BudgetExpense__c>  listNewBudgetExpense = new list<BudgetExpense__c>(); 
    
      
      //--------------------------
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
        user.UserPermissionsMobileUser = false;
        insert user;
      //------------------------------
        listBudgetExpense[0].Budget__c = 27;        
        listBudgetExpense[1].Budget__c = 27;
        listBudgetExpense[2].Budget__c = 27;
        
        
        
        listNewBudgetExpense.add(listBudgetExpense[0]);
        listNewBudgetExpense.add(listBudgetExpense[1]);
        listNewBudgetExpense.add(listBudgetExpense[2]);
        
        update listNewBudgetExpense;   //Updating Budget in BudgetExpense object.
        
        
        System.AssertEquals(27,listBudgetExpense[0].Budget__c);
        System.AssertEquals(27,listBudgetExpense[1].Budget__c);
        System.AssertEquals(27,listBudgetExpense[2].Budget__c);
        
        delete listBudgetExpense[0]; // delete BudgetExpense scenario.
        
        test.stoptest(); 
        
        
        
    }
}