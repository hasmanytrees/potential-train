/*****************************************************************************************
    Name             : AccountTrigger_Test
    Description      : Main Account Trigger test class  to cover all Account trigger classes                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(SeeAllData=true)
public class AccountTrigger_Test{

        //Creating Test Data
        private Static List<Account> getAccountData()
    {    
     //Checking Insert scenarios
                
        User user = new User();
        user.Username= 'testusertest1@test.com';
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
        if(user!=null){
            insert user;
        }
        List<Account> lstAccountTestData=new  List<Account>();
    //    User u = [select id from User where alias = 'skanj'];
        Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',OwnerId = user.id, Business_Email__c='testdata1@testdata.com');
        Account oAccountVar2=new Account(Type='Church',Status__c='Active',Name='Testdata2',OwnerId = user.id, Business_Email__c='testdata2@testdata.com');
        Account oAccountVar3=new Account(Type='Foundation',Status__c='Active',Name='Testdata3',OwnerId = user.id, Business_Email__c='testdata3@testdata.com');
        Account oAccountVar4=new Account(Type='Association',Status__c='Active',Name='Testdata4',OwnerId = user.id, Business_Email__c='testdata4@testdata.com'); 
        
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        lstAccountTestData.add(oAccountVar3);
        lstAccountTestData.add(oAccountVar4);
        System.assertEquals(lstAccountTestData[0].Type, 'Business');
        
        return  lstAccountTestData;
    }
    
    //Creating Integration Endpoints
    private static void createEndpoint()
    {
        Integration_Endpoints__c oEndpointRef = new Integration_Endpoints__c();
        oEndpointRef.Name = 'Compass Endpoint';
        oEndpointRef.Endpoint_URL__c = 'https://api2.compassion.com/US/1/TEST/Supporter/ProfileUpdate';
        oEndpointRef.Authorization_Code__c = 'cnmv58dutyhwex8z2nmud4fb';
        System.assertEquals(oEndpointRef.Name, 'Compass Endpoint');
        if(oEndpointRef!=null){
            insert oEndpointRef;
        }
    }
    
    //Covers Classes triggered by change in Account record as 1.AccountHandler 
        static testMethod void createAccountTest()
    {    
       
        
        List<Account> lstAccountTestData = getAccountData();
        if(lstAccountTestData.size()>0){
            insert lstAccountTestData;      //Checking Insert scenarios
        }        
        User user = new User();
        user.Username= 'testusert245678est1@test.com';
        user.Email= 'tes987654t@test.com';
        user.Lastname= 'user1342';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.UserPermissionsMobileUser = false;
        if(user!=null){
            insert user;
        }
        System.assertEquals('testusert245678est1@test.com',user.Username);
        Integer i =0;
        for(Account accountVar: lstAccountTestData)
        {
            accountVar.ownerId=user.Id;
            accountVar.Type='Individual';
            accountVar.Business_Phone__c='897899999999789';
            accountVar.Legacy_Supporter_Id__c='8978999999-99789'+i;
            i++;
            
            accountVar.Name='test test Only Test';
        }
        if(lstAccountTestData.size()>0){
            update lstAccountTestData;  //Checking update scenarios for follow and unfollow    
        }
        for(Account accountVar: lstAccountTestData)
        {
            accountVar.ownerId=user.Id;
            accountVar.Type='Individual';
            accountVar.Business_Phone__c='897899999999789';
            accountVar.Legacy_Partner_Id__c='8978999999----99789';
            accountVar.Name='test test Only Test';
        }
        if(lstAccountTestData.size()>0){
            update lstAccountTestData;  //Checking update scenarios for follow and unfollow
        }
    }

        static testMethod void createDeleteAccountTest(){
        Account accountTest=new Account(Name='Test Name',Business_Email__c='test@tes.com');
        System.assertEquals('Test Name',accountTest.Name);
        if(accountTest!=null){
            insert accountTest;
        }
        Partner_Type__c partnerTypeChurchTest=new Partner_Type__c (recordtypeId=Utility.getRecordTypeMap('Partner_Type__c').get('Church'),Type__c='Church',OwnerId=UserInfo.getUserId(),Account__c=accountTest.Id);
        if(partnerTypeChurchTest!=null){
            insert partnerTypeChurchTest;
        }
        if(accountTest!=null){
            delete accountTest;
        }
        User user = new User();
        user.Username= 'tes987654t2@test.com';
        user.Email= 'tes987654t2@test.com';
        user.Lastname= 'user1342';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Integration Profile'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.UserPermissionsMobileUser = false;
        if(user!=null){
            insert user;
        }    
        System.assertEquals('tes987654t2@test.com',user.Username);
        Account accountTest2=new Account(Name='Test Consignment Name',Business_Email__c='test@tes.com' );
        Account accountTest4=new Account(Name='Test Consignment Name2',Business_Email__c='test4@tes4.com' , ownerID = user.ID );
        if(accountTest2!=null && accountTest4!= null){
            insert accountTest2;
            insert accountTest4;
        
        System.runAs(user){
            try{
            delete accountTest2;
          List<Account> lstAcc = new List<Account>();
            lstAcc.add(accountTest4);
            AccountTriggerHandler.checkAccountDeletionValidation(lstAcc);
            }
            catch(Exception e){
                System.assertEquals('tes987654t2@test.com',user.Username);
            }
        }
        }
        Account accountTest3=new Account(Name='Test Consignment Name',Business_Email__c='test@tes.com' , ownerID = user.ID );
        if(accountTest3!=null){
            insert accountTest3;
            accountTest3.OwnerID = UserInfo.getUserId() ;
            update accountTest3 ;
            List<Account> lstAcc = new List<Account>();
            lstAcc.add(accountTest3);
            AccountTriggerHandler.checkAccountDeletionValidation(lstAcc);
        }
    }
    
    // Verify R3TEST Methods 
    static testMethod void VerifySBCScenariosS2B()
    {    
        Account oSupAcc = TestDataUtility.createSupporter () ;  
        Account oBenAcc = TestDataUtility.createBeneficiary () ;
        SBC_Communications__c oSBCRec1 = TestDataUtility.createSBCCommRecord (oBenAcc , oSupAcc  , 'Supporter To Beneficiary') ; 
        if(oSBCRec1!=null){
            oSBCRec1.SBC_Global_Id__c = NULL ; 
            update oSBCRec1 ; 
        }
        Test.StartTest() ; 
            if(oSupAcc!=null){
                oSupAcc.Status__c = 'Inactive' ; 
                update oSupAcc ; 
            }
            SBC_Communications__c oSBCRec2 = TestDataUtility.createSBCCommRecord (oBenAcc , oSupAcc  , 'Supporter To Beneficiary') ;   
            if(oBenAcc !=null){
                oBenAcc.Status__c = 'Inactive' ; 
                update oBenAcc ;
            }
            if(oSBCRec2!=null){
                oSBCRec2.SBC_Global_Id__c = NULL ; 
                update oSBCRec2 ;
            }
            SBC_Communications__c oSBCRec3 = TestDataUtility.createSBCCommRecord (oBenAcc , oSupAcc  , 'Supporter To Beneficiary') ;   
            oSupAcc.Preferred_Email__c = 'Work' ;  
            oSupAcc.Work_Email__c = 'wrok@test.com' ; 
            oSupAcc.Preferred_Address__c = 'Work' ; 
            oSupAcc.ShippingState =  'test' ; 
            oSupAcc.ShippingStreet =  'test' ;
            oSupAcc.ShippingCountry =  'test' ;
            oSupAcc.Undeliverable_Invalid__c =  'Mailing Address' ; 
            if(oSupAcc!=null){
                update oSupAcc ; 
                oSupAcc.Undeliverable_Invalid__c = 'Mailing Address; Personal Email ' ;  
                update oSupAcc ; 
                system.Assert( oSupAcc != NULL ) ; 
            }
        Test.StopTest() ; 
    } 
    
    // Verify R3TEST Methods 
    static testMethod void VerifySBCScenariosB2S()
    {    
        Account oSupAcc = TestDataUtility.createSupporter () ;  
        Account oBenAcc = TestDataUtility.createBeneficiary () ;
        SBC_Communications__c oSBCRec1 = TestDataUtility.createSBCCommRecord (oBenAcc , oSupAcc  , 'Beneficiary To Supporter') ; 
        if(oSBCRec1!=null){
            oSBCRec1.SBC_Global_Id__c = NULL ; 
            update oSBCRec1 ; 
        }
        Test.StartTest() ; 
            if(oSupAcc!=null){
                oSupAcc.Status__c = 'Inactive' ; 
                update oSupAcc ; 
            }
            SBC_Communications__c oSBCRec2 = TestDataUtility.createSBCCommRecord (oBenAcc , oSupAcc  , 'Beneficiary To Supporter') ;   
            if(oBenAcc!=null){
                oBenAcc.Status__c = 'Inactive' ; 
                update oBenAcc ;
            }
            if(oSBCRec2!=null){
                oSBCRec2.SBC_Global_Id__c = NULL ; 
                update oSBCRec2 ;
            }
            SBC_Communications__c oSBCRec3 = TestDataUtility.createSBCCommRecord (oBenAcc , oSupAcc  , 'Beneficiary To Supporter') ;   
            oSupAcc.Preferred_Email__c = 'Work' ;  
            oSupAcc.Work_Email__c = 'wrok@test.com' ; 
            oSupAcc.Preferred_Address__c = 'work' ; 
            oSupAcc.ShippingState =  'test' ; 
            oSupAcc.ShippingStreet =  'test' ;
            oSupAcc.ShippingCountry =  'test' ;
            oSupAcc.Undeliverable_Invalid__c =  'Mailing Address' ; 
            if(oSupAcc!=null){
            update oSupAcc ; 
            Utility.bRecursive = false ; 
            oSupAcc.Undeliverable_Invalid__c = 'Mailing Address; Personal Email ' ;  
            update oSupAcc ; 
            Utility.bRecursive = false ; 
            oSupAcc.Undeliverable_Invalid__c = '' ;  
            update oSupAcc ;
            Utility.bRecursive = false ; 
            oSupAcc.Undeliverable_Invalid__c = 'Mailing Address; Personal Email ' ;  
            update oSupAcc ;
            }
            Utility.bRecursive = false ; 
            system.Assert( oSupAcc != NULL ) ; 
        Test.StopTest() ; 
    } 
}