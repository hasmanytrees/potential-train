/******************************************************************************
    Name             : CampaignLocationSlotBORESTService
    Description      : This REST webservice is used to Call to query all Slot 
                       for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring
                                              & optimization
Apurva                  18/09/2015            Code changes made for COR0001591    
Apurva                  9/10/2015             Changes made for INC0068003
******************************************************************************/
@RestResource(urlMapping='/events/locations/volunteerslot/*')
global class CampaignLocationSlotBORESTService
{
    //Constructor
    @HttpGet
    global static void getCampaignLocationSlot() {
         RestContext.response.statusCode = 200 ;  
        try{
            String sEventLocationId= 
            RestContext.request.params.get(System.Label.eventlocationid);
            String sVolunteerId= 
            RestContext.request.params.get(System.Label.volunteerid);
            String sDateEndAfter=
            RestContext.request.params.get(System.Label.dateendafter);
            Id recordtypeId=
            Utility.getRecordtype(
            System.Label.Recordtype_EventLocation,
            System.Label.Recordtype_Campaign);
            
           
            RestContext.response.addHeader('Content-Type', 'application/json');
            
            
            List<Volunteer_Slot__c> lstSlot=new List<Volunteer_Slot__c>();
            List<Volunteer_Slot__c> lstSlotFinal=new List<Volunteer_Slot__c>();
            List<Campaign> lstCampaign=new List<Campaign>();
            
            if((sEventLocationId!=null)&&(sVolunteerId==null)){
                
                
                
                // Getting All Event Location Details
                lstCampaign=[select EVE_Start_Datetime__c,
                EVE_End_Datetime__c,Dress_Code__c,EndDate,Id,
                Campaign_Name__c,
                Name,Published_Location_Description__c,
                Published_Volunteer_Coordinator_Name__c,
                Audience_Description__c,
                Published_Volunteer_Coordinator_Email__c,
                Dress_Code_Details__c,StartDate,VEN_Name__c,
                Legacy_Campaign_Code__c,Partner_Website__c,
                Published_Location_Name__c,
                EVE_Contact__c,EVE_Contact_Phone__c,
                Primary_Compassion_Contact__c,
                Address_1__c,Address_2__c,Address_3__c,Publish_To_Web__c,
                Description,Primary_Compassion_Contact_Email__c,
                City__c,State__c,ZIP_Code__c,Country__c,
                Primary_Compassion_Contact_Name__c,LastModifiedDate, 
                Primary_Compassion_Contact_Cell_Phone__c
                from Campaign where Id=:sEventLocationId];
                
                
                //Apurva - Changes added for INC0068003 added 3 Volunteer_Shift__r related fields
                //Getting all available volunteer slot 
                //related to that event location
                lstSlot=[select Id,Date__c,Volunteer_Role__c,Status__c,
                Volunteer_Email_Update__c,LastModifiedDate,
                Volunteer_Slot_End_Date__c,Volunteer_Slot_Start_Date__c,
                End_Time__c,Start_Time__c,Volunteer_Full_Name__c,Volunteer__c,
                Volunteer_Shift__r.Date__c,
                Volunteer_Shift__r.Start_Time__c,
                Volunteer_Shift__r.End_Time__c,
                Event_Location_Id__c from Volunteer_Slot__c 
                where Volunteer_Shift__r.EventLocation__c=:sEventLocationId 
                and Status__c=:System.label.VolunteerSlotStatus];

                for(Volunteer_Slot__c oVSlotVar: lstSlot){
                    lstSlotFinal.add(oVSlotVar);
                    
                }
                
                
                // If no related available volunteer Slot found      
                if(lstSlotFinal.size()==0){
                   return ; 
                }
                //Apurva - Changes added for INC0068003 -start
                for(Volunteer_Slot__c oVSlotVar: lstSlotFinal){
                    if(oVSlotVar.Volunteer_Shift__r.Date__c!= null){
                        Integer iMOnth=oVSlotVar.Volunteer_Shift__r.Date__c.month();
                        Integer iDay=oVSlotVar.Volunteer_Shift__r.Date__c.Day();
                        Integer iYear=oVSlotVar.Volunteer_Shift__r.Date__c.Year();
                        String sDate=String.valueOF(iMOnth)+'/'+String.valueOF(iDay)+'/'+
                        String.valueOf(iYear);
                        string sDateTime = '' ;
                        if((oVSlotVar.Volunteer_Shift__r.Start_Time__c!=null)&&
                        (oVSlotVar.Volunteer_Shift__r.End_Time__c!=null)){
                            sDateTime = String.valueof(Datetime.parse
                            (sDate+' '+oVSlotVar.Volunteer_Shift__r.Start_Time__c));
                            oVSlotVar.Volunteer_Slot_Start_Date__c = 
                                Datetime.valueOf(sDateTime);
                                
                                
                            sDateTime = String.valueof(Datetime.parse
                            (sDate+' '+oVSlotVar.Volunteer_Shift__r.End_Time__c));
                            oVSlotVar.Volunteer_Slot_End_Date__c= 
                                Datetime.valueOf(sDateTime);    
                        }
                    }
                }
                //Apurva - Changes added for INC0068003 -end
                Map<String,List<sObject>> mapOutPut= 
                new Map<String,List<sObject>>();
                mapOutPut.put(
                'CampaignLocationBOCampaignResponseGroup',lstCampaign);
                mapOutPut.put('ActivityResponsesFieldGroup',lstSlotFinal);
                //Generating JSON response using JSONHandlerMethods
                String sResponse=
                JSONHandlerMethods.serialize(
                mapOutPut,'CampaignLocationSlotBOResponseProcess');      
                RestContext.response.responseBody = Blob.valueOf(sResponse); 
                
                return;

            }
            else if((sVolunteerId!=null)&&(sEventLocationId==null)){
                //Getting Slot based on only user given date
                if(sDateEndAfter!=null){
                    Date dFilter=
                    ((Datetime)JSON.deserialize(
                    '"'+sDateEndAfter+'"',datetime.class)).date();
 
                 //Apurva - Changes added for INC0068003 added 3 Volunteer_Shift__r related fields                   
                    lstSlot=[select Id,Date__c,Volunteer_Role__c,Status__c,
                    Volunteer_Email_Update__c,LastModifiedDate,
                    Volunteer_Slot_End_Date__c,Volunteer_Slot_Start_Date__c,
                    End_Time__c,Start_Time__c,Volunteer_Full_Name__c,
                    Volunteer_Shift__r.Date__c,
                    Volunteer_Shift__r.Start_Time__c,
                    Volunteer_Shift__r.End_Time__c,
                    Volunteer__c,Event_Location_Id__c 
                    from Volunteer_Slot__c where Volunteer__c = :sVolunteerId 
                    and Date__c!=null  and Date__c>=:dFilter 
                    and Volunteer_Slot_Start_Date__c!=null 
                    and  Volunteer_Slot_End_Date__c!=null];

                    
                }
                else
                lstSlot=[select Id,Date__c,Volunteer_Role__c,Status__c,
                Volunteer_Email_Update__c,LastModifiedDate,
                Volunteer_Slot_End_Date__c,Volunteer_Slot_Start_Date__c,
                End_Time__c,Start_Time__c,Volunteer_Full_Name__c,Volunteer__c,
                Volunteer_Shift__r.Date__c,
                Volunteer_Shift__r.Start_Time__c,
                Volunteer_Shift__r.End_Time__c,
                Event_Location_Id__c from Volunteer_Slot__c 
                where Volunteer__c = :sVolunteerId and Date__c!=null 
                and  Volunteer_Slot_Start_Date__c!=null 
                and  Volunteer_Slot_End_Date__c!=null];
                //Apurva - Changes added for INC0068003 added 3 Volunteer_Shift__r related fields above
                //Getting all slot into array
                for(Volunteer_Slot__c oVSlotVar: lstSlot){
                    lstSlotFinal.add(oVSlotVar);
                    
                }
                
                
                
                if(lstSlot.size()==0){
                    RestContext.response.statusCode = 200;                    
                    return ;        
                }
                //Apurva - Changes added for INC0068003 -start
                for(Volunteer_Slot__c oVSlotVar: lstSlot){
                    if(oVSlotVar.Volunteer_Shift__r.Date__c!= null){
                        Integer iMOnth=oVSlotVar.Volunteer_Shift__r.Date__c.month();
                        Integer iDay=oVSlotVar.Volunteer_Shift__r.Date__c.Day();
                        Integer iYear=oVSlotVar.Volunteer_Shift__r.Date__c.Year();
                        String sDate=String.valueOF(iMOnth)+'/'+String.valueOF(iDay)+'/'+
                        String.valueOf(iYear);
                        string sDateTime = '' ;
                        if((oVSlotVar.Volunteer_Shift__r.Start_Time__c!=null)&&
                        (oVSlotVar.Volunteer_Shift__r.End_Time__c!=null)){
                            sDateTime = String.valueof(Datetime.parse
                            (sDate+' '+oVSlotVar.Volunteer_Shift__r.Start_Time__c));
                            oVSlotVar.Volunteer_Slot_Start_Date__c = 
                                Datetime.valueOf(sDateTime);
                                
                                
                            sDateTime = String.valueof(Datetime.parse
                            (sDate+' '+oVSlotVar.Volunteer_Shift__r.End_Time__c));
                            oVSlotVar.Volunteer_Slot_End_Date__c= 
                                Datetime.valueOf(sDateTime);    
                        }
                    }    
                }
                //Apurva - Changes added for INC0068003 -end
                
                Map<String,List<sObject>> mapOutPut= 
                new Map<String,List<sObject>>();
                mapOutPut.put('ActivityResponsesFieldGroup',lstSlot);
                String sResponse=JSONHandlerMethods.serialize(
                mapOutPut,
                'CampaignLocationSlotBORelatedAccountResponseProcess');
                
                
                // Sending the response back
                RestContext.response.responseBody = Blob.valueOf(sResponse);  
            }     
        }
        catch(Exception ex){
            RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'
            +ex.getStackTraceString(),'CampaignLocationSlotBORESTService'
            ,'Integration','CampaignLocationSlotBORESTService','Inbound Call'
            ,URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/'
            +RestContext.request.requestURI+'?'
            +Utility.retrieveRESTParameters(
            RestContext.request.params.keyset())
            .subStringBeforeLast('&')
            ,UserInfo.getUserId(),'getCampaignLocationSlot');

        }       
    }
    @httpPost
    global static void setCampaignLocationSlot() {
        try{ 
             Savepoint sp = Database.setSavepoint();
            String sVolunteerSlotId= 
            RestContext.request.params.get(System.Label.volunteerslotid);
            String sVolunteerStatus= 
            RestContext.request.params.get(System.Label.status);
            String sVolunteerId= 
            RestContext.request.params.get(System.Label.volunteerid);
            String sGuest= 
            RestContext.request.params.get(System.Label.guest);
            RestContext.response.addHeader(
            'Content-Type', 'application/json');
            List<Volunteer_Slot__c> lstSlot=
            new List<Volunteer_Slot__c>();
            boolean bIsNewAccount=false;
            List<Volunteer_Slot__c> lstVolunteerSlot=
            new  List<Volunteer_Slot__c>();
            lstSlot=[select Id,Volunteer_Role__c,Status__c,
            Volunteer_Email_Update__c,LastModifiedDate,
            Volunteer_Full_Name__c,Volunteer__c,Event_Location_Id__c,
            Volunteer_Shift__c,Date__c from Volunteer_Slot__c 
            where  Volunteer__c = :sVolunteerId ];
            if(lstSlot.size()>0){
               Integer iNoOfCancelledSlot=0;
               iNoOfCancelledSlot=[select count() from Volunteer_Slot__c where Volunteer__c=:sVolunteerId and Status__c like 'Cancelled%'];
               if(iNoOfCancelledSlot==lstSlot.size())
                   lstSlot=new List<Volunteer_Slot__c>();
            }
            Account oAcccountVolunteer=new Account();
            if((sVolunteerSlotId!=null)&&(sVolunteerId!=null)){
               
                if(sVolunteerStatus!=null 
                && !sVolunteerStatus.contains(System.label.Cancelled)){
                   //If user wants update status to anything but cancel
                   //Below block checks if specified slot is already booked. 
                  
                    if(sVolunteerStatus==
                    System.label.VolunteerSlotStatus_PendingApproval){
                        if(lstSlot.size()==0){
                            sVolunteerStatus=
                        System.label.VolunteerSlotStatus_Pending_Approval_First_Time;
                        }
                        else if (sGuest != null && sGuest!= ''){
                            sVolunteerStatus=
                        System.label.VolunteerSlotStatus_Pending_Approval_Guest;
                        }
                        
                    }
                    
                    
                    if(Id.valueOf(sVolunteerId).getSobjectType()==
                    Schema.Contact.SObjectType){
                        //Checking if user has given contact in volunteer Id
                        Contact oContactVar=new Contact();
                        List<Task> lstTask=new List<Task>();
                        
                        try{
                        //Getting all related Communication and Task details
                        //related to that contact.
                            oContactVar=[select Id,AccountId,(select Id,
                            Account__c,Campaign__c,Contact__c 
                            from Communication__r),(select Id,whatId,whoId 
                            from Tasks) 
                            from Contact where Id =:sVolunteerId];
                            
                            for(Contact oContactTempVar: 
                            new List<Contact>{oContactVar}){
                                
                                for(Task oTaskVar: oContactTempVar.Tasks){
                                    oTaskVar.whoId=null;
                                    lstTask.add(oTaskVar);
                                }
                                
                            } 
                            update lstTask;
                        }
                        catch(Exception ex){
                            RestContext.response.statusCode = 500 ; 
                           
                            unDeleteContact(sp);
                            return;
                        }
                       
                        //Converting Contact to Account
                        sVolunteerId=
                        ConvertToAccountHandler.convertContact(sVolunteerId); 
                        
                                             
                        if(sVolunteerId=='false'){
                            //If any error occored during conversion
                            RestContext.response.statusCode = 500 ;
                           
                            unDeleteContact(sp);
                            return ;
                        }
                        else{
                            //reparenting Account and related communication
                            bIsNewAccount=true;
                            oAcccountVolunteer.Id=sVolunteerId;
                            oAcccountVolunteer.Converted_Account_From_Adv_Web__c=true;
                            
                            oAcccountVolunteer.Override_Account_Validation__c = true;
                            List<sObject> lstRelatedRecords=
                            new List<sObject>();
                            for(Contact oContactTempVar: 
                            new List<Contact>{oContactVar}){
                                
                                for(Communication__c oCommVar: 
                                oContactTempVar.Communication__r){
                                    
                                    oCommVar.Contact__c =null;
                                    oCommVar.Account__c=sVolunteerId;
                                    lstRelatedRecords.add(oCommVar);
                                }
                                for(Task oTaskVar: oContactTempVar.Tasks){
                                    oTaskVar.whatId=sVolunteerId;
                                    lstRelatedRecords.add(oTaskVar);
                                }
                                
                            } 

//Commenting code and moved logic to ConvertToAccountHandler - COR0001591                           
                            //Creating relationship group 
                            //for newly converted Account

 /*                           Relationship_Group__c oRelGroupVar=
                            new Relationship_Group__c ();
                            oRelGroupVar.Group__c=oContactVar.AccountId;
                            oRelGroupVar.Supporter__c=sVolunteerId;
                            insert oRelGroupVar;*/
                            if(lstRelatedRecords.size()>0)
                            //Update reparented records with new master
                            update lstRelatedRecords;      
                        }
                    }
                    List<Volunteer_Slot__c> lstVolunteerShift=
                    new List<Volunteer_Slot__c>();
                    lstVolunteerShift=[select Id,Volunteer__c,Status__c 
                    from Volunteer_Slot__c where Id=:sVolunteerSlotId];
                    if(lstVolunteerShift.size() > 0){
                        
                        if(lstVolunteerShift[0].Volunteer__c!=null){
                            //The Slot is no longed available 
                            RestContext.response.statusCode = 410 ;
                           
                           
                            unDeleteContact(sp); 
                            return ;
                            
                        }
                        
                    }
                    Volunteer_Slot__c oVolunteerSlotVar=
                    new Volunteer_Slot__c (Id=sVolunteerSlotId,
                    Volunteer__c=sVolunteerId);
                    if(sGuest!=null)
                    oVolunteerSlotVar.Comments__c=sGuest;
                    
                    /* Sreeja - 03/04 - Added logic to map slot status 
                    based on value coming in */
                    if (sVolunteerStatus != null){
                        oVolunteerSlotVar.Status__c = sVolunteerStatus;
                    }
                    
                    lstVolunteerSlot.add(oVolunteerSlotVar);
                }
                else{
                    //Updating volunteer slot information
                    Volunteer_Slot__c oVolunteerSlotVar=
                    new Volunteer_Slot__c (Id=sVolunteerSlotId,
                    Volunteer__c=sVolunteerId,Status__c=sVolunteerStatus);
                   
                    Volunteer_Slot__c volunteerSlotNewVar= new Volunteer_Slot__c ();
                    volunteerSlotNewVar.Volunteer__c=null;
                    volunteerSlotNewVar.Id=null;
                    volunteerSlotNewVar.Volunteer_Shift__c = [select Volunteer_Shift__c from Volunteer_Slot__c where id = :sVolunteerSlotId].Volunteer_Shift__c;
                    //Available
                    volunteerSlotNewVar.Status__c=
                    System.label.VolunteerSlotStatus; 
                    lstVolunteerSlot.add(oVolunteerSlotVar);
                    lstVolunteerSlot.add(volunteerSlotNewVar);
                    
                }
                try{
                   
                  
                    upsert lstVolunteerSlot;
                    if(oAcccountVolunteer.ID <> NULL )
                        update oAcccountVolunteer;
                    List<Account> lstAccountVar=new List<Account>();
                    
                    if(bIsNewAccount){
                    //For new Account returning empty array
                    RestContext.response.statusCode = 201 ; 
                    lstAccountVar=[select Id,Type,Legacy_Partner_Id__c ,
                    Legacy_Supporter_Id__c,First_Name__c,Account_Full_Name__c,
                    Name,Preferred_Address__c,Preferred_Email_Address__c,
                    Prefix__c,Preferred_Email__c from Account 
                    where Id=:sVolunteerId];
                    }else{
                        RestContext.response.statusCode = 204 ;
                    }
                    if(lstAccountVar.size()==0)
                    lstAccountVar.add(new Account()); 
                    else{
                        
                         //Tis block runs for 
                         //if user cancels any volunteer slot
                        for(Account oAccountVar: lstAccountVar){
                            oAccountVar.C_O_Physical_Address__c=
                            oAccountVar.Account_Full_Name__c;
                            oAccountVar.Employer__c=oAccountVar.Id;
                            oAccountVar.Status__c=oAccountVar.Id;
                            oAccountVar.Override_Account_Validation__c=false;
                            oAccountVar.Business_Email__c=
                            oAccountVar.Preferred_Email_Address__c ;  
                        } 
                        
                    }   
                    Map<String,List<sObject>> mapOutput=
                    new Map<String,List<sObject>>();
                    mapOutput.put('ContactBOResponseFieldGroup',lstAccountVar);
                    //Forming response JSON
                    String sResponse=JSONHandlerMethods.serialize(
                    mapOutput,'CampaignLocationVolunteerBOResponse'); 
                   
                    RestContext.response.addHeader(
                    'Content-Type', 'application/json');              
                    RestContext.response.responseBody = Blob.valueOf(sResponse);
                    
                    return ;
                }
                catch(Exception ex){
                    
                    if(ex.getMessage().contains(
                    System.label.FIELD_CUSTOM_VALIDATION_EXCEPTION
                    +' '+System.label.DuplicateVolunteerError))
                    //For duplicate error
                   
                    RestContext.response.statusCode = 409 ;     
                    else
                    RestContext.response.statusCode = 500 ; 
                     
                     unDeleteContact(sp);
                    return ;
                    
                }
                
            }
            else{
                
                RestContext.response.statusCode = 500 ; 
                return ;
                
                
            }
            RestContext.response.statusCode = 204 ; 
        }
        catch(Exception ex){
            String sContactId=RestContext.request.params.get(System.Label.volunteerid);
           
            RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'
            +ex.getStackTraceString(),'CampaignLocationSlotBORESTService'
            ,'Integration','CampaignLocationSlotBORESTService','Inbound Call'
            ,URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/'
            +RestContext.request.requestURI+'?'
            +Utility.retrieveRESTParameters
            (RestContext.request.params.keyset()).subStringBeforeLast('&'),
            UserInfo.getUserId(),'setCampaignLocationSlot');

        }         
    }
    private static void unDeleteContact(Savepoint  spVar){
       
             Database.rollback(spVar);
           
           
      }
    
}