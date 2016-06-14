/*****************************************************************************************
    Name             : TestDataUtility
    Description      : test data for test classes   
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
JEEVAN                15/10/2015           Created
******************************************************************************************/
Public Class TestDataUtility {

    Public static User createUser () {
        User oUser = new User();
        oUser.Username= 'testusertest66@test.com';
        oUser.Email= 'test6@test.com';
        oUser.Lastname= 'user';
        oUser.Firstname= 'test66';
        oUser.isActive = true;
        oUser.Alias= 'test';
        oUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        oUser.TimeZoneSidKey= 'GMT';
        oUser.LocaleSidKey= 'en_US';
        oUser.Managerid = userinfo.getuserid();
        oUser.EmailEncodingKey= 'ISO-8859-1';
        oUser.LanguageLocaleKey= 'en_US';
        oUser.Authorized_Campaign_Owner__c=true;
        oUser.UserPermissionsMobileUser = true;
        insert oUser;
        
        return oUser ; 
    } 
    
    Public static Account createBeneficiary () {
        ID BenRecTypeID = Utility.getRecordType ('Beneficiary' , 'Account') ; 
        
        Account oAccountVar1=new Account(Status__c='Active',Name='Testdata1');
        oAccountVar1.BEN_Alumni_Id__c = 'ALUMINI123' ; 
        oAccountVar1.BEN_Country__c = 'Indonesia' ; 
        oAccountVar1.BEN_Global_Id__c = 'ALUMINI123' ; 
        oAccountVar1.BEN_Id__c = 'Indonesia' ; 
        oAccountVar1.BEN_Local_Id__c = 'LOCALID123' ; 
        oAccountVar1.BEN_Sponsorship_Status__c = 'Sponsor' ;
        oAccountVar1.Status__c = 'Active' ; 
        oAccountVar1.BEN_Encourager_Lock_Date__c = System.Now() ; 
        oAccountVar1.RecordtypeID = BenRecTypeID ; 
        insert oAccountVar1 ; 
        
        return oAccountVar1 ; 
    }
    
    Public static Account createSupporter () {
        ID SupprtRecTypeID = Utility.getRecordType ('Supporter' , 'Account') ; 
        
        Account oAccountVar1=new Account();
        oAccountVar1.Type='Association'; 
        oAccountVar1.Status__c='Active'; 
        oAccountVar1.Name='Testdata4'; 
        oAccountVar1.Legacy_Supporter_Id__c='4';
        oAccountVar1.Business_Email__c='testdata4@testdata.com';
        oAccountVar1.Preferred_Email__c = 'Work' ; 
        oAccountVar1.Preferred_Address__c = 'Physical' ; 
        oAccountVar1.RecordTypeID = SupprtRecTypeID; 
        insert oAccountVar1 ; 
        
        return oAccountVar1 ; 
    }   
    
    Public static SBC_Communications__c createSBCCommRecord (Account oBenRec , Account oSupporterRec , String sRecTypeName) {
        ID RecTypeID = Utility.getRecordType ( sRecTypeName , 'SBC_Communications__c') ;
        
        SBC_Communications__c oSBC = new SBC_Communications__c ( ) ;
        oSBC.Beneficiary__c = oBenRec.ID  ; 
        oSBC.Supporter__c = oSupporterRec.ID  ; 
        oSBC.SBC_Global_Id__c = 'XYZ678678'; 
        oSBC.RecordtypeID = RecTypeID  ;
        insert oSBC ; 
        
        return oSBC ;
    }  
    
    public static List<Error_Log__c> ErrorlogTestData (  ){
        List<Error_Log__c> lstError = new List<Error_Log__c> (); 
        Error_Log__c oErrortestdata1 = new Error_Log__c () ; 
         oErrortestdata1.JSON__c =  '{ "test" : "tes"}' ; 
         oErrortestdata1.Integration_Name__c =  'XMPieIntegration' ; 
         oErrortestdata1.IsRepeatEnabled__c = true ; 
         oErrortestdata1.Method__c = 'get' ;
         oErrortestdata1.Endpoint_URL__c = 'test.com' ; 
         lstError.add( oErrortestdata1 ) ; 
         
        Error_Log__c oErrortestdata2 = new Error_Log__c () ; 
         oErrortestdata2.JSON__c =  '{ "test" : "tes"}' ; 
         oErrortestdata2.Integration_Name__c =  'SBCCommitment' ; 
         oErrortestdata2.IsRepeatEnabled__c = true ; 
         oErrortestdata2.Method__c = 'get' ; 
         oErrortestdata2.Endpoint_URL__c = 'test.com' ; 
         lstError.add( oErrortestdata2 ) ; 
         
         Error_Log__c oErrortestdata3 = new Error_Log__c () ; 
         oErrortestdata3.JSON__c =  '{ "test" : "tes"}' ; 
         oErrortestdata3.Integration_Name__c =  'MasheryFailure' ;
         oErrortestdata3.IsRepeatEnabled__c = true ;  
         oErrortestdata3.Method__c = 'get' ; 
         oErrortestdata3.Endpoint_URL__c = 'test.com' ; 
         lstError.add( oErrortestdata3 ) ; 
         
         insert lstError ;
          
        return lstError;
    }
    
    public static Content__c ContentTestData(Account oAcc)
    {
    
        Content__c oContent = new Content__c();
        oContent.Account__c = oAcc.id;
        insert oAcc ;
        
        Attachment oAttach = new Attachment( parentID = oAcc.ID ) ; 
        
        return oContent ; 
        
    }
}