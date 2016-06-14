/****************************************************************************
    Name             : FileDownloaderController
    Description      : This visual force controller for page FileDownloader.It
                    is used to download file from Perceptive via ESB
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                        optimization
******************************************************************************/

public without Sharing class FileDownloaderController{

    public Transient String sBlobFileStr;
    private String sContentId;
    public boolean bShowLink{get;set;}
    public String sMIMEType{get;set;}
    public boolean bShow{get;set;}
    public String sResponse{get;set;}
    public String sURL{get;set;}
    public String sOAuthToken{get;set;}
    public String sSelectedValue{get;set;}
    public String sSBCName{get;set;}
    public String getsBlobFileStr(){
        //Get the file in visual force
        return sBlobFileStr;

    }

    //This constructor is used to get the related content record Id
    public FileDownloaderController(){
        sSelectedValue = (ApexPages.currentPage().getParameters()
        .get('type')).subStringBefore('?parent_domain');
        sContentId=(ApexPages.currentPage().getParameters()
        .get('contentId')).subStringBefore('?parent_domain');
        bShow = false;
        bShowLink=false;
        // getFileFromPerceptive();
    }

    /**
    * Method name  : getFileFromPerceptive
    * Description  : this method is used to make call out ESB and get file from 
    *                Perceptive.
    * Return Type  : Void
    * Parameter    : void
    **/  
    public void getFileFromPerceptive(){
        
        
        Http http = new Http();
        List<SBC_Communications__c > lstContent=[select Id,Name,Original_Letter_URL__c, Final_Letter_URL__c
        from SBC_Communications__c where Id=:sContentId]; 
        if(lstContent.size()>0)
        sSBCName=lstContent[0].Name+'-Original.jpeg';
        //Getting attachment type for setting Content type header
        //if(lstContent[0].Attachment_Type__c!=null)
         sMIMEType='image/jpeg' ;
        //else
       // sMIMEType='application/octet-stream';    //Basic Content type
        Map<String,List<sObject>> mapOutput=new Map<String,
        List<sObject>>{'GetFileFromPerceptiveProcessFieldGroup'=>lstContent}; 
        sResponse=JSONHandlerMethods.serialize(mapOutput,
        'GetFileFromPerceptiveProcess');  
        //Generating Request input JSON using JSONHandlerMethods
        String sAppendURL ='';
        if(sSelectedValue <> '' && sSelectedValue <> 'blank')
        {
            if(sSelectedValue == 'Original')
            {
                if(lstContent[0].Original_Letter_URL__c <> null && lstContent[0].Original_Letter_URL__c <> '')
                {
                    SAppendURL = lstContent[0].Original_Letter_URL__c;
                }
                else
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                    System.label.EmptyOriginalLetter);
                    //Error Occurred while retrieving file from Perceptive.Please contact 
                    //system Administrator.
                    ApexPages.addMessage(myMsg);
                    bShow=true;
                }
            }
            else if(sSelectedValue == 'Final')
            {
                if(lstContent[0].Final_Letter_URL__c <> null && lstContent[0].Final_Letter_URL__c <> '')
                {
                  
                    SAppendURL = lstContent[0].Final_Letter_URL__c;
                }
                else
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                    System.label.EmptyFinalLetter);
                    //Error Occurred while retrieving file from Perceptive.Please contact 
                    //system Administrator.
                    ApexPages.addMessage(myMsg);
                    bShow=true;
                }
            }
            // Instantiate a new HTTP request, specify the method (POST) as well as 
            //the endpoint
            if(!bShow){
                try{
                    
                    HttpRequest request = new HttpRequest();
                    Integration_Endpoints__c connector = 
                    Integration_Endpoints__c.getAll().get('Perceptive File Query');
                    //Getting ESB end point for call out
                    sURL = sAppendURL+'?api_key='+connector.Authorization_Code__c;
                    request.setEndpoint(sURL);
                    request.setMethod('GET');
                    request.setTimeout(120000);
                    request.setHeader('Authorization',
                    (new MasheryOAuthGenerator().generateMasheryOAuth ())); 
                    //Setting Authorization header
                    request.setHeader('Content-Type', 'text/json');
                    
                    // Send the request, and return a response
                    HttpResponse response = http.send(request);
                    if(response.getStatus()=='OK' || response.getStatus()=='Found'){
                        ApexPages.Message myMsg = new 
                        ApexPages.Message(ApexPages.Severity.INFO,
                        'Your file is Loading.Please Wait...');
                        ApexPages.addMessage(myMsg);
                        sBlobFileStr=EncodingUtil.base64Encode(response.getBodyAsBlob());
                        bShowLink=true;
                        bShow=false;
                    }
                    else{
                        //For Error during call out
                        ApexPages.Message myMsg = new 
                        ApexPages.Message(ApexPages.Severity.INFO,
                        System.label.ESBErrorInDownload);
                        //Error Occurred while retrieving file from Perceptive.Please 
                        //contact system Administrator.
                        ApexPages.addMessage(myMsg);
                        bShow=true;
                        Utility.insertErrorLogIntegration(String.valueOf(response
                        .getStatusCode()) ,'','FileDownloaderController',
                        'Integration','FileDownloaderController','Outbound Call',
                        request.getEndPoint(),UserInfo.getUserId(),'getFileFromPerceptive'); 
                    }
                }
                catch(Exception ex){
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                    System.label.ESBErrorInDownload);
                    //Error Occurred while retrieving file from Perceptive.Please contact 
                    //system Administrator.
                    ApexPages.addMessage(myMsg);
                    bShow=true;
                    
                }
            }
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.NoSelection);
            //Error Occurred while retrieving file from Perceptive.Please contact 
            //system Administrator.
            ApexPages.addMessage(myMsg);
            bShow=true;
        }
    }

}