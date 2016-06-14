/*****************************************************************************************
    Name             : FollowUnFollowChatterHelper
    Description      : Trigger Helper class used to handle the scenario of auto follow and unfollow account for record Owner                   
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
public without sharing class FollowUnFollowChatterHelper{
    /**
    * Method name  : autoFollowAccounts
    * Description  : Use this method to follow   record 
    *                
    * Return Type  : Map<Id,Account>,String,String
    * Parameter    : void
    **/ 

    public static void autoFollowsObject(Map<Id,sObject> mapNewsObj,String sDeterminedField,String sRelatedIdField){
        // Getting all account ownerIds
        Set<Id> setSObjOwnerId=new Set<Id>();
        for(sObject oSObjVar: mapNewsObj.values())
        setSObjOwnerId.add((ID)oSObjVar.get(sDeterminedField));     //Get OwnerId specified in sDeterminedField field.
        
        List<EntitySubscription> lstEntitySubscription=new List<EntitySubscription>();
        lstEntitySubscription=[select Id,ParentId,SubscriberId from EntitySubscription where SubscriberId IN :setSObjOwnerId and ParentId IN :mapNewsObj.keySet() LIMIT 1000];//Query EntitySubsription Object to get all other users already following the records.

        
        for(EntitySubscription oEntitySubsVar: lstEntitySubscription){
            //Checking if User already following the record .If yes remove that record for insert
            if( mapNewsObj.containsKey(oEntitySubsVar.ParentId))
            mapNewsObj.remove(oEntitySubsVar.ParentId);
            
        }
        lstEntitySubscription=new List<EntitySubscription>();
        //Creating new EntitySubscription record to follow
        for(SObject oSObjVar: mapNewsObj.values()){
            
            EntitySubscription oEntitySubscriptionVar=new EntitySubscription();
            oEntitySubscriptionVar.ParentId=(ID)oSObjVar.get(sRelatedIdField);
            oEntitySubscriptionVar.SubscriberId=(ID)oSObjVar.get(sDeterminedField);
            lstEntitySubscription.add(oEntitySubscriptionVar);
                       
        }

        try{

            insert lstEntitySubscription;   // Inserting EntitySubscription records

        }
        catch(Exception ex){
            
      
           Utility.insertErrorLogApplication(ex.getMessage()+'\n'+ex.getStackTraceString(),'EntitySubscription',String.valueOf(mapNewsObj.keySet()) + String.valueOf(setSObjOwnerId),'FollowUnFollowChatterHelper','autoFollowsObject','Application',UserInfo.getUserId(), String.valueOf(mapNewsObj.values()),null);

        }
    }
    /**
    * Method name  : autoUnfollowAccounts
    * Description  : Use this method to  unfollow account record.
    *                
    * Return Type  : Map<Id,Account>
    * Parameter    : void
    **/ 
    public static void autoUnfollowsObject(Map<Id,sObject> mapOldsObj,String sDeterminedField){

        Set<Id> setSObjOwnerId=new Set<ID>();
        
        List<EntitySubscription> lstEntitySubscription=new List<EntitySubscription>();
        
        for(sObject oSObjVar: mapOldsObj.values())
        setSObjOwnerId.add((ID)oSObjVar.get(sDeterminedField));   //Get OwnerId specified in sDeterminedField field.
        
        try{           
            lstEntitySubscription=[select Id,ParentId,SubscriberId from EntitySubscription where SubscriberId IN :setSObjOwnerId and ParentId IN :mapOldsObj.keySet() LIMIT 1000];
            
            
            delete lstEntitySubscription;  //Deleting EntitySubscription for unfollow record
            
        }
        catch(Exception ex){
            
           
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+ex.getStackTraceString(),'EntitySubscription',String.valueOf(mapOldsObj.keySet()) + String.valueOf(setSObjOwnerId),'FollowUnFollowChatterHelper','autoUnfollowsObject','Application',UserInfo.getUserId(), String.valueOf(mapOldsObj.Values()),null);

        }

    }

}