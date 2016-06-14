/*******************************************************************************
    Name             : OldAndNewJSONGeneratorHelper
    Description      : Trigger Helper class used to send Account changes to
                       Compass using ESB               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014       Created
Subhojit                29/01/2015       Modified for code re-factoring & 
                                         optimization
*******************************************************************************/
public class OldAndNewJSONGeneratorHelper{
    /**
    * Method name  : getOldAndNewJSON
    * Description  : Use this method to generate input JSON and send account 
    *               updates to Compass via ESB 
    *                
    * Return Type  : Void
    * Parameter    : String,String
    **/  
    @future(callout=true)
    public static void getOldAndNewJSON(String sOldAccountStr,
    String sNewAccountStr){

        
        List<Account> lstOldAccount=(List<Account>) JSON.deserialize
        (sOldAccountStr,List<Account>.class); 
        //Getting Trigger.Old from JSON String 
        List<Account> lstNewAccount=(List<Account>) JSON.deserialize
        (sNewAccountStr,List<Account>.class); 
        //Getting Trigger.New from JSON String 
        List<Account> lstOldAccountVar=new List<Account>();
         
        Map<Id,Account> mapAccount=new Map<Id,Account>();
        for(Account oAccountVar: lstNewAccount)
          mapAccount.put(oAccountVar.Id,oAccountVar);
        List<Map<String,List<sObject>>> lstOutputMap= 
                new List<Map<String,List<sObject>>>();  
    
        for(Account oAccountVar: lstOldAccount){
         Map<String,List<sObject>> mapObj=new Map<String,List<sObject>>();
        
         lstNewAccount=new List<Account>();
        
       
        //Creating Old Data for Account   
        
            if(oAccountVar.Legacy_Supporter_Id__c!=null){
            
        
          
              oAccountVar.Partner_Profile_Type__c=System.label.Old; 
                if(oAccountVar.Legacy_Supporter_Id__c.contains
                (System.label.Hyphen)){
                    
                    oAccountVar.Legacy_Supporter_Id__c = 
                    (oAccountVar.Legacy_Supporter_Id__c).trim
                    ().subStringAfter(System.label.Hyphen); 
                    //Setting Supporter Id before -
                  }  
                    
                   lstNewAccount.add(oAccountVar);
                    
               
            }
        
            if(mapAccount.get(oAccountVar.Id)!=null){
            
              Account oAccountNewVar=mapAccount.get(oAccountVar.Id);
             
                oAccountNewVar.Partner_Profile_Type__c=System.label.New; 
                //Setting State token as New
            
                if(oAccountNewVar.Legacy_Supporter_Id__c!=null){
                    if(oAccountNewVar.Legacy_Supporter_Id__c.contains
                    (System.label.Hyphen)){
                        
                        oAccountNewVar.Legacy_Supporter_Id__c = 
                        (oAccountNewVar.Legacy_Supporter_Id__c).trim().subStringAfter
                        (System.label.Hyphen); 
                      }
                        //Setting Supporter Id before -
                      
                      
                        lstNewAccount.add(oAccountNewVar);  
                    mapObj.put('NewJSON',lstNewAccount);
                 lstOutputMap.add(mapObj );
                
                 
                }
                
               
              } 
           } 
    
      if(lstOutputMap.size()>0){ 
     
       
       
        String sResponse=JSONHandlerMethods.serializeBulk(lstOutputMap,
                'SampleBiztalkJSON');  
        sResponse=sResponse.replaceall('\r\n',''); 
        sResponse=sResponse.replaceall(':"null"',':null');    
        sResponse=sResponse.replaceAll('\\n','');
        sResponse=sResponse.replaceAll('\\\\','');
       sResponse+=']}';
       sResponse='{"Supporters": ['+sResponse;
        System.debug('>>>>>'+sResponse);
       
        HttpRequest request;
        HttpResponse response;
        Http http;
        request = new HttpRequest();
        response = new HttpResponse();
        http = new Http();
        if(!Test.isRunningtest())
        request.setHeader('Authorization', 
        new MasheryOAuthGenerator().generateMasheryOAuth ());  
        //Adding authorization Header
        
        request.setHeader('Content-Type','application/json');
        Integration_Endpoints__c oConnector = 
        Integration_Endpoints__c.getAll().get('Compass Endpoint');  
        // Getting ESB end point
        request.setEndpoint
      (oConnector.Endpoint_URL__c+'?api_key='+oConnector.Authorization_Code__c);
        
        request.setMethod('POST');
        request.setBody(sResponse);
        
        request.setTimeout(30000);
        if(!Test.isRunningtest()){
            response = http.send(request);
           
            
          }
        
        
       } 
    }

   

    
}