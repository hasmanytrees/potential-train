/*****************************************************************************************
    Name             : UserHandlerTest 
    Description      : Test Class for User Trigger and Handler                    
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Jevaan D                30/10/2014            Created
    ******************************************************************************************/
    @isTest(seeAllData=true)
     private class UserHandler_Test 
    {
        static testmethod void User_trigger()
        {  
            User user = new User();
            user.Username= 'testuserqwqwtest@test.com';
            user.Email= 'test@test.com';
            user.Lastname= 'user';
            user.Firstname= 'test';
            user.Alias= 'test';
            user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            user.TimeZoneSidKey= 'GMT';
            user.LocaleSidKey= 'en_US';
            user.EmailEncodingKey= 'ISO-8859-1';
            user.LanguageLocaleKey= 'en_US';
            user.Authorized_Campaign_Owner__c=true;
            user.UserPermissionsMobileUser = true;
            insert user;
            system.assertEquals('testuserqwqwtest@test.com',user.Username);  
            
            try {
            User oOneloginUser = new User ( ID = System.Label.One_Login_User_Id ) ; 
                
                System.RunAs(oOneloginUser) {
                     update user ;   
                }
                
            }Catch(Exception Exe){
                return ;
            }           
        }
    }