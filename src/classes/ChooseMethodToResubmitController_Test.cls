/*****************************************************************************************
    Name             : ChooseMethodToResubmitController_Test
    Description      : This test class is used for covering all the test scneario 
                       related to ChooseMethodToResubmitController               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 30/10/2014            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class ChooseMethodToResubmitController_Test
{
    
    private static testMethod void testValidationScenarios1()
    {
        

       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;  

       ApexPages.currentPage().getParameters()
        .put('id', oSBCRec.ID );
       ApexPages.currentPage().getParameters()
        .put('parent_domain', 'parent_domain=https://compassion--r3test.cs21.my.salesforce.com' );

        Test.StartTest() ; 
            ChooseMethodToResubmitController oControllerTest = new ChooseMethodToResubmitController () ; 
            oControllerTest.sendToXMpie() ; 
            oControllerTest.sSelectedMethod = 'mail' ; 
            oControllerTest.sendToXMpie() ; 
            oControllerTest.sSelectedMethod = 'email' ; 
            oControllerTest.sendToXMpie() ; 
        Test.StopTest() ; 
        
    }
    
    private static testMethod void testValidationScenarios2()
    {
        

       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;  

       ApexPages.currentPage().getParameters()
        .put('id', oSBCRec.ID );
       ApexPages.currentPage().getParameters()
        .put('parent_domain', 'parent_domain=https://compassion--r3test.cs21.my.salesforce.com' );
    //    https://compassion--R3TEST--c.cs21.visual.force.com/apex/ChooseMethodToResubmit?id=a1Sq0000000cIWC?parent_domain=https://compassion--r3test.cs21.my.salesforce.com
        oSBCRec.Preferred_Email__c = 'test' ; 
        oSBCRec.Preferred_Address__c = 'test' ;
        update oSBCRec ;
        Test.StartTest() ; 
            ChooseMethodToResubmitController oControllerTest = new ChooseMethodToResubmitController () ; 
            oControllerTest.sendToXMpie() ; 
            oControllerTest.sSelectedMethod = 'mail' ; 
            oControllerTest.sendToXMpie() ; 
            oControllerTest.sSelectedMethod = 'email' ; 
            oControllerTest.sendToXMpie() ; 
        Test.StopTest() ; 
        
    }
    
   
}