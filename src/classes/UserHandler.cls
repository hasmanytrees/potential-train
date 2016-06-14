/***************************************************************************
    Name             : UserHandler
    Description      : User Related Trigger Handler for One Login Issues           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                  15/05/2015            Created
Shanu                   19/10/2015             Changes made for INC0067756
*****************************************************************************/


public class UserHandler{

    /**
    * Method name  : onBeforeUpdate
    * Description  : This method will be called before any Account record 
                     is udpated
    * Return Type  : void
    * Parameter    : List<User> lstNewRecords, Map<Id,User> mapOldRecords
    **/    
    public void onBeforeUpdate(List<User> lstNewRecords, Map<Id,
    User> mapOldRecords) {
       
        // This Label is used to turn this method ON/OFF
            preventUserUpdate(lstNewRecords, mapOldRecords);
        //}
        
    }
    
    /**
    * Method name  : preventUserUpdate
    * Description  : This method will update Timezone and Locale of the user with 
                    the previous value if the record is updated by One Login user.                        
    * Return Type  : void
    * Parameter    : List<User> lstNewRecords, Map<Id,User> mapOldRecords
    **/ 
     //Shanu- Oct 2015 Changes made for INC0067756
    private void preventUserUpdate(List<User> lstNewRecords, Map<Id,
    User> mapOldRecords){
         
         Id oneLoginUserId = System.Label.One_Login_User_Id;
         // This custom setting is used to hold the user Id of the One login user 
         String sVolunteerProfile=System.label.VolunteerProfiles;
         String [] sProfileNameArr = sVolunteerProfile.split(';');
         String sProfileName = '';
         sProfileName=[select Id,Name from Profile where 
            Id=:userinfo.getProfileId()][0].Name;
            for(User oUser: lstNewRecords){
            
            Boolean sValue=true;
            
            
                                
            for(String s: sProfileNameArr)
            {
                if(s.equals(sProfileName))
                    sValue=false;
            }
            
            if((userinfo.getUserId() == oneLoginUserId && oUser.Id != oneLoginUserId) || (oUser.Id != oneLoginUserId && sValue==false))
            // In this block we are overriding the previous value 
            //with the current value, that means these fields can be
            //updated by all users except the ones with the following profiles:
            // Volunteer Coordinator, Volunteer Manager/Event Spec, Volunteer Onsite Facilitator
            //or the ones configured in One Login. 
            {
                oUser.TimeZoneSidKey = 
                mapOldRecords.get(oUser.Id).TimeZoneSidKey;
                oUser.LocaleSidKey = 
                mapOldRecords.get(oUser.Id).LocaleSidKey;
                oUser.LanguageLocaleKey = 
                mapOldRecords.get(oUser.Id).LanguageLocaleKey;
            }
        }
    }
}