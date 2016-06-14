/******************************************************************************
    Name             : CreateSBCCommunicationRESTServices
    Description      : This REST webservice is used to insert 
                    SBC Communications Records in Salesforce.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 10/06/2014        Created
*****************************************************************************/
@RestResource(urlMapping='/createSBCCommunication')
global class CreateSBCCommunicationRESTServices
{

    /**
    * Method name  : CreateSBCCommunicationRESTServices
    * Description  : Use this method to insert 
                    SBC Communications Records in Salesforce.
    *                
    * Return Type  : void
    * Parameter    : Void
    **/  

    @HttpPost
    global static void CreateSBCCommunicationRESTServices() {
        RestRequest request = RestContext.request;
        try{
         String sRequestBody= request.requestBody.toString();
         system.debug('*****sRequestBody' + sRequestBody);
         RestContext.response.statusCode = 201; 
         if(!sRequestBody.contains('"IsReadBySupporter"')  ){
            String sResponse = performSBCInsert('CreateSBCCommunicationRESTServices',request.requestBody.toString());
            RestContext.response.responseBody = Blob.valueOf(sResponse);
            return;
         }
         else{
             
            List<SBC_Communications__c> lstSBC= 
            (List<SBC_Communications__c>)JSONHandlerMethods.deserialize
            (request.requestBody.toString().trim() ,'SBCReadISLProcess');
          
          if(lstSBC!=null && lstSBC.size()>0)
          {
              update lstSBC;
              RestContext.response.statusCode = 200; 
              //RestContext.response.statusCode = 201; 
          }
               
           
            RestContext.response.addHeader('Content-Type', 'application/json');
           
         }
            
        }
        catch(Exception ex){
            
            RestContext.response.statusCode = 500 ; 
             RestContext.response.addHeader('Content-Type', 'application/json');
            Account oAccount=new Account(Background__c='Failure',Description=ex.getMessage());
            
            Map<String,List<sObject>> mapOutputMsg=new Map<String,List<sObject>>();
            mapOutputMsg.put('CompassMessageGroup',
            new List<Account>{oAccount});
            String sResponse=JSONHandlerMethods.serialize
            (mapOutputMsg,'CompassMessage'); 
            RestContext.response.responseBody = Blob.valueOf(sResponse);
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'CreateSBCCommunicationRESTServices','Integration',
            'CreateSBCCommunicationRESTServices','Insert Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'createSBCCommunication');
            
        } 
    }
    /**
    * Method name  : performSBCInsert
    * Description  : Use this method to insert SBC Communication record and get Response.
    *                
    * Return Type  : void
    * Parameter    : String ,String 
    **/  

    global static String performSBCInsert(String sInvocationType, String sRequestBody)
    {
      
        Map<String,String> mapCIUSAStatusValues = new Map<String,String>();
        for(CI_To_USA_Integration_Value_Mapping__c oMapVar : CI_To_USA_Integration_Value_Mapping__c.getAll().values())
        {
            String sUniqueKey = oMapVar.CI_Value__c + '' + oMapVar.Direction_c__c;
            mapCIUSAStatusValues.put(sUniqueKey, oMapVar.US_Value__c);
        }
        
        
        String TransactionId = '';
        RestContext.response.statusCode = 200; 
        RestContext.response.statusCode = 201; 
        RestContext.response.addHeader('Content-Type', 'application/json');
        String sRequest=sRequestBody.trim();
        List<SBCCommunicationDetailsList.SBCCommunicationDetails> lstSBCComm = 
        ( (SBCCommunicationDetailsList.SBCCommunicationDetailsFin)JSON.deserialize
        (sRequestBody.trim() ,SBCCommunicationDetailsList.SBCCommunicationDetailsFin.class)).SBCCommunicationDetails;
        Set<String > setAccounts=new Set<String>();
        boolean bIsGloablIdPresent=true;
        for(SBCCommunicationDetailsList.SBCCommunicationDetails  sbcVar:  lstSBCComm ){
            
            if(sbcVar.Supporter_GlobalId <> NULL)
                setAccounts.add(sbcVar.Supporter_GlobalId);
            if(sbcVar.Supporter_CompassConstituentId <> NULL)
                setAccounts.add(sbcVar.Supporter_CompassConstituentId);
            if(sbcVar.Beneficiary_LocalId <> NULL)
                setAccounts.add(sbcVar.Beneficiary_LocalId);
            if(sbcVar.Beneficiary_GlobalId <> NULL)
                setAccounts.add(sbcVar.Beneficiary_GlobalId);   
            if((sbcVar.CompassionSBCId==null) && (bIsGloablIdPresent) )
               bIsGloablIdPresent=false;      
        } 
        
        List<Account> lstAccount=new List<Account>();
        List<Correspondence_Delivery_Preference_Map__c> lstDelPref=new   List<Correspondence_Delivery_Preference_Map__c>();
        lstDelPref=Correspondence_Delivery_Preference_Map__c.getAll().values();         
        lstAccount=[select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,
        Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
        Special_Handling__c,Preferred_Name__c,Global_ID__c,BEN_Local_Id__c,BEN_Id__c,
        Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
        Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c from Account where 
        Global_Id__c IN : setAccounts OR Legacy_Supporter_Id__c IN : setAccounts OR BEN_Id__c IN : setAccounts OR BEN_Local_Id__c IN : setAccounts];
        Map<String,Account> mapAccount=new Map<String,Account>();
        Map<String,Account> mapAccountId=new Map<String,Account>();

        for(Account oAccountVar: lstAccount){
            
            if((oAccountVar.RecordTypeId==Utility.getRecordtype('Supporter','Account'))||((oAccountVar.RecordTypeId==Utility.getRecordtype('Partner','Account')))){
              if(oAccountVar.Legacy_Supporter_Id__c <> NUll)
                mapAccount.put(oAccountVar.Legacy_Supporter_Id__c,oAccountVar);
               
                mapAccountId.put(oAccountVar.Id,oAccountVar);
                if(oAccountVar.Global_Id__c <> NUll)
                mapAccount.put(oAccountVar.Global_Id__c ,oAccountVar);
            }
            else if(oAccountVar.RecordTypeId==Utility.getRecordtype('Beneficiary','Account')){
             if(oAccountVar.Compass_Child_Key__c<> NUll)
                mapAccount.put(oAccountVar.Compass_Child_Key__c,oAccountVar);
               if(oAccountVar.BEN_Local_Id__c <> NUll)
                mapAccount.put(oAccountVar.BEN_Local_Id__c ,oAccountVar);
               if(oAccountVar.BEN_Id__c <> NUll)
                mapAccount.put(oAccountVar.BEN_Id__c ,oAccountVar);
                
            }
            
        }
        
        //Setting values for SBC Communication
        Map<Id, List<SBCCommunicationDetailsList.SBCCommunicationDetails>> mapSBCWrpVar=new Map<Id, List<SBCCommunicationDetailsList.SBCCommunicationDetails>>();
        Map<String,SBCCommunicationDetailsList.SBCCommunicationDetails> mapSBCWrpIdVar=new Map<String,SBCCommunicationDetailsList.SBCCommunicationDetails>();
        List<SBC_communications__c> lstSBCCommFinal=new List<SBC_communications__c>();
        for(SBCCommunicationDetailsList.SBCCommunicationDetails svcVar: lstSBCComm ){
            SBC_communications__c oSBCVar=new SBC_communications__c();
            oSBCVar.Final_Letter__c=(svcVar.IsFinalLetter!=null)?svcVar.IsFinalLetter:false;
            oSBCVar.Final_Letter_Archived__c=(svcVar.IsFinalLetterArchived!=null)?svcVar.IsFinalLetterArchived:false;
            oSBCVar.Final_Letter_URL__c=svcVar.FinalLetterURL;
            oSBCVar.Number_Of_Pages__c =svcVar.NumberOfPages;
            //oSBCVar.NumberOfPages =svcVar.Number_Of_Pages__c;
            oSBCVar.Font__c=svcVar.Font;
            oSBCVar.Font_Size__c=(svcVar.FontSize!=null)?String.valueOf(svcVar.FontSize):'';
            oSBCVar.SBC_Global_Id__c=svcVar.CompassionSBCId;
            // oSBCVar.Id=svcVar.GlobalPartnerSBCId;
            oSBCVar.Gift_Not_Scanned_Eligible__c=(svcVar.ItemNotScannedEligible!=null)?svcVar.ItemNotScannedEligible:false;
            oSBCVar.Gift_Not_Scanned_Not_Eligible__c=(svcVar.ItemNotScannedNotEligible!=null)?svcVar.ItemNotScannedNotEligible:false;
            oSBCVar.Original_Language__c=svcVar.OriginalLanguage;
            oSBCVar.Original_Letter_Archived__c=(svcVar.IsOriginalLetterArchived!=null)?svcVar.IsOriginalLetterArchived:false;
            oSBCVar.Original_Letter_URL__c=svcVar.OriginalLetterURL;
            oSBCVar.Original_Text__c=svcVar.OriginalText;
            
            if(svcVar.NumberOfPages!=null)
               oSBCVar.Number_Of_Pages__c=svcVar.NumberOfPages;
            
            String sDirection ='';
            if(svcVar.Direction.startsWith('Supporter'))
            sDirection = 'Supporter To Beneficiary';
            else
            sDirection = 'Beneficiary To Supporter';
            String sKey = svcVar.SBCGlobalStatus+ '' + sDirection;
                oSBCVar.Status__c = mapCIUSAStatusValues.get(sKey);
            oSBCVar.Template_ID__c=svcVar.Template;
            oSBCVar.Transaction_ID__c=svcVar.Internal_Perceptive_TransactionId ;
            oSBCVar.Translated_Text__c=svcVar.TranslatedText;
            oSBCVar.Translation_Language__c=svcVar.TranslationLanguage;
            oSBCVar.Read__c=false;
             if(svcVar.ReasonForRework!=null)
                       oSBCVar.Communication_Issue_Description__c=svcVar.ReasonForRework;
                    
            
            if(svcVar.DatePhysicalReceived!=null){      
                    
               if(svcVar.DatePhysicalReceived.contains('T')){       
                 svcVar.DatePhysicalReceived=svcVar.DatePhysicalReceived.replaceAll('T',' ');       
                  svcVar.DatePhysicalReceived=svcVar.DatePhysicalReceived.subStringBeforelast('Z');     
                   oSBCVar.Date_Physical_Received__c=  Date.valueOf(svcVar.DatePhysicalReceived);       
                }       
                //Apurva- Added Batch Id and Sequence Id
                oSBCVar.Sequence_ID__c = svcVar.Internal_Perceptive_SequenceNumber;
                oSBCVar.Batch_ID__c= svcVar.Internal_Perceptive_BatchId;
                    
            }
            oSBCVar.Final_Letter__c=(svcVar.IsFinalLetter!=null)?svcVar.IsFinalLetter :false;
            if(oSBCVar.Status__c!=null && oSBCVar.Status__c.equalsIgnoreCase('Cancelled'))
              oSBCVar.Communication_Issue_Source__c='Communication Cancelled by Field';
           
           if(svcVar.SourceSystem.contains('ISL'))
           {
               oSBCVar.Communication_Source__c = svcVar.SourceSystem;
               oSBCVar.Status__c = 'Received';
               if((svcVar.GlobalPartnerSBCId == null || svcVar.GlobalPartnerSBCId == ''))
               oSBCVar.Communication_Date__c = System.today();
               
               if(svcVar.RelationshipType <> '')
               oSBCVar.Correspondence_Type__c = svcVar.RelationshipType + ' '+ 'Communication';               
               
               
           }
            else
            {
                oSBCVar.Communication_Source__c = 'Compassion Stationary';
            }
           
            if((mapAccount.get(svcVar.Supporter_CompassConstituentId)!=null) || (mapAccount.get(svcVar.Supporter_GlobalId)!=null)){
                if(mapAccount.get(svcVar.Supporter_CompassConstituentId)!=null){
                    oSBCVar.Supporter__c=(mapAccount.get(svcVar.Supporter_CompassConstituentId)).Id;
                    
                    
                  //  svcVar.Supporter_MandatoryReviewRequired=(mapAccount.get(svcVar.Supporter_CompassConstituentId)).Special_Handling__c;
                    svcVar.Supporter_PreferredName=(mapAccount.get(svcVar.Supporter_CompassConstituentId)).Preferred_Name__c;
                    svcVar.Supporter_PreferredName=(mapAccount.get(svcVar.Supporter_CompassConstituentId)).Preferred_Name__c;
                }
                else{
                    
                  
                    oSBCVar.Supporter__c=(mapAccount.get(svcVar.Supporter_GlobalId)).Id; 
                //    svcVar.Supporter_MandatoryReviewRequired=(mapAccount.get(svcVar.Supporter_GlobalId)).Special_Handling__c;
                    svcVar.Supporter_PreferredName=(mapAccount.get(svcVar.Supporter_GlobalId)).Preferred_Name__c;
                    svcVar.Supporter_PreferredName=(mapAccount.get(svcVar.Supporter_GlobalId)).Preferred_Name__c;
                    
                }
                
                for(Correspondence_Delivery_Preference_Map__c oCorrDelvar: lstDelPref){
                    
                    if(svcVar.Supporter_CommunicationDeliveryPreference!=null && oCorrDelvar.Preference__c.equalsIgnoreCase(svcVar.Supporter_CommunicationDeliveryPreference))
                    svcVar.Supporter_CommunicationDeliveryPreference=oCorrDelvar.Mapped_Delivery_Preference__c;
                }
                
                
            }
            
            if(svcVar.Beneficiary_LocalId <> NULL && mapAccount.get(svcVar.Beneficiary_LocalId)!=null){
                oSBCVar.Beneficiary__c=(mapAccount.get(svcVar.Beneficiary_LocalId)).Id;
            }
            else if(svcVar.Beneficiary_GlobalId <> NULL && mapAccount.get(svcVar.Beneficiary_GlobalId)!=null){
                oSBCVar.Beneficiary__c=(mapAccount.get(svcVar.Beneficiary_GlobalId)).Id;
            
            }
            
            //svcVar.GlobalGPId='Compassion USA';
            //  svcVar.Type='Final Thank You';
            if( oSBCVar.Final_Letter__c==null)
               oSBCVar.Final_Letter__c=false;
            if((svcVar.SBCTypes!=null)&&(svcVar.SBCTypes.size()>0)){
                
                
                for(String sCommTypeVar: svcVar.SBCTypes){
                    if(sCommTypeVar!=null && sCommTypeVar.equalsIgnoreCase('Final Thank You'))
                    oSBCVar.Final_Letter__c=true;
                    
                }
                
                
            }
            if(svcVar.Direction <> NULL && svcVar.Direction.startsWith('Supporter'))
            oSBCVar.recordtypeId=Utility.getRecordType('Supporter To Beneficiary','SBC_communications__c');
            else
            oSBCVar.recordtypeId=Utility.getRecordType('Beneficiary To Supporter','SBC_communications__c');
            lstSBCCommFinal.add(oSBCVar);
            
            
            
            Id accountId;
            if(mapAccount.get(svcVar.Supporter_GlobalId) <> null)
            accountId= mapAccount.get(svcVar.Supporter_GlobalId).Id;
            List<SBCCommunicationDetailsList.SBCCommunicationDetails> lstSBCVar=new List<SBCCommunicationDetailsList.SBCCommunicationDetails>();
            if(mapAccount.get(svcVar.Supporter_GlobalId) <> null && mapSBCWrpVar.get(mapAccount.get(svcVar.Supporter_GlobalId).Id)!=null)
            lstSBCVar=mapSBCWrpVar.get(accountId);
            lstSBCVar.add(svcVar);
            mapSBCWrpVar.put(accountId,lstSBCVar);
            mapSBCWrpIdVar.put(svcVar.Supporter_GlobalId,svcVar);
            mapSBCWrpIdVar.put(svcVar.CompassionSBCId,svcVar);
            if(svcVar.Internal_Perceptive_TransactionId <> null && svcVar.Internal_Perceptive_TransactionId <> '' && svcVar.Direction == System.Label.SBCDirection)
            TransactionId = svcVar.Internal_Perceptive_TransactionId ;
            
        }
        List<SBC_communications__c> lstSBCComWithoutGId=new  List<SBC_communications__c> ();
         List<SBC_communications__c> lstSBCComWithGId=new  List<SBC_communications__c> ();
        for(SBC_communications__c oSvcVar: lstSBCCommFinal ){
            
            //oSvcVar.Status__c = 'Received';
         //   oSvcVar.Communication_Source__c = 'ISL';
           if(oSvcVar.SBC_Global_Id__c==null)
              lstSBCComWithoutGId.add(oSvcVar);
           else
               lstSBCComWithGId.add(oSvcVar);
        
        }
     
        // UPserting SBC Communication 
        if(lstSBCCommFinal.size()>0)
        {
            if((lstSBCComWithoutGId.size()>0)&&(TransactionId == '')){
               upsert lstSBCComWithoutGId;
              lstSBCCommFinal.clear();
              lstSBCCommFinal.AddAll(lstSBCComWithoutGId);
               
             }
            if(TransactionId <> '')
            upsert lstSBCCommFinal Transaction_ID__c;  // For Perceptive Scenario
            else {
           if(lstSBCComWithGId.size()>0){
            upsert lstSBCComWithGId SBC_Global_Id__c;   // For SFDC CI scenario
             lstSBCCommFinal.clear();
               lstSBCCommFinal.AddAll(lstSBCComWithGId);
             }
            }
        }
        Set<Id> setSBCIds=new Set<Id>();
        for(  SBC_communications__c oSBCVar: lstSBCCommFinal)
        setSBCIds.add(oSBCVar.Id);
        
        List<SBC_communications__c> lstSBCCommFinalVar=new List<SBC_communications__c> ();
        lstSBCCommFinalVar=[select Id,Name,Preferred_Address__c,Preferred_Email__c,Supporter__c,SBC_Global_Id__c from SBC_Communications__c where Id IN : setSBCIds]; //Getting the Name for Newly Inserted SBC Communication    
        List<SBCCommunicationDetailsList.SBCCommunicationDetails> lstSBCVarFinal=new List<SBCCommunicationDetailsList.SBCCommunicationDetails>();     
        
        for(SBC_communications__c oSBCVar: lstSBCCommFinalVar){
            
            // Setting Email for Suporter   
            if(mapSBCWrpIdVar.get(oSBCVar.SBC_Global_Id__c)!=null){
                SBCCommunicationDetailsList.SBCCommunicationDetails oWrpVar= mapSBCWrpIdVar.get(oSBCVar.SBC_Global_Id__c);
                oWrpVar.GlobalPartnerSBCId=oSBCVar.Name;
                Boolean bIsViaEmail=false;
                Boolean bIsViaMail=false;
                if(oSBCVar.Supporter__c!=null){
                    Account oAccountVar=mapAccountId.get(oSBCVar.Supporter__c);
                    if(oSBCVar.Preferred_Email__c!=null){
                        if(oSBCVar.Preferred_Email__c=='Business')
                        oWrpVar.Internal_Supporter_PersonalEmail=oAccountVar.Business_Email__c;
                        else if(oSBCVar.Preferred_Email__c=='Personal')
                        oWrpVar.Internal_Supporter_PersonalEmail=oAccountVar.Personal_Email__c; 
                        else if(oSBCVar.Preferred_Email__c=='Work')
                        oWrpVar.Internal_Supporter_PersonalEmail=oAccountVar.Work_Email__c; 
                        bIsViaEmail=true;
                    }
                    //Setting Preferred Address for Supporter
                    if(oSBCVar.Preferred_Address__c!=null){
                        if(oSBCVar.Preferred_Address__c=='Mailing'){
                            oWrpVar.Internal_Supporter_InCareOfMailingAddress=oAccountVar.C_O_Mailing_Address__c;
                            oWrpVar.Internal_Supporter_MailingStreet1=oAccountVar.Mailing_Street__c;
                            oWrpVar.Internal_Supporter_MailingCity=oAccountVar.Mailing_City__c;
                            oWrpVar.Internal_Supporter_MailingCountryDivision=oAccountVar.Mailing_State_Province__c;
                            oWrpVar.Internal_Supporter_MailingPostalCode=oAccountVar.Mailing_Zip_Postal_Code__c;
                            oWrpVar.Internal_Supporter_MailingCountry=oAccountVar.Mailing_Country__c;
                        }
                        else  if(oSBCVar.Preferred_Address__c=='Bill To'){
                            oWrpVar.Internal_Supporter_InCareOfMailingAddress=oAccountVar.C_O_Biling_Address__c;
                            oWrpVar.Internal_Supporter_MailingStreet1=oAccountVar.BillingStreet;
                            oWrpVar.Internal_Supporter_MailingCity =oAccountVar.Mailing_City__c;
                            oWrpVar.Internal_Supporter_MailingCountryDivision=oAccountVar.BillingState;
                            oWrpVar.Internal_Supporter_MailingPostalCode=oAccountVar.BillingPostalCode;
                            oWrpVar.Internal_Supporter_MailingCountry=oAccountVar.BillingState;
                        }
                        else  if(oSBCVar.Preferred_Address__c=='Physical'){
                            oWrpVar.Internal_Supporter_InCareOfMailingAddress=oAccountVar.C_O_Physical_Address__c;
                            oWrpVar.Internal_Supporter_MailingStreet1=oAccountVar.ShippingStreet;
                            oWrpVar.Internal_Supporter_MailingCity=oAccountVar.ShippingCity;
                            oWrpVar.Internal_Supporter_MailingCountryDivision=oAccountVar.ShippingState;
                            oWrpVar.Internal_Supporter_MailingPostalCode=oAccountVar.ShippingPostalCode;
                            oWrpVar.Internal_Supporter_MailingCountry=oAccountVar.ShippingCountry;
                        } 
                        bIsViaMail=true;
                    }
                    
                    
                    
                }
                
                
                if(bIsViaEmail && bIsViaMail)
                oWrpVar.Internal_Supporter_CommunicationMethod='Both';
                else if(bIsViaEmail )
                oWrpVar.Internal_Supporter_CommunicationMethod='Email';
                else if(bIsViaMail )
                oWrpVar.Internal_Supporter_CommunicationMethod='Mail';
                else
                oWrpVar.Internal_Supporter_CommunicationMethod='None';
                lstSBCVarFinal.add(oWrpVar);
            }
            
        }
        SBCCommunicationDetailsList.SBCCommunicationDetails_ISL sbcIslFinal=new SBCCommunicationDetailsList.SBCCommunicationDetails_ISL();
        List<SBCCommunicationDetailsList.SBCCommunicationDetailsISL > lstSbcISL=new List<SBCCommunicationDetailsList.SBCCommunicationDetailsISL > ();
        for(SBCCommunicationDetailsList.SBCCommunicationDetails sbcVar: lstSBCVarFinal){
            
            if(sbcVar.SourceSystem=='ISL Mobile'){
                // For ISL Scenario
                SBCCommunicationDetailsList.SBCCommunicationDetailsISL newSBCWrpTmp=new  SBCCommunicationDetailsList.SBCCommunicationDetailsISL(sbcVar);
                lstSbcISL.add(newSBCWrpTmp);
            }
        }
        
        if(lstSbcISL.size()>0){
            sbcIslFinal.SBCCommunicationDetailsISL=lstSbcISL;
            
            
        }
        
        
        List<SBC_Communications__c > lstSBCCommFinalTempVar=[select Id,Name,SBC_Global_Id__c from SBC_Communications__c where Id IN :setSBCIds];
        for(SBC_Communications__c oSBCVar: lstSBCCommFinalTempVar)
        oSBCVar.Communication_Source__c=oSBCVar.Name;
        Map<String,List<sObject>> mapOutput= 
        new Map<String,List<sObject>>();
        // Generating SBC Communication Response with SBC Loacl Id
        mapOutput.put('SBCCommGlobalIdCIUpdateFieldGroup',lstSBCCommFinalTempVar);
        //Getting Final JSON String
        String sResponse=
        JSONHandlerMethods.serialize(mapOutput,
        'SBCCommGlobalIdCIUpdateFieldProcess'); 
        sResponse=sResponse.replace('"null"', 'null');
        RestContext.response.addHeader('Content-Type', 'application/json');
        // Sending the response back
        RestContext.response.responseBody = Blob.valueOf(sResponse); 
        
        
        
        SBCCommunicationDetailsList.SBCCommunicationDetailsFin sbcList=new SBCCommunicationDetailsList.SBCCommunicationDetailsFin (lstSBCVarFinal);
        // sbcList.SBCCommunicationDetails=lstSBCVarFinal;
        
        if(sbcIslFinal.SBCCommunicationDetailsISL!=null)
        sResponse=JSON.serialize( sbcIslFinal);
        //else
        // sResponse=JSON.serialize(sbcList);
        if((sInvocationType == 'CreateSBCCommunicationRESTServices') || (sInvocationType == 'ISL'))  
        return sResponse;
        else
        return null;
    }
    
}