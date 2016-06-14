/******************************************************************************
    Name             : NewDeliverableValidator
    Description      : This class is used for checking the User permission for
                       creating a New Deliverable
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Shanu                   29/09/2015       Created
*******************************************************************************/

global class NewDeliverableValidator{


    /**
    * Method name  : checkIfUserAllowed
    * Description  : Use this method to check the user specific permission for 
                     creating a New Deliverable
    *                
    * Return Type  : String
    * Parameter    : void
    **/

    webservice static String checkIfUserAllowed(){

        String sAllowedProfile=System.label.ProfilesNotAllowedForNewDeliverable;
        String sProfileName = '';
        String value='true';
        
        sProfileName=[select Id,Name from Profile where 
        Id=:UserInfo.getProfileId()][0].Name;
        String [] sProfileNameArr = sAllowedProfile.split(';');
        system.debug('Current profiles:' +sProfileNameArr);
        
        for(String s: sProfileNameArr)
        {
            if(s.equals(sProfileName))
                value='false';
        }
        return value;
    }
    
}