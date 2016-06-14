/*****************************************************************************************
    Name             : LeadMassActionExtension_Test
    Description      : This class is vf controller for LeadMassActionpage which is called from a list button and used to close multiple lead in bulk  using               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class LeadMassActionExtension_Test{   
   
        public testMethod static void testLeadMassAction()
    {    
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        Lead lead1=new Lead(OwnerId=[select Id from Group where Name = 'Church Queue' and Type = 'Queue' limit 1].Id,LastName='Lead Test2',Company='Test',Email='test@test.com',Street='Test',State='NY',Country='US',PostalCode='92130',City='New York');
        insert lead1;
        system.assertEquals('Lead Test2',lead1.LastName);
        
        Lead lead2=new Lead(OwnerId=[select Id from Group where Name = 'Church Queue' and Type = 'Queue' limit 1].Id,LastName='Lead Test2',Company='Test',Email='test@test.com',Street='Test',State='NY',Country='US',PostalCode='92130',City='New York');
        insert lead2; 
        system.assertEquals('Lead Test2',lead2.LastName);
        
        Test.setCurrentPageReference(new PageReference('ChooseFileToSend')); 
        System.currentPageReference().getParameters().put('LeadId', lead1.Id+','+lead2.Id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(lead1);
        LeadMassActionExtension controller=new LeadMassActionExtension(sc);
        controller.oLead.Status='Closed';
        controller.ShowLeadClosedReason();
        controller.oLead.Status='New';
        controller.ShowLeadClosedReason();
        
        controller.Save();
        Test.setCurrentPageReference(new PageReference('ChooseFileToSend'));  
        System.currentPageReference().getParameters().put('LeadId', lead1.Id);
        sc = new ApexPages.Standardcontroller(lead1);
        controller=new LeadMassActionExtension(sc);
        test.stopTest();
    }
    
    
    public testMethod static void testLeadMassActionNew()
    {    
        test.startTest();
        
        Lead lead1=new Lead(OwnerId=[select Id from Group where Name = 'Church Queue' and Type = 'Queue' limit 1].Id,LastName='Lead Test2',Company='Test',Email='test@test.com',Street='Test',State='NY',Country='US',PostalCode='92130',City='New York');
        insert lead1;
        system.assertEquals('Lead Test2',lead1.LastName);
        
        Lead lead2=new Lead(OwnerId=[select Id from Group where Name = 'Church Queue' and Type = 'Queue' limit 1].Id,LastName='Lead Test2',Company='Test',Email='test@test.com',Street='Test',State='NY',Country='US',PostalCode='92130',City='New York');
        insert lead2; 
        system.assertEquals('Lead Test2',lead2.LastName);
        
        Test.setCurrentPageReference(new PageReference('ChooseFileToSend')); 
        System.currentPageReference().getParameters().put('LeadId', lead1.Id+','+lead2.Id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(lead1);
        LeadMassActionExtension controller=new LeadMassActionExtension(sc);
        controller.oLead.Status='Closed';
        
        controller.Save();
        
        test.stopTest();
    }

}