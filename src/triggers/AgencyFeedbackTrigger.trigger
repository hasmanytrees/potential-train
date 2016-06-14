/*******************************************************************************
Name             : AgencyFeedbackTrigger
Description      : Main Agency Feedback Trigger to handle feedback score rollup 
                   logic                 
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & 
                                              optimization
*******************************************************************************/
trigger AgencyFeedbackTrigger on Agency_Feedback__c (After insert,After update,
                                                        After Delete) {


    if(Trigger.isAfter){
        
        if(!Trigger.isDelete)
        {
            if(Trigger_Methods_Activation__c.getInstance
            ('calculateFeedbackScore').
            Is_Trigger_Method_Required_In_Insert__c 
            ||Trigger_Methods_Activation__c.getInstance
            ('calculateFeedbackScore').
            Is_Trigger_Method_Required_In_Update__c)
            {
                //Initiating rollup helper for insert,update
                AgencyFeedbackHandler.calculateFeedbackScore(Trigger.New);  
            }
        }
        else
        {
            if(Trigger_Methods_Activation__c.getInstance
            ('calculateFeedbackScore').
            Is_Trigger_Method_Required_In_Delete__c)
            {
                //Initiating rollup helper for delete
                AgencyFeedbackHandler.calculateFeedbackScore(Trigger.Old); 
            }
        }

    }

}