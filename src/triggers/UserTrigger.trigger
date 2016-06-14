/******************************************************************************************************
Class Name         : UserTrigger
Deascription       : This is single trigger for User which will cover all the trigger events.
                     All the functionality on user should be called from this trigger. Methods 
                     to cover all user functionality will be defined in UserHandler class named
                     UserHandler.
Created By         : Sumeet Kanjilal 
Created On         : 15-May-2015 
******************************************************************************************************/

trigger UserTrigger on User (before Update) {
    
    UserHandler oUserHandler = new UserHandler();
    if(Trigger.isBefore && Trigger.isUpdate) {
        oUserHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}