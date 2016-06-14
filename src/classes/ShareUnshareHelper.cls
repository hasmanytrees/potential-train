/*******************************************************************************
    Name             : ShareUnshareHelper
    Description      : This class is used to share and unshare campaign and 
                       deliverable based on Agency add and removal
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring &
                                         optimization
*******************************************************************************/
public without Sharing class ShareUnshareHelper{
    /**
    * Method name  : shareUnShareCampaign
    * Description  : Use this method to Share and unShare Campaign based on 
    *                Primary Agency
    * Return Type  : void
    * Parameter    : List<Campaign> ,boolean
    **/  

    public static void shareUnShareCampaign(List<Campaign> lstCampaign,
    boolean bIsShare){

        Set<id> setCampaignId=new Set<id>();
        Set<Id> setCampaignAgencyId=new Set<Id>();
        Set<Id> setContactId=new Set<id>();
        Map<Id,User> mapUser=new Map<Id,User>();
        Map<Id,List<Id>> mapAccountContactList =new Map<Id,List<Id>> ();
        List<Contact> lstAssociatedContact=new List<Contact>();
        Map<Id,Id> mapContactUser=new Map<Id,Id>();
        List<CampaignShare> lstCampaignShare=new List<CampaignShare>();
        //Getting list of Campaign Agency
        for(Campaign oCampaignVar: lstCampaign){
            setCampaignId.add(oCampaignVar.Id);
            setCampaignAgencyId.add(oCampaignVar.Agency__c);
        }
        lstAssociatedContact=[select Id,accountId from Contact where AccountId
        IN :setCampaignAgencyId]; //Getting associated Contact for Agency
        
        for(Id accountIdVar: setCampaignAgencyId){
            
            List<Id> lstContactIdVar=new List<Id>();
            for(Contact contactVar :lstAssociatedContact){
                setContactId.add(contactVar.Id);
                if(contactVar.accountId==accountIdVar)
                lstContactIdVar.add(contactVar.Id);
                
            }
            mapAccountContactList.put(accountIdVar,lstContactIdVar);
        }
        //Forming list of Contacts related to Campaign Agency
        if(setContactId.size()>0) {
            mapUser=new Map<Id,User>([select Id,ContactId from User where 
            contactId IN :setContactId]);
          
            for(User userVar:mapUser.values())
            mapContactUser.put(userVar.ContactId,userVar.Id);
            
        }
        
        
        //Getting Existing Share records for Related Agency's Community User
        if(mapUser.size()>0)
       lstCampaignShare=[select Id,UserOrGroupId,CampaignId ,CampaignAccessLevel
       from CampaignShare where UserOrGroupId IN :mapUser.keySet() and 
       CampaignId IN :setCampaignId];
        
        if(bIsShare){ 
            //This block runs for inserting share record.
            if(lstCampaignShare.size()==0){
                
                for(Campaign oCampaignVar: lstCampaign){
                    
                    for(Id contactIdVar :mapAccountContactList.get
                    (oCampaignVar.Agency__c)){
                       
                        CampaignShare oCampaignShareVar=new CampaignShare ();
                        oCampaignShareVar.CampaignId =oCampaignVar.Id;
                        oCampaignShareVar.UserOrGroupId=mapContactUser.get
                        (contactIdVar);
                        oCampaignShareVar.CampaignAccessLevel ='Read';
                        if(mapContactUser.get(contactIdVar)!=null)
                        lstCampaignShare.add(oCampaignShareVar);
                    }
                    
                }
                try
                {
                    upsert lstCampaignShare;
                }
                catch(Exception ex)
                {
                    //Creating a new Error Log record whenever any exception is
                    //encountered while performing DML Operation
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'
                    +ex.getStackTraceString(),'Task',String.valueOf
                    (setCampaignId),'CampaignShare','shareUnshareDeliverable',
                    'Application',UserInfo.getUserId(), String.valueOf
                    (lstCampaignShare),null);
                    
                }         
            }
        }
        else{
            //This block runs for unshare first
            delete lstCampaignShare;
        }           
    }

    /**
    * Method name  : shareUnshareDeliverable
    * Description  : Use this method to Share and unShare Deliverable based on 
    *                Agency
    * Return Type  : void
    * Parameter    : List<Deliverable__c>  ,Set<Id>,boolean
    **/  

    public static void shareUnshareDeliverable(List<Deliverable__c> 
    lstDeliverable,Set<Id> setCampaignId,boolean bIsShare){
        Set<id> setDelId=new Set<id>();
        Set<Id> setDelAgencyId=new Set<Id>();
        Set<Id> setContactId=new Set<id>();
        Map<Id,User> mapUser=new Map<Id,User>();
        Map<Id,List<Id>> mapAccountContactList =new Map<Id,List<Id>> ();
        List<Contact> lstAssociatedContact=new List<Contact>();
        Map<Id,Id> mapContactUser=new Map<Id,Id>();
        List<Deliverable__Share> lstDelShare=new List<Deliverable__Share>();
        List<CampaignShare> lstCampaignShare=new List<CampaignShare>();
        //Getting all related Agency
        for(Deliverable__c oDeliverableVar: lstDeliverable){
            setDelId.add(oDeliverableVar.Id);
            setDelAgencyId.add(oDeliverableVar.Agency__c);
        }
        lstAssociatedContact=[select Id,accountId from Contact where AccountId 
        IN :setDelAgencyId]; //Getting list of related Contact to Agency
        
        for(Id accountIdVar: setDelAgencyId){
            
            List<Id> lstContactIdVar=new List<Id>();
            for(Contact oContactVar :lstAssociatedContact){
                setContactId.add(oContactVar.Id);
                if(oContactVar.accountId==accountIdVar)
                lstContactIdVar.add(oContactVar.Id);
                
            }
            mapAccountContactList.put(accountIdVar,lstContactIdVar);
        }
        //Getting all user Community User for associated Agency
        if(setContactId.size()>0) {
            mapUser=new Map<Id,User>([select Id,ContactId from User where 
            contactId IN :setContactId]);
          
            for(User oUserVar:mapUser.values())
            mapContactUser.put(oUserVar.ContactId,oUserVar.Id);
            
        }
        
        if(mapUser.size()>0)
        lstDelShare=[select Id,UserOrGroupId,ParentId,AccessLevel from 
        Deliverable__Share where UserOrGroupId IN :mapUser.keySet() and parentId
        IN :setDelId];
        //This SOQL query runs for scenario,if Agency on deliverable and 
        //Campaign is different
        if(setCampaignId.size()>0)
        lstCampaignShare=[select Id,UserOrGroupId,CampaignId ,
        CampaignAccessLevel from CampaignShare where UserOrGroupId
        IN :mapUser.keySet() and CampaignId IN :setCampaignId];
        if(bIsShare){ 
            //This block runs for insert share record
            if(lstDelShare.size()==0){
                
                for(Deliverable__c oDeliverableVar: lstDeliverable){
                    
                    for(Id contactIdVar :mapAccountContactList.get
                    (oDeliverableVar.Agency__c)){
                       
                        Deliverable__Share  oDelShareVar = 
                        new Deliverable__Share ();
                        oDelShareVar.parentId=oDeliverableVar.Id;
                        oDelShareVar.UserOrGroupId = 
                        mapContactUser.get(contactIdVar);
                        oDelShareVar.AccessLevel = System.label.Access_Edit;
                        if(mapContactUser.get(contactIdVar)!=null)
                        lstDelShare.add(oDelShareVar);
                        if(setCampaignId.size()>0){
                            
                        //This runs only of campaign Agency is different 
                        //from Deliverable Agency
                        CampaignShare oCampaignShareVar=new CampaignShare ();
                      oCampaignShareVar.CampaignId =oDeliverableVar.Campaign__c;
                        oCampaignShareVar.UserOrGroupId=mapContactUser.get
                        (contactIdVar);
                        oCampaignShareVar.CampaignAccessLevel = 
                                                    System.label.Access_Read;
                        if(mapContactUser.get(contactIdVar)!=null)
                        lstCampaignShare.add(oCampaignShareVar);
                        }
                    }
                    
                }
                try
                {
                    upsert lstDelShare;
                }
                catch(Exception ex)
                {
                    //Creating a new Error Log record whenever any exception is
                    //encountered while performing DML Operation
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                  ex.getStackTraceString(),'Task',String.valueOf(setCampaignId),
                    'CampaignShare','shareUnshareDeliverable','Application',
                    UserInfo.getUserId(), String.valueOf(lstDelShare),null);
                }
                
                //If any share records for campaign 
                if(setCampaignId.size()>0)
                List<Database.UpsertResult> lstUpsert = Database.upsert
                (lstCampaignShare,false);
            }
        }
        else{
            //This block runs for unshare.
            try
            {
                delete lstDelShare;
                // delete lstCampaignShare;
                if(lstCampaignShare.size()>0)
                List<Database.DeleteResult> lstUpsert = Database.delete
                (lstCampaignShare,false);
            }
            catch(Exception ex)
            {
                //Exception Occurred;
            }
            

        }     
    }  
}