/******************************************************************************
Name             : CommunicationPreferenceRESTService
Description      : This REST webservice is used to Call to query all Account 
                   and related Contact for that Volunteer till that Time                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                  29/04/2015            Created
******************************************************************************/
@RestResource(urlMapping='/getCommunicationPreference')
global class CommunicationPreferenceRESTService{

    @HttpGet
    global static void getCommunicationPreference() {
     try{ 
        //Taking URL parameters
        String sSalesforceId= 
        RestContext.request.params.get(System.Label.personid); 
        RestContext.response.addHeader('Content-Type', 'application/json');
        Map<String,String> mapCorospondenceDelivery=new  Map<String,String>();
        for(Correspondence_Delivery_Preference_Map__c oCommPrefVar :Correspondence_Delivery_Preference_Map__c.getAll().values())
            mapCorospondenceDelivery.put(oCommPrefVar.Preference__c,oCommPrefVar.Other_Preferences__c);
        List<Communication_Preference__c> lstCommunicationPreferenceRetrieved = new List<Communication_Preference__c>();
         Account oAccountVar=new Account();
        //SOQL Query to get all Contact Related to that Account
        if(sSalesforceId!=null)
        {   
            //This parameter is set if to show full page
            SObjectType communicationPreferenceType = Schema.getGlobalDescribe().get
            ('Communication_Preference__c');
             Map<String,Schema.SObjectField> mapFieldSchema = 
            communicationPreferenceType.getDescribe().fields.getMap();     
            String sQuery='select Account__r.Correspondence_Delivery_Preference__c,Account__r.Preferred_Email_Address__c, Account__r.Mobile_Phone__c,Account__r.Do_Not_Call__c,Account__r.Do_Not_Contact__c, Account__r.Do_Not_Email__c, Account__r.Preferred_Phone_No__c, ';
            for(String sFieldVar: mapFieldSchema.keySet())
            sQuery+=sFieldVar+',';
            
            sQuery=sQuery.subStringbeforeLast(',');
            sQuery+=' from Communication_Preference__c  where Account__r.Legacy_Partner_Id__c = :sSalesforceId  OR Account__r.Legacy_Supporter_Id__c = :sSalesforceId OR Account__c = :sSalesforceId ';
            //Getting all field values of related Account's communication record.
            lstCommunicationPreferenceRetrieved =(List<Communication_Preference__c>)Database.query(sQuery);   
        }
        
        if(lstCommunicationPreferenceRetrieved.size()==0){
        
            RestContext.response.statusCode = 404 ;
            return ;
        }
        else{
        
            Map<String,List<sObject>> mapOutput= 
            new Map<String,List<sObject>>();
           List<Communication_Preference__c> lstCommPreferenceCategory=new List<Communication_Preference__c>();
           List<Communication_Preference__c> lstCommPreferenceSubscription=new List<Communication_Preference__c>();
           
           for(Communication_Preferences__c commPrefCSVar: [select Id,Name,Mapping_Fields__c,Is_Subscription__c,Is_Category__c from Communication_Preferences__c        
                                                               where Is_Displayed_On_Page__c=true
                                                               and (Is_Subscription__c=true OR Is_Category__c=true)]){
                                                               
                                                               
                                                               
                 
                 Communication_Preference__c oCommPrefVar=new Communication_Preference__c();
                 
                 
               
                 
                   for(String sFieldStrVar: commPrefCSVar.Mapping_Fields__c.split(';')){
                  
                    
                     
                        if(sFieldStrVar.contains('Email'))
                            oCommPrefVar.put('Account_Information_Email_Opt_Out__c',lstCommunicationPreferenceRetrieved[0].get(sFieldStrVar));
                        else if(sFieldStrVar.contains('_Mail_'))
                            oCommPrefVar.put('Account_Information_Mail_Opt_Out__c',lstCommunicationPreferenceRetrieved[0].get(sFieldStrVar));
                         else if(sFieldStrVar.contains('Text'))
                            oCommPrefVar.put('Account_Information_Text_Opt_Out__c',lstCommunicationPreferenceRetrieved[0].get(sFieldStrVar));
                          else if(sFieldStrVar.contains('Medium')){
                            oCommPrefVar.put('Account_Information_Medium__c',lstCommunicationPreferenceRetrieved[0].get(sFieldStrVar)); 
                            oCommPrefVar.put('SIMS_Ongoing_Language__c',lstCommunicationPreferenceRetrieved[0].get(sFieldStrVar));
                            }
                            
                            
                        
                                           
                   }
                  
                                              
                  String sCommPrefType=commPrefCSVar.Name;
                   oCommPrefVar.Account_Information_Language__c=sCommPrefType.replace(' ','');
                    oCommPrefVar.Account_Information_Language__c=oCommPrefVar.Account_Information_Language__c.replace('/','');
                   oCommPrefVar.SIMS_Journey_Medium__c=sCommPrefType.replace(' ','').replace('/','');
                 
                  if(commPrefCSVar.Is_Category__c )
                   lstCommPreferenceCategory.add(oCommPrefVar);
                  else
                     lstCommPreferenceSubscription.add(oCommPrefVar);
           }
           
           
           if(lstCommPreferenceSubscription.size()>0){
           
             for(Communication_Preference__c oCommPrefVar: lstCommunicationPreferenceRetrieved ){
             
                   if(oCommPrefVar.Account__r.Correspondence_Delivery_Preference__c!=null)                       
                        oCommPrefVar.put('SIMS_Ongoing_Language__c',mapCorospondenceDelivery.get(oCommPrefVar.Account__r.Correspondence_Delivery_Preference__c)); 
                   else
                          oCommPrefVar.put('SIMS_Ongoing_Language__c','null'); 
                   oCommPrefVar.put('SIMS_Journey_Medium__c','CorrespondenceDeliveryPreference');
                  
                   lstCommPreferenceSubscription.add(oCommPrefVar);
             }
         
           }
           
           
            for(Communication_Preference__c oCommunicationPrefVar: lstCommunicationPreferenceRetrieved)
            {   
                    oAccountVar.Cultivation_Status__c=oCommunicationPrefVar.Account__r.Preferred_Email_Address__c;
                    oAccountVar.Education_Level__c=oCommunicationPrefVar.Account__r.Preferred_Phone_No__c;
                    //oCommunicationPrefVar.Volunteer_Appeals_Active__c = oCommunicationPrefVar.Account__r.Do_Not_Email__c;     
                    oAccountVar.Do_Not_Email__c= oCommunicationPrefVar.Account__r.Do_Not_Email__c; 
                     oAccountVar.Do_Not_Call__c= oCommunicationPrefVar.Account__r.Do_Not_Call__c;  
                       oAccountVar.Do_Not_Contact__c= oCommunicationPrefVar.Account__r.Do_Not_Contact__c;    
                    oAccountVar.Mobile_Phone__c =  oCommunicationPrefVar.Account__r.Mobile_Phone__c;            
            }
            mapOutput.put('OtherCommunicationPreferenceResponseProcessGroup',lstCommunicationPreferenceRetrieved); 
            mapOutput.put('AccountCommunicationPreferenceResponseProcessGroup',new List<Account>{oAccountVar});
            mapOutput.put('CategoryCommunicationPreferenceResponseProcessListGroup',lstCommPreferenceCategory);
            mapOutput.put('SubscriptionCommunicationPreferenceGroup',lstCommPreferenceSubscription);
            //Getting Final JSON String
            String sResponse=
            JSONHandlerMethods.serialize(mapOutput,
            System.Label.CommunicationPreferenceResponseProcess); 
            
            RestContext.response.addHeader('Content-Type', 'application/json');
             // Sending the response back
            sResponse=sResponse.replace('"null"', 'null');
            sResponse=sResponse.replace('true', 'true');
            sResponse=sResponse.replace('false', 'false');
            Integer iCount=sResponse.countMatches('"mediumss":');
            while(sResponse.contains('mediumss')){
              
            
              String sSubStr=sResponse.subStringbetween('"mediumss":','}');
              
             //if( !sSubStr.contains('["')){
              String sNewString='[';
             
                 
               sSubStr=sSubStr.replace('"','');
              
              if(sSubStr.contains(';')){
          
                for(String sMedium : sSubStr.split(';'))
                   sNewString+='"'+sMedium +'",';
                   
              
             
              sNewString=sNewString.subStringBeforeLast(',');
              sNewString+=']';
            
            }
            else{
              
            if(!sSubStr.equalsIgnoreCase('null'))
              sNewString+='"'+sSubStr+'"]';
            else 
             sNewString+=']';
            
            
            }
          
          
             sResponse=sResponse.replaceFirst('mediumss','Medium_NameArray');
           if(sSubStr!='null'){
           
            
             
             sResponse=sResponse.replace(':"'+sSubStr+'"',':'+sNewString);
            
             
             }
           else
             sResponse=sResponse.replace('"Medium_NameArray":null','"Medium_NameArray":[]');
           
         
         } 
      //  }
            RestContext.response.responseBody = Blob.valueOf(sResponse); 
        }
      }
      catch(Exception ex){
             RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration
            ('500',ex.getMessage()+'\n'+ex.getStackTraceString(),
            'CommunicationPreferenceRESTService','Integration','CommunicationPreferenceRESTService'
            ,'Inbound Call',URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/apexrest/'+RestContext.request.requestURI+'?'
            + Utility.retrieveRESTParameters
            (RestContext.request.params.keyset()),
            UserInfo.getUserId(),'getAccountBO');
      }  
    }
}