/*******************************************************************************
    Name             : CampaignMemberTriggerHelper_Test
    Description      : Main Campaign Member Trigger to handle follow and 
                       unfollow Campaign record by Campaign Member              
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
*******************************************************************************/
trigger CampaignMemberTrigger on Campaign_Member__c (after insert,after Update,
after Delete) {


    if(Trigger.IsAfter){

        if((Trigger.IsInsert && Trigger_Methods_Activation__c.getInstance
        ('followAndUnfollowHandlerCM').
        Is_Trigger_Method_Required_In_Insert__c)
        ||(Trigger.IsUpdate && Trigger_Methods_Activation__c.getInstance
        ('followAndUnfollowHandlerCM').
        Is_Trigger_Method_Required_In_Update__c))
        
            //Initiating follow unfollow Chatter Helper to follow and unfollow 
            //Campaign Record by Campaign Member   
            CampaignMemberTriggerHandler.followAndUnfollowHandler(Trigger.newMap,
            Trigger.OldMap);  
        

    }
    if(Trigger.IsDelete && 
    Trigger_Methods_Activation__c.getInstance
    ('unFollowOnDeleteCM').Is_Trigger_Method_Required_In_Delete__c)
    //Initiating unfollow  Chatter Helper to unfollow Campaign Record by
    //deleting Campaign Member 
    CampaignMemberTriggerHandler.unFollowOnDelete(Trigger.Old);    



}