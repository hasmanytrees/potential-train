/******************************************************************************
    Name             : SearchAccountByZipCodeController
    Description      : This class is visual force controller for page 
                       SearchAccountByZipCode which is used to search account 
                       based on zip code and radius
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                         optimization
Apurva                 05/08/2015        Changes made for COR0001229                
*******************************************************************************/
public with Sharing class SearchAccountByZipCodeController{

    public String sRecordId{get;set;}
    Public String sZIPCode{get;set;}
    public List<Account> lstMatchedAccount{get;set;}
    public String sDistanceSelected{get;set;}
    public String sUnitSelected{get;set;}
    public List<SelectOption> lstDistanceOption{get;set;}
    public List<SelectOption> lstUnitOption{get;set;}
    public boolean bDisplayTable{get;set;}
    public boolean bFlag{get;set;}
    public String sUrl{get;set;}
    public String sMessage{get;set;}
    public String sReportURL{get;set;}
    public boolean bShowPopUp{get;set;}
    //This is basic constructor
    public SearchAccountByZipCodeController(){

        lstDistanceOption=new List<SelectOption>();
        lstUnitOption=new List<SelectOption>();
        lstMatchedAccount=new List<Account>();
        for(Integer iIndexVar=1;iIndexVar<=10;iIndexVar++)
        lstDistanceOption.add(new SelectOption(String.valueOf((iIndexVar*10)),
        String.valueOf((iIndexVar*10)))); 
        //Generating distance Option list
        lstUnitOption.add(new SelectOption('km','Km'));

        lstUnitOption.add(new SelectOption('mile','Mile'));
        sDistanceSelected='10';
        //5-Aug- Apurva - Changes made for COR0001229
        //sUnitSelected='km';
        sUnitSelected='mile';
        bDisplayTable=false;




    }
    /**
    * Method name  : getNearByPinCodeList
    * Description  : This method is used to all zip code within a radius of user
                     specified zip code using call out
    *                
    * Return Type  : void
    * Parameter    : void
    **/  

    public void getNearByPinCodeList(){

        if(sZIPCode==''){
            
            ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.ERROR,System.label.ZIPCodeMissing); 
            //Please enter a ZIP Code
            ApexPages.addMessage(myMsg);
            
            bDisplayTable=false;
            return;      
        }
       else
        sZIPCode=sZIPCode.subString(0,5);
        HttpRequest request = new HttpRequest();
        sUrl='';
        bDisplayTable=false;

        //Making call out to get Zip codes
        Integration_Endpoints__c integrationDetails = 
        Integration_Endpoints__c.getAll().get('Zip Code Search'); 
        //Getting End point details using Zip code search
        sURL=integrationDetails.Endpoint_URL__c;
        sURL+=integrationDetails.Authorization_Code__c;
        sURL+='/radius.json/'+sZIPCode+'/'+sDistanceSelected+'/'+sUnitSelected;
       
        Http http= new Http();
        request.setEndPoint(sURL);
        request.setMethod('POST');
        HTTPResponse response ;
        response = http.send(request);

        if(response.getStatusCode()!=200 ){

            ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.ERROR,system.label.ErrorOccoredInZipSearch);
            //Some Error Occurred in Searching ZIP Code.Please check the zip 
            //code again.
            ApexPages.addMessage(myMsg);
            bDisplayTable=false;
            return;   
        }

        List<String> lstMatchedZipCode=new List<String>();
        
        String sResponseString=response.getBody();
        JsonHandler.ZipCodeSearchData zipData = (JsonHandler.ZipCodeSearchData)
        JSON.deserialize(sResponseString ,JsonHandler.ZipCodeSearchData .class);
        // Getting Zip codes from json
        //Getting all the ZIP codes
        for(JsonHandler.ZipCodeDetails zipDetails:zipData.zip_codes){
            lstMatchedZipCode.add(zipDetails.zip_code);
            
            
        }
        String sZipCodeString='';
        //Forming the filter condition for Report
        for(String sZipVar:  lstMatchedZipCode){
            if(sZipVar <> null && sZipVar <> '')
            sZipCodeString+=sZipVar+',';
        }    
        sZipCodeString=sZipCodeString.subStringBeforeLast(',');  
        

        Report oReport=[select Id from Report where developerName =: 
        System.label.AllZipCodeReport]; // Get report URL
        sReportURL='/'+oReport.Id+'?pv0='+sZipCodeString; 
        //Setting all found zip codes
       

        if(lstMatchedZipCode.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message
            (ApexPages.Severity.ERROR,System.Label.CheckZIPCriteria);
            //Please check Zip code and filter criteria.
            ApexPages.addMessage(myMsg);

            bDisplayTable=false;
            return;

        } 
        bDisplayTable=true;


    }

}