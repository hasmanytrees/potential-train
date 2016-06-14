/******************************************************************************
Name             : ExprtAttachmntPerceptiveServiceTest
Description      : Test class for ExprtAttachmntPerceptiveService
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class ExprtAttachmntPerceptiveServiceTest{

Public static FeedItem post ;
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
        List<Account> lstAccountTestData=new  List<Account>();
        Account oAccountVar1=new Account(Status__c='Active',Name='Testdata1',ownerid = user6.id);
        Account oAccountVar2=new Account(Status__c='Active',Name='Testdata2',ownerid = user6.id);
        oAccountVar1.RecordtypeID = BenRecTypeID ; 
        oAccountVar2.RecordtypeID = BenRecTypeID ; 
        
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        
        return  lstAccountTestData;
    }


public Static FeedItem addAttachment( ID parentid )
{    

    Attachment oAttachmentData = new Attachment ( Name = 'Test' , Body = BLOB.ValueOf ('test') ) ;
    oAttachmentData .parentId=parentid ;
    insert oAttachmentData ;
    
    //Adding a Content post
    post = new FeedItem();
    post.ParentId = parentid ; //
    post.Body = 'Attachment added';
    post.ContentData = oAttachmentData .body;
    post.ContentFileName = oAttachmentData .Name;
    insert post;
    return post ;
}

    public testMethod static void sendFileToPerceptive1(){
             
        List<Account> lstAccountTestData=getAccountData();
        insert lstAccountTestData;
        Test.StartTest() ; 
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        Content__c oConTestData = new Content__c ( Account__c = lstAccountTestData[0].ID  ) ; 
        Insert oConTestData ;
        
        string sTesdata = 'Testing base 64 encode.bmp'; 
                   
        BLOB bAfterBlob =  BLOB.ValueOF( sTesdata ) ;
        
        //Insert contentdocument data
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger.jpeg';      
        cv.PathOnClient ='Penguins.jpg';           
        cv.VersionData =bAfterBlob ;  
            
        insert cv;         
                                
        ContentVersion testContent = [SELECT id, ContentDocumentId , FileExtension FROM ContentVersion where Id = :cv.Id];

        List<ContentDocumentLink > ctd = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :oConTestData.Id];
        
        //insert new ContentDocumentLink
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.ShareType= 'V';
        newFileShare.LinkedEntityId = oConTestData.id;
        insert newFileShare ;
        
        String iJSON = '{ "ImageExport" : [ { "ParentID": "'+lstAccountTestData[0].ID+'" ,"ContentID": "'+oConTestData.ID+'" , "AttachmentID": "'+testcontent.contentdocumentid+'" } ]  }' ;
        
        req.requestBody = Blob.ValueOF( iJSON  )  ;
        
         system.debug ( 'INTESTCLASS>>????' + ((List<Content__c>)JSONHandlerMethods.deserialize(req.requestBody.toString().trim() ,'NeuronToPerceptiveProcess')).get(0) ) ;  
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';    
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res; 
        ExportAttachmentToPerceptiveRestService.sendFileToPerceptive();
        
        Test.StopTest() ; 
   }
   
   public testMethod static void sendFileToPerceptive2(){
             
        List<Account> lstAccountTestData=getAccountData();
        insert lstAccountTestData;
        Test.StartTest() ; 
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        Content__c oConTestData = new Content__c ( Account__c = lstAccountTestData[0].ID  ) ; 
        Insert oConTestData ;
        
        string sTesdata = 'Testing base 64 encode.bmp'; 
                   
        BLOB bAfterBlob =  BLOB.ValueOF( sTesdata ) ;
        
        //Insert contentdocument data
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger.jpeg';      
        cv.PathOnClient ='Penguins.123qwer';           
        cv.VersionData =bAfterBlob ;  
            
        insert cv;         
                                
        ContentVersion testContent = [SELECT id, ContentDocumentId , FileExtension FROM ContentVersion where Id = :cv.Id];

        List<ContentDocumentLink > ctd = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :oConTestData.Id];
        
        //insert new ContentDocumentLink
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.ShareType= 'V';
        newFileShare.LinkedEntityId = oConTestData.id;
        insert newFileShare ;
        
        String iJSON = '{ "ImageExport" : [ { "ParentID": "'+lstAccountTestData[0].ID+'" ,"ContentID": "'+oConTestData.ID+'" , "AttachmentID": "'+testcontent.contentdocumentid+'" } ]  }' ;
        
        req.requestBody = Blob.ValueOF( iJSON  )  ;
        
         system.debug ( 'INTESTCLASS>>????' + ((List<Content__c>)JSONHandlerMethods.deserialize(req.requestBody.toString().trim() ,'NeuronToPerceptiveProcess')).get(0) ) ;  
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';    
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res; 
        ExportAttachmentToPerceptiveRestService.sendFileToPerceptive();
        
        Test.StopTest() ; 
   }

}