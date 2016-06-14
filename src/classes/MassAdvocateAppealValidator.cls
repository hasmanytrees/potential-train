/******************************************************************************
    Name             : MassAdvocateAppealValidator
    Description      : This class is used for checking the User permission for
                       performing the Mass Advocate Appeal
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014       Created
Sumeet                  29/01/2015       Modified for code re-factoring &
                                         optimization
*******************************************************************************/

global class MassAdvocateAppealValidator{


    /**
    * Method name  : checkIfUserAllowed
    * Description  : Use this method to check the user specific permission for 
                     performing Mass Advocate Appeal
    *                
    * Return Type  : String
    * Parameter    : void
    **/

    webservice static String checkIfUserAllowed(){

        String sAllowedProfile=System.label.AllowedProfileForMassAdvocate;
        
        String sProfileName = '';
        sProfileName=[select Id,Name from Profile where 
        Id=:UserInfo.getProfileId()][0].Name;
        
        if(sAllowedProfile.contains(sProfileName))
        return 'true';
        else
        return 'false';
        
    }
}