/****************************************************************************
    Name             : CampaignMemberTriggerHandler
    Description      : Trigger Handlerclass used to handle 
    the scenario of auto follow and unfollow Campaign record
    by Campaign Member with Role Team Member               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
******************************************************************************/
public without Sharing class CampaignMemberTriggerHandler{

    /**
    * Method name  : followAndUnfollowHandler
    * Description  : Use this method to initiate helper class to follow  
                     and unfollow Campaign record by Campaign Member 
                     with Role Team Member  
    *                
    * Return Type  : Map<Id,Campaign_Member__c>,Map<Id,Campaign_Member__c>
    * Parameter    : void
    **/  

    public static void followAndUnfollowHandler
    (Map<Id,Campaign_Member__c> mapNewCM,
    Map<Id,Campaign_Member__c> mapOldCM)
    {
        
        Map<Id,Campaign_Member__c> mapNewCMVar=
        new Map<Id,Campaign_Member__c>();
        Map<Id,Campaign_Member__c> mapOldCMVar=
        new Map<Id,Campaign_Member__c>();
        for(Campaign_Member__c oCmVar: mapNewCM.values()){
            
            
            if((mapOldCM!=null)&&(mapNewCM.get(oCmVar.Id).Role__c!=null)
            &&(mapOldCM.get(oCmVar.Id).Name__c!=oCmVar.Name__c)
            &&(mapNewCM.get(oCmVar.Id).Role__c==System.label.TeamMember)){
                //Checking if Campaign Member role is changed to Team Member 
                //on Record update
                mapNewCMVar.put(oCmVar.Campaign__c,oCmVar);
                mapOldCMVar.put(oCmVar.Campaign__c,mapOldCM.get(oCmVar.Id));
            }
            else{
                
                //Checking for insert event of Campaign Member record 
                //with Role as Team Member                
                if((mapNewCM.get(oCmVar.Id).Role__c!=null)
                &&(mapNewCM.get(oCmVar.Id).Role__c==System.label.TeamMember))  
                mapNewCMVar.put(oCmVar.Campaign__c,oCmVar);
                
            }
        }        

        try{
            
            if(mapNewCMVar.size()>0){
                //Initiating follow  Chatter Helper to follow Campaign Record 
                //by Campaign Member
                FollowUnFollowChatterHelper.autoFollowsObject(
                (Map<Id,sobject>)mapNewCMVar,'Name__c','Campaign__c');  
            }
            if(mapOldCMVar.size()>0){
                //Initiating unfollow  Chatter Helper to 
                //unfollow Campaign Record 
                //by Campaign Member
                FollowUnFollowChatterHelper.autoUnfollowsObject(
                (Map<Id,sobject>)mapOldCMVar,'Name__c');  
            } 
            
        }
        catch(Exception ex){            
           
                    }

    }
    /**
    * Method name  : unFollowOnDelete
    * Description  : Use this method to initiate helper class to  
                     unfollow Campaign on delete Campaign Member record 
    *                
    * Return Type  : Map<Id,Campaign_Member__c>
    * Parameter    : void
    **/ 
    public static void unFollowOnDelete(
    List<Campaign_Member__c> lstOldCM){

        Map<Id,Campaign_Member__c> mapOldCMVar=
        new Map<Id,Campaign_Member__c>();
        for(Campaign_Member__c oCmVar: lstOldCM){            
            
            if(oCmVar.Role__c==System.label.TeamMember)
            {   
                mapOldCMVar.put(oCmVar.Campaign__c,oCmVar);
            }

            if(mapOldCMVar.size()>0){
                //Initiating unfollow  Chatter Helper 
                //to unfollow Campaign Record by deleting Campaign Member
                FollowUnFollowChatterHelper.autoUnfollowsObject(
                (Map<Id,sobject>)mapOldCMVar,'Name__c');  
            } 

        }

    } 
}