/*****************************************************************************************
    Name             : UpdateCommunicationPrefRESTService
    Description      : This REST webservice is used to updating Communication Preferences    
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 08/10/2015        Created and Code Optimization
******************************************************************************************/


@RestResource(urlMapping='/updateCommPref')
global with Sharing Class UpdateCommunicationPrefRESTService{


    /**
    * Class name  : Subscription 
    * Description  : Use this wrapper to capture Subscription data from JSON
    * Return Type  : void
    * Parameter    : void
    **/
    
    public class Subscription {
        public String Name;
        public List<String> Medium_NameArray;
    }

    /**
    * Class name  : Mediums 
    * Description  : Use this wrapper to capture Mediums data from JSON
    * Return Type  : void
    * Parameter    : void
    **/
    
    public class Mediums {
    }

    /**
    * Class name  : InboundCommPref
    * Description  : Use this wrapper to capture Communication Preference data from JSON
    * Return Type  : void
    * Parameter    : void
    **/
    
    public class InboundCommPref{
        public Boolean Supporter_PlainTextEmail;
       
        public Boolean Supporter_DoNotCall;
        public Boolean Supporter_DoNotContact;
        public Boolean Supporter_DoNotEmail;
        public String Supporter_MobilePhoneNumber;
        public String  Id;
        public List<Categories> CategoryArray;
        public List<Subscription> SubscriptionArray;
    }
    
    /**
    * Class name  : Categories
    * Description  : Use this wrapper to capture Categories data from JSON
    * Return Type  : void
    * Parameter    : void
    **/
    
    public class Categories{
        public String Name;
        public Boolean OptOutEmail;
        public Boolean OptOutMail;
        public Boolean OptOutText;
        public List<String> Medium_NameArray;
    }

     /**
    * Method name  : updateAccount
    * Description  : Use this method to update Account record
    *                
    * Return Type  : void
    * Parameter    : void
    **/

    @HttpPost
    global static void  updateAccount() {
        RestRequest request = RestContext.request;
        try{
            
            RestContext.response.statusCode = 200;  
             Map<String,String> mapCorospondenceDelivery=new  Map<String,String>();
            for(Correspondence_Delivery_Preference_Map__c oCommPrefVar :Correspondence_Delivery_Preference_Map__c.getAll().values())
                mapCorospondenceDelivery.put(oCommPrefVar.Other_Preferences__c,oCommPrefVar.Preference__c); 
                
            // added debug 
                     
            InboundCommPref inboundCommPrefVar= 
            (InboundCommPref )JSON.deserialize
            (request.requestBody.toString().trim() ,InboundCommPref.class);
            Communication_Preference__c oCommPrefVar=new Communication_Preference__c(Id=inboundCommPrefVar.Id);
            List<Communication_Preferences__c> lstCommPrefCS=new List<Communication_Preferences__c>();
               Account oAccountVar=new Account(Id=[select Account__c from Communication_Preference__c where Id =:oCommPrefVar.Id limit 1].Account__c);
            lstCommPrefCS=Communication_Preferences__c.getAll().values();
            
            for(Communication_Preferences__c oCommPrefCSVar : lstCommPrefCS){                
                
                if(oCommPrefCSVar.Is_Displayed_On_Page__c){
                    
                    if(oCommPrefCSVar.Name.Contains('Other Preferences')){
                        
                        oCommPrefVar.put(oCommPrefCSVar.Mapping_Fields__c,inboundCommPrefVar.Supporter_PlainTextEmail);                        
                    }
                   
                    
                    if(oCommPrefCSVar.Is_Category__c){
                        
                        for(Categories categoryVar :inboundCommPrefVar.CategoryArray){
                            
                            for(String sFieldVar  : oCommPrefCSVar.Mapping_Fields__c.split(';')){
                                
                                if(oCommPrefCSVar.Name.replace(' ','').replace('/','')==categoryVar.Name){
                                    
                                    if(sFieldVar.Contains('Email'))
                                    oCommPrefVar.put(sFieldVar,categoryVar.OptOutEmail);
                                    else  if(sFieldVar.Contains('_Mail'))
                                    oCommPrefVar.put(sFieldVar,categoryVar.OptOutMail);
                                    else  if(sFieldVar.Contains('Text'))
                                    oCommPrefVar.put(sFieldVar,categoryVar.OptOutText);
                                    else if(sFieldVar.Contains('Medium')){
                                        String sMediumVar='';
                                        for(String sMediumStrVar: categoryVar.Medium_NameArray)
                                        sMediumVar+=sMediumStrVar+';';
                                        
                                        sMediumVar=sMediumVar.SubStringBeforeLast(';');
                                        oCommPrefVar.put(sFieldVar,sMediumVar);
                                    }
                                }
                            }
                        }
                    }
                    if(oCommPrefCSVar.Is_Subscription__c){
                        for(Subscription  subscriptionVar :inboundCommPrefVar.SubscriptionArray){
                            
                             if(subscriptionVar.Name.Contains('CorrespondenceDeliveryPreference')){
                                 String sMediumVar='';
                              for(String sMediumStrVar: subscriptionVar.Medium_NameArray)
                                   sMediumVar+=sMediumStrVar+';';
                                if(( subscriptionVar.Medium_NameArray!=null)&&( subscriptionVar.Medium_NameArray.size()==0)) 
                                      sMediumVar+='None'; 
                                 if(sMediumVar!=''){
                                   sMediumVar=sMediumVar.SubStringBeforeLast(';');
                                   oAccountVar.Correspondence_Delivery_Preference__c=mapCorospondenceDelivery.get(sMediumVar);
                                   
                                   }
                                
                                }
                    
                         
                         
                            for(String sFieldVar  : oCommPrefCSVar.Mapping_Fields__c.split(';')){
                                
                                String sName=oCommPrefCSVar.Name.replace(' ','');
                                if(sName.contains('/'))
                                sName=sName.replace('/','');
                                                      
                                if(sName.equalsIgnoreCase(subscriptionVar.Name)){                                    
                                    
                                    if(sFieldVar.Contains('Medium')){
                                        String sMediumVar='';
                                        for(String sMediumStrVar: subscriptionVar.Medium_NameArray)
                                        sMediumVar+=sMediumStrVar+';';
                                        
                                        sMediumVar=sMediumVar.SubStringBeforeLast(';');
                                        oCommPrefVar.put(sFieldVar,sMediumVar);
                                    }
                                }
                            }
                        }
                    }
                }
            }
         
            oAccountVar.Do_Not_Call__c=inboundCommPrefVar.Supporter_DoNotCall;
            oAccountVar.Do_Not_Contact__c=inboundCommPrefVar.Supporter_DoNotContact;
            oAccountVar.Do_Not_Email__c=inboundCommPrefVar.Supporter_DoNotEmail;
            oAccountVar.Mobile_phone__c=inboundCommPrefVar.Supporter_MobilePhoneNumber;
            oAccountVar.Override_Account_Validation__c=true;
            oAccountVar.dupcheck__dc3DisableDuplicateCheck__c=true;
           
            update oAccountVar;
            update oCommPrefVar;
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf('{"Message":"Transaction Successful"}');

        }
        catch(Exception ex){
            
            RestContext.response.statusCode = 500 ;
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf('{"Message":"Transaction Failed"}');
            Utility.insertErrorLogIntegration
            ('500',ex.getMessage()+'\n'+ex.getStackTraceString(),
            'UpdateCommunicationPrefRESTService','Integration','UpdateCommunicationPrefRESTService'
            ,'Inbound Call',URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/apexrest/'+RestContext.request.requestURI+'?'
            + Utility.retrieveRESTParameters
            (RestContext.request.params.keyset()),
            UserInfo.getUserId(),'updateCommPref');
            
        }
    }
}