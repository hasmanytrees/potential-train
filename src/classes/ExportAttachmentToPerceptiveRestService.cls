/*****************************************************************************************
    Name             : ExportAttachmentToPerceptiveRestService
    Description      : This REST webservice is used to to be called by ESB 
                       to get user selected Chatter file
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
******************************************************************************************/
@RestResource(urlMapping='/ExportAttachment/*')
global with sharing class ExportAttachmentToPerceptiveRestService{
   
      /**
    * Method name  : sendFileToPerceptive
    * Description  : This REST webservice is used to to be called by ESB to get user selected Chatter file
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    @HttpPost
    global static void sendFileToPerceptive() {
        RestRequest request = RestContext.request;
        
        
        //Getting Input JSON using JSONHandlerMethods
        Content__c content=
        ((List<Content__c>)JSONHandlerMethods.deserialize(request.requestBody.toString().trim() ,'NeuronToPerceptiveProcess')).get(0);
        
        //Getting Chatter Object of ContentDocumentLink
        List<ContentDocumentLink> listContentDocumentLink=
        [select Id,ContentDocumentId,LinkedEntityId,Visibility,
        ShareType from ContentDocumentLink where 
        ContentDocumentId=:(content.Comments__c)];
        
        
        //Getting latest Content's  body
        ContentVersion contentVersion=[select ContentDocumentId,VersionData,
        FileType,FileExtension,VersionNumber from ContentVersion where                                         
        ContentDocumentId=:listContentDocumentLink[0].ContentDocumentId 
        order by VersionNumber desc limit 1];
        
        RestResponse response = RestContext.response;
        
        
        MIME_Type__c mime=new MIME_Type__c();
        //Getting MIME content type based on Custom setting
        if(MIME_Type__c.getAll().get('.'+contentVersion.FileExtension.toLowerCase())!=null) 
        mime=MIME_Type__c.getAll().get('.'+contentVersion.FileExtension.toLowerCase());
        else
        mime.MIME_Type__c='application/octet-stream';
        response.addHeader('Content-Type', mime.MIME_Type__c);  // Adding dynamic content type
        response.responseBody = contentVersion.VersionData ;   // Adding File body
        
        
        
    }

}