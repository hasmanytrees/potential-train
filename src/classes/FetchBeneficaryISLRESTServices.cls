/*****************************************************************************
    Name             : FetchBeneficaryISLRESTServices
    Description      : This REST webservice is used to Call to query all 
                        Beneficiaries availaible for Encourager.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D               25-8-2015 
                                            
******************************************************************************/

@RestResource(urlMapping='/beneficiaries/availabletoencourage/*')
global class FetchBeneficaryISLRESTServices{

    /**
    * Method name  : getBeneficiaryList
    * Description  : This REST webservice is used to Call to query all 
                        Beneficiaries availaible for Encourager.
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    @HttpGet
    global static void getBeneficiaryList() {
        RestRequest request = RestContext.request;
       Integer iMAX_LIMIT=20;
       Map<String,String> mapParam=new Map<String,String>();
       
       for(String sParamName: RestContext.request.params.keySet()){
       if(RestContext.request.params.get(sParamName)!=null){
          
          if(sParamName.equalsIgnoreCase('id'))
           mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName));
         else
          mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName).toLowerCase());
         }
       }  
        if( mapParam.size()>0){
            RestContext.request.params.clear();
           RestContext.request.params.putAll(mapParam);
           
           
          }
        String sRegion= 
        RestContext.request.params.get('region'); 
        String sCountry= 
        RestContext.request.params.get('country'); 
        String sMinAge= 
        RestContext.request.params.get('min_age'); 
        String sMaxAge= 
        RestContext.request.params.get('max_age');
        String sGender= 
        RestContext.request.params.get('gender');
          String sSkip= 
        RestContext.request.params.get('skip');  
          String sTake= 
        RestContext.request.params.get('take');  
        RestContext.response.statusCode = 200 ; 
        
        try{
            
            String sActiveval = System.Label.Active ; 
            RestContext.response.addHeader('Content-Type', 'application/json');

            DateTime dtNow = System.now () ; 
            Date dlastSixMonthfromToday = System.Today().addMonths( -6 )  ; 
            SObjectType oAccSchema= Schema.getGlobalDescribe().get
            ('Account');
            Map<String,Schema.SObjectField> mapFieldSchema = 
            oAccSchema.getDescribe().fields.getMap();

            //Forming the query all fields for communication Preference object.
            String sQuery='select ';
            for(String sFieldVar: mapFieldSchema.keySet())
            sQuery+=sFieldVar+',';
            sQuery=sQuery.subStringbeforeLast(',');
            sQuery+=' from Account where ( Last_Correspondence_Date__c <: dlastSixMonthfromToday AND Last_Correspondence_Date__c != null )'+
                    ' AND (BEN_Encourager_Lock_Date__c <: dtNow OR BEN_Encourager_Lock_Date__c=null)'+
                    ' AND Status__c = :sActiveval ' ;
       
            // To Add Filter conditions to the logic 
            if(!String.IsBlank ( sCountry ) ){
                sQuery+=' and BEN_Country__c=:sCountry';
            } 
            if( !String.IsBlank ( sMinAge )  ){
                Integer iMinAge = Integer.ValueOf( sMinAge ) ; 
                
                sQuery+=' and  BEN_Age__c >=: iMinAge ';
            }
             if( !String.IsBlank ( sMaxAge ) ){
             
                Integer iMaxAge = Integer.ValueOf( sMaxAge ) ; 
                sQuery+=' and  BEN_Age__c <=: iMaxAge  ';
            }
            if( !String.IsBlank ( sGender ) ){
                sQuery+=' and Gender__c =:sGender';
            }
            
            // ORDER BY 
            sQuery+=' ORDER BY Last_Correspondence_Date__c  ASC NULLS LAST';
              if(sTake!=null && sTake!=''){
                 Integer iLimit=Integer.valueOf(sTake);
                 if( iLimit < 100 ) {
                      sQuery+=' Limit :iLimit';
                 }
                 else{
                      iLimit= 100;
                      sQuery+=' Limit :iLimit';
                 }
            }
            else{
            
               sQuery+=' Limit :iMAX_LIMIT';
            }
            if(sSkip !=null && sSkip!=''){
            
              Integer  iOffset=Integer.valueOf(sSkip );
              sQuery+=' offset :iOffset';
            
            }
           
            List<Account> lstBeneficiary =new List<Account>(); 
            lstBeneficiary=(List<Account> )Database.Query(String.escapeSingleQuotes(sQuery));
            
            if(lstBeneficiary.size()==0){
            RestContext.response.statusCode = 200; 
            return;
            }
            else{
                Map<String,List<sObject>> mapOutput= new Map<String,List<sObject>>();
                mapOutput.put('BeneficiaryEncourageGroup',lstBeneficiary);
                String sResponse=JSONHandlerMethods.serialize(mapOutput,
                'BenListAvailabletoEncourageProcess');
                sResponse=sResponse.replace('"null"', 'null');
                sResponse=sResponse.replace('true', 'true');
                sResponse=sResponse.replace('false', 'false');
                sResponse=sResponse.replace('\r\n', '');

                RestContext.response.responseBody = Blob.valueOf(sResponse);

            }
        }
        Catch(Exception ex ){
            RestContext.response.statusCode = 500 ; 
            
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'FetchBeneficaryRESTServices','Integration',
            'getBeneficiaryList','Insert Call',
            RestContext.request.requestBody.toString().trim(),UserInfo.getUserId(),
            'getBeneficiaryList'); 
        }    
        
    }  

}