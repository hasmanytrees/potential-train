/******************************************************************************
Name             : SendEmailUsingXMPieTest
Description      : Test class for SendEmailUsingXMPie
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class SendEmailUsingXMPieTest{

    public static void shutDownValidation()
    {
         Trigger_Methods_Activation__c oRef = Trigger_Methods_Activation__c.getAll().get('Commitment Validation Check');
    oRef.Is_Trigger_Method_Required_In_Delete__c=false;
    oRef.Is_Trigger_Method_Required_In_Insert__c=false;
    oRef.Is_Trigger_Method_Required_In_Update__c=false;
    update oRef;
    }
    public testMethod static void testSendEmailUsingXMPie(){
    
      shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 
       List<Id> lstSBCId=new List<Id>();
       List<Account>  lstAcc = new List<ACcount> () ; 
       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ; 
       List<SBC_Communications__c> lstSBCRecords = new List<SBC_Communications__c> () ;  
       lstSBCRecords.add( oSBCRec ) ; 
       lstSBCId.add(oSBCRec.Id);
       lstSBCRecords[0].Date_Physical_Received__c = System.Today() ; 
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       lstAcc.add(oSupRec) ; 
       Test.StartTest() ;
           SendEmailUsingXMPie.sendEmail(lstAcc ) ; 
           SendEmailUsingXMPie.sendEmailForSBC ( lstSBCRecords,true ) ; 
              SendEmailUsingXMPie.sendEmailForSBC ( lstSBCRecords,false) ; 
           boolean bCheck=SendEmailUsingXMPie.sendPrint(lstSBCId);
           
       Test.StopTest() ; 

    }
    public testMethod static void testSendEmailUsingXMPie2(){
    
      shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 
       
       List<Account>  lstAcc = new List<ACcount> () ; 
       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ; 
       List<SBC_Communications__c> lstSBCRecords = new List<SBC_Communications__c> () ;  
       lstSBCRecords.add( oSBCRec ) ; 
       lstSBCRecords[0].Preferred_Address__c = 'Personal' ; 
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       lstAcc.add(oSupRec) ; 
       Test.StartTest() ;
           SendEmailUsingXMPie.sendEmail(lstAcc ) ; 
           SendEmailUsingXMPie.sendEmailForSBC ( lstSBCRecords,false ) ; 
       Test.StopTest() ; 

    }
    public testMethod static void testSendEmailUsingXMPie3(){
    
      shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 
       
       List<Account>  lstAcc = new List<ACcount> () ; 
       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ; 
       List<SBC_Communications__c> lstSBCRecords = new List<SBC_Communications__c> () ;  
       lstSBCRecords.add( oSBCRec ) ; 
       lstSBCRecords[0].Preferred_Email__c = 'Personal' ; 
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       lstAcc.add(oSupRec) ; 
       Test.StartTest() ;
           SendEmailUsingXMPie.sendEmail(lstAcc ) ; 
           SendEmailUsingXMPie.sendEmailForSBC ( lstSBCRecords,true ) ; 
       Test.StopTest() ; 

    }
}