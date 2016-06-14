/*****************************************************************************************
    Name             : SBCCommunicationStatusAssignment_Test
    Description      : This test class is used for covering all the test scneario 
                       related to the SBCCommunicationStatusAssignment
    Modification Log : 
---------------------------------------------------------------------------
    Developer              Date              Description
---------------------------------------------------------------------------
    Jeevan                 15/10/2015            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class SBCCommunicationStatusAssignment_Test
{

    public static void shutDownValidation()
    {
         Trigger_Methods_Activation__c oRef = Trigger_Methods_Activation__c.getAll().get('Commitment Validation Check');
         oRef.Is_Trigger_Method_Required_In_Delete__c=false;
         oRef.Is_Trigger_Method_Required_In_Insert__c=false;
         oRef.Is_Trigger_Method_Required_In_Update__c=false;
         update oRef;
    }
    
    private static testMethod void testSBCAssignment()
    {
         shutDownValidation() ; 
         Test.StartTest() ; 
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
         Account oBen = TestDataUtility.createBeneficiary () ;
         Account oSupporter =  TestDataUtility.createSupporter () ;
         SBC_Communications__c oSBCVar1 = TestDataUtility.createSBCCommRecord ( oBen ,oSupporter,'Beneficiary To Supporter' ) ;  
        // SBC_Communications__c oSBCVar2 = TestDataUtility.createSBCCommRecord ( oBen ,oSupporter,'Beneficiary To Supporter' ) ;  
         
         Map<SBC_Communications__c, String> mapSBCRecords = new Map<SBC_Communications__c, String> () ; 
         mapSBCRecords.put( oSBCVar1 , 'Hold Final Letter' ) ;   
      //   mapSBCRecords.put( oSBCVar2 , 'In Translation' ) ; 
         
         SBCCommunicationStatusAssignment oSBCAssignVar = new SBCCommunicationStatusAssignment () ; 
         oSBCAssignVar.assignStatusBasedOnCondition ( mapSBCRecords ) ; 
         Test.StopTest() ; 
    }
}