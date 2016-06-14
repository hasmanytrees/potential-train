/*****************************************************************************************
    Name             : AgencyFeedbackTrigger_Test
    Description      : Main Agency Feedbcak Trigger test class  to cover all trigger classes                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class  AgencyFeedbackTrigger_Test{    
    
    //Creating Test Data
    private static List<Agency_Feedback__c> listAgnecyFeedbackTest()
    {
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();

        Account oAgencyTest=new Account(Name='Test Agnecy',Business_Email__c='test@test.com',recordtypeId=Utility.getRecordType('Agency','Account'));
        insert oAgencyTest;
        
          System.AssertEquals('test@test.com',oAgencyTest.Business_Email__c);
        
        List<Agency_Feedback__c> lstAgnecyFeedbackTest=new  List<Agency_Feedback__c>();
        Agency_Feedback__c oTestFeedback1=new Agency_Feedback__c(Agency__c=oAgencyTest.Id,Creative__c='3',Customer_Service__c='2',Overall_Experience__c='4',
        Pricing__c='5',   Timeliness__c='3');

        Agency_Feedback__c oTestFeedback2=new Agency_Feedback__c(Agency__c=oAgencyTest.Id,Creative__c='3',Customer_Service__c='2',Overall_Experience__c='4',
        Pricing__c='5',   Timeliness__c='3');

        Agency_Feedback__c oTestFeedback3=new Agency_Feedback__c(Agency__c=oAgencyTest.Id,Creative__c='3',Customer_Service__c='2',Overall_Experience__c='4',
        Pricing__c='5',   Timeliness__c='3');
        lstAgnecyFeedbackTest.add(oTestFeedback1);
        lstAgnecyFeedbackTest.add(oTestFeedback2);   
        lstAgnecyFeedbackTest.add(oTestFeedback3);   
        return  lstAgnecyFeedbackTest;                                                             
    }
    
    //method for covering AgencyFeedbackTrigger class
    public static testMethod void testRollUpFeddBack()
    {
        test.startTest();
        
        List<Agency_Feedback__c> lstAgnecyFeedbackTest=listAgnecyFeedbackTest();
        insert lstAgnecyFeedbackTest;     //Checking Insert scenario
        
        system.Assert( lstAgnecyFeedbackTest[0].ID != NULL ) ; 
        
        lstAgnecyFeedbackTest[0].Pricing__c='3';
        update lstAgnecyFeedbackTest;     //Checking Update Scenaruo
        
        System.AssertEquals('3',lstAgnecyFeedbackTest[0].Pricing__c);
        delete lstAgnecyFeedbackTest[0];     //Checking Delete Scenario
        
        test.StopTest();
    }
    
    //method for covering AgencyFeedbackTrigger class
    public static testMethod void testRollUpFeddBackUpdate()
    {
    
        Trigger_Methods_Activation__c oTriggerMethod = Trigger_Methods_Activation__c.getInstance
            ('calculateFeedbackScore') ; 
            
        oTriggerMethod.Is_Trigger_Method_Required_In_Insert__c = false ; 
        
        update oTriggerMethod ;
        test.startTest();
        
        List<Agency_Feedback__c> lstAgnecyFeedbackTest=listAgnecyFeedbackTest();
        insert lstAgnecyFeedbackTest;     //Checking Insert scenario
        
        system.Assert( lstAgnecyFeedbackTest[0].ID != NULL ) ; 
        
        lstAgnecyFeedbackTest[0].Pricing__c='3';
        update lstAgnecyFeedbackTest;     //Checking Update Scenaruo
        
        System.AssertEquals('3',lstAgnecyFeedbackTest[0].Pricing__c);
        delete lstAgnecyFeedbackTest[0];     //Checking Delete Scenario
         
        test.StopTest();
    }

}