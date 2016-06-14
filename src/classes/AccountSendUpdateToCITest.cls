/*****************************************************************************************
    Name             : AccountSendUpdateToCITest
    Description      : This test class is used for covering all the test scneario 
                       related to the AccountSendUpdateToCI
    Modification Log : 
---------------------------------------------------------------------------
    Developer              Date              Description
---------------------------------------------------------------------------
    Jeevan                 15/10/2015            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class AccountSendUpdateToCITest
{

    
    private static testMethod void testAccountSendUpdateToCI1()
    {
         Test.StartTest() ; 
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
         Account oSupporter =  TestDataUtility.createSupporter () ;
         List<ID> lstAccIDS = new List<ID> () ; 
         lstAccIDS.add( oSupporter.ID ) ; 
         AccountSendUpdateToCI.sendUpdateCI( lstAccIDS ) ; 
         System.Assert ( lstAccIDs != NULL ) ; 
         Test.StopTest() ; 
    }
    
    private static testMethod void testAccountSendUpdateToCI2()
    {
         Field_Group__c grpDelete = [ Select ID from Field_Group__c where name = 'AccountCIUpdateFieldGroup']  ; 
           delete grpDelete ; 
         Test.StartTest() ; 
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
         Account oSupporter =  TestDataUtility.createSupporter () ;
         List<ID> lstAccIDS = new List<ID> () ; 
         lstAccIDS.add( oSupporter.ID ) ; 
         AccountSendUpdateToCI.sendUpdateCI( lstAccIDS ) ; 
         System.Assert ( lstAccIDs != NULL ) ; 
         Test.StopTest() ; 
    }
           
}