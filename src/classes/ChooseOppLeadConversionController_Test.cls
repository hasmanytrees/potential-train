/*****************************************************************************************
    Name             : ChooseOppLeadConversionController_Test
    Description      : This class is used as visual force page ChooseOpportunityLeadConversion to choose whether to create opportunity or not
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class ChooseOppLeadConversionController_Test
{
 
     public testMethod static void testLeadConversion()
 {
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        Lead oLeadVar=new Lead(OwnerId=[select Id from Group where Name = 'Church Queue' and Type = 'Queue' limit 1].Id,LastName='Lead Test',Company='Test',Email='test@test.com',Street='Test',State='NY',Country='US',PostalCode='92130',City='New York');
        insert oLeadVar;
        System.assertEquals('Lead Test',oLeadVar.LastName);
        
        PageReference pageRef=Page.ChooseOppLeadConversion;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',oLeadVar.Id+('?parent_domain'));
        
        ChooseOppLeadConversionController controller=new ChooseOppLeadConversionController();
        Account acct=new Account();
        controller.accountId=acct.Id;
        ChooseOppLeadConversionController.convertLead(oLeadVar.Id,false);
        
        oLeadVar.ownerId=userInfo.getUserId();
        update oLeadVar;
        System.assertEquals(userInfo.getUserId(),oLeadVar.ownerId);
        ChooseOppLeadConversionController controller1=new ChooseOppLeadConversionController();
        controller.bCreateOpportunity=true;
        controller=new ChooseOppLeadConversionController();
        String str=ChooseOppLeadConversionController.convertLead(oLeadVar.Id,true);
        str=ChooseOppLeadConversionController.convertLead(oLeadVar.Id,false);
        controller.oLeadVar.Id=null;
        str=ChooseOppLeadConversionController.convertLead(oLeadVar.Id,false);
        controller.sMessage = System.Label.Lead_Conversion_Success ;
        controller.showMessage () ; 
        controller.sMessage = 'error' ;
        controller.showMessage () ;  
        ChooseOppLeadConversionController.convertLead(NULL,NULL); // To test for exception 
        test.stopTest();
 } 


}