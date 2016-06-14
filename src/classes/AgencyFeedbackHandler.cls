/***************************************************************************
    Name             : AgencyFeedbackHandler
    Description      : Trigger Handler class used to filter Trigger records 
                        and pass to needed to Helper Class
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
***************************************************************************/
public without SHaring class AgencyFeedbackHandler{

    /**
    * Method name  : calculateFeedbackScore
    * Description  : Use this method to initiate helper class for owner 
                     Agency Feedback roll up 
    *                
    * Return Type  : void
    * Parameter    : List<Agency_Feedback__c>
    **/   

    public static void calculateFeedbackScore
    (List<Agency_Feedback__c> lstAgencyFeedback)
    {
        Set<Id> setAgencyId=new Set<Id>();
        for(Agency_Feedback__c oFeedBackVar: lstAgencyFeedback )
        // Getting Ids of All Related Agnecy
        setAgencyId.add(oFeedBackVar.Agency__c);               

         // Initiating feedback roll up helper class
        FeedbackRollUpHelper.rollUpAgencyFeedback(setAgencyId); 


    }

}