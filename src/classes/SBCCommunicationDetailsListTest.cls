/******************************************************************************
Name             : SBCCommunicationDetailsListTest
Description      : Test class for SBCCommunicationDetailsList
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class SBCCommunicationDetailsListTest{

    private Static List<Account> getAccountData()
    {
        User user6 = new User();
        user6.Username= 'testusertest66@test.com';
        user6.Email= 'test6@test.com';
        user6.Lastname= 'user';
        user6.Firstname= 'test66';
        user6.isActive = true;
        user6.Alias= 'test';
        user6.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user6.TimeZoneSidKey= 'GMT';
        user6.LocaleSidKey= 'en_US';
        user6.Managerid = userinfo.getuserid();
        user6.EmailEncodingKey= 'ISO-8859-1';
        user6.LanguageLocaleKey= 'en_US';
        user6.Authorized_Campaign_Owner__c=true;
        user6.UserPermissionsMobileUser = true;
        insert user6;
        //--------------
        
        ID BenRecTypeID = Utility.getRecordType ('Beneficiary' , 'Account') ; 
        ID SupprtRecTypeID = Utility.getRecordType ('Supporter' , 'Account') ; 
        
        List<Account> lstAccountTestData=new  List<Account>();
        Account oAccountVar1=new Account(Status__c='Active',Name='Testdata1',ownerid = user6.id);
        Account oAccountVar2=new Account(Status__c='Active',Name='Testdata2',ownerid = user6.id);
        Account oAccountVar3=new Account(Type='Foundation',Status__c='Active',Name='Testdata3',Business_Email__c='testdata3@testdata.com',Legacy_Supporter_Id__c='3',ownerid = user6.id);
        Account oAccountVar4=new Account(Type='Association',Status__c='Active',Name='Testdata4',Business_Email__c='testdata4@testdata.com',Legacy_Supporter_Id__c='4',ownerid = user6.id);
        
        oAccountVar1.RecordtypeID = BenRecTypeID ; 
        
        oAccountVar2.RecordtypeID = BenRecTypeID ; 
        oAccountVar3.RecordtypeID = SupprtRecTypeID ; 
        oAccountVar4.RecordtypeID = SupprtRecTypeID ;
        
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        lstAccountTestData.add(oAccountVar3);
        lstAccountTestData.add(oAccountVar4);
        
        return  lstAccountTestData;        
    }

     public testMethod static void testMethodSBCDetails () {
         
         List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         
        List<SBC_Communications__c>  lstSBCComm = new List<SBC_Communications__c> () ;  
        SBC_Communications__c oSBC1 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[0].ID ) ;   
        SBC_Communications__c oSBC2 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID , Correspondence_Type__c = SYSTEM.LABEL.Encourager_Communication ) ;
        lstSBCComm.add(oSBC1) ; 
        lstSBCComm.add(oSBC2) ; 
            insert lstSBCComm; 
        
       
        List<SBCCommunicationDetailsList.SBCCommunicationDetails> SBCCommunicationDetail = new List<SBCCommunicationDetailsList.SBCCommunicationDetails> () ; 
        List<SBCCommunicationDetailsList.SBCCommunicationUpdateDetailsUpdateFromCI  > SBCCommunicationDetailCI = new List<SBCCommunicationDetailsList.SBCCommunicationUpdateDetailsUpdateFromCI  > () ; 
        
         Test.StartTest() ; 
             SBCCommunicationDetailsList oSbcDetailTest = new SBCCommunicationDetailsList () ; 
             SBCCommunicationDetailsList.SBCCommunicationDetails oSbcDetailTest1 = new SBCCommunicationDetailsList.SBCCommunicationDetails() ; 
             oSbcDetailTest1.GlobalPartnerSBCId = lstSBCComm[0].ID ; 
             SBCCommunicationDetail.add ( oSbcDetailTest1 ) ; 
             SBCCommunicationDetailsList.SBCCommunicationUpdateDetailsUpdateFromCI  oSbcDetailTest2 = new SBCCommunicationDetailsList.SBCCommunicationUpdateDetailsUpdateFromCI (oSbcDetailTest1  ) ; 
             SBCCommunicationDetailsList.SBCCommunicationDetailsISL oSbcDetailTest3 = new SBCCommunicationDetailsList.SBCCommunicationDetailsISL(oSbcDetailTest1 ) ; 
             SBCCommunicationDetailsList.SBCCommunicationDetailsFin oSbcDetailTest4 = new SBCCommunicationDetailsList.SBCCommunicationDetailsFin(SBCCommunicationDetail) ;
             SBCCommunicationDetailCI.add(oSbcDetailTest2 ) ;  
             SBCCommunicationDetailsList.SBCCommunicationDetailsUpdateCI oSbcDetailTest5 = new SBCCommunicationDetailsList.SBCCommunicationDetailsUpdateCI (SBCCommunicationDetailCI) ; 
             SBCCommunicationDetailsList.SBCCommunicationDetails_ISL oSbcDetailTest6 = new SBCCommunicationDetailsList.SBCCommunicationDetails_ISL () ; 
         System.assertequals(lstSBCComm[0].ID ,oSbcDetailTest1.GlobalPartnerSBCId);    
         Test.StopTest() ; 
     }
     

}