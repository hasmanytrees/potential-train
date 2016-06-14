/******************************************************************************
Name             : FileDownloaderControllerTest
Description      : Test class for FileDownloaderController
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class FileDownloaderControllerTest{
    
    
    public static void shutDownValidation()
    {
         Trigger_Methods_Activation__c oRef = Trigger_Methods_Activation__c.getAll().get('Commitment Validation Check');
    oRef.Is_Trigger_Method_Required_In_Delete__c=false;
    oRef.Is_Trigger_Method_Required_In_Insert__c=false;
    oRef.Is_Trigger_Method_Required_In_Update__c=false;
    update oRef;
    }
    public testMethod static void FileDownloaderController(){
    
      shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;   
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       
       ApexPages.currentPage().getParameters()
        .put('type', 'Original?parent_domain');
       ApexPages.currentPage().getParameters()
        .put('contentId', oSBCRec.ID +'?parent_domain');
        
       Test.StartTest() ; 
       FileDownloaderController oFileDwnldTest = new FileDownloaderController () ; 
       oFileDwnldTest.getFileFromPerceptive() ;  
       oSBCRec.Original_Letter_URL__c = ApexPages.currentPage().getURL() ;
       update oSBCRec ; 
       oFileDwnldTest.bShow = false ; 
       oFileDwnldTest.getFileFromPerceptive() ; 
       Test.StopTest() ; 
       
    }   
    public testMethod static void FileDownloaderController2(){
    
      shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;
       oSBCRec.Original_Letter_URL__c = 'test.com' ;
       update oSBCRec ;    
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       
       ApexPages.currentPage().getParameters()
        .put('type', 'Original?parent_domain');
       ApexPages.currentPage().getParameters()
        .put('contentId', oSBCRec.ID +'?parent_domain');
        
       Test.StartTest() ; 
       FileDownloaderController oFileDwnldTest = new FileDownloaderController () ; 
       oFileDwnldTest.getFileFromPerceptive() ;  

       oFileDwnldTest.sSelectedValue = 'Final' ; 
       oFileDwnldTest.getFileFromPerceptive() ; 
       oFileDwnldTest.sSelectedValue = NULL ; 
       oFileDwnldTest.getFileFromPerceptive() ; 
       oFileDwnldTest.sSelectedValue = 'Final' ; 
       oFileDwnldTest.bShow = true ; 
       oFileDwnldTest.getFileFromPerceptive() ; 
       Test.StopTest() ; 
       
    }  
    public testMethod static void FileDownloaderController3(){
    
      shutDownValidation();
       User oUserRec  = TestDataUtility.createUser () ; 
       
       Account oBenRec = TestDataUtility.createBeneficiary () ; 
       
       Account oSupRec = TestDataUtility.createSupporter () ; 

       SBC_Communications__c oSBCRec = TestDataUtility.createSBCCommRecord ( oBenRec , oSupRec  , 'Beneficiary To Supporter') ;
       oSBCRec.final_Letter_URL__c = 'test.com' ;
       update oSBCRec ;    
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment3());
       
       ApexPages.currentPage().getParameters()
        .put('type', 'Original?parent_domain');
       ApexPages.currentPage().getParameters()
        .put('contentId', oSBCRec.ID +'?parent_domain');
        
       Test.StartTest() ; 
       FileDownloaderController oFileDwnldTest = new FileDownloaderController () ; 
       oFileDwnldTest.getFileFromPerceptive() ;  

       oFileDwnldTest.sSelectedValue = ''; 
       oFileDwnldTest.getFileFromPerceptive() ; 
       
       oFileDwnldTest.getFileFromPerceptive() ; 
       oFileDwnldTest.getsBlobFileStr () ; 
       oFileDwnldTest.sOAuthToken = 'test';
       String testdate = oFileDwnldTest.sOAuthToken  ; 
       
       oFileDwnldTest.sSelectedValue = 'Final'; 
       oFileDwnldTest.getFileFromPerceptive() ; 

       Test.StopTest() ; 
       
    }    
    }