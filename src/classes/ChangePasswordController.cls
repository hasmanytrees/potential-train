/*****************************************************************************************
    Name             : ChangePasswordController 
    Description      : An apex page controller that exposes the change password functionality              
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/


public with sharing class ChangePasswordController {
    public String sOldPassword {get; set;}
    public String sNewPassword {get; set;}
    public String sVerifyNewPassword {get; set;}     
    
   
    public PageReference changePassword() {
        return Site.changePassword(sNewPassword , sVerifyNewPassword , sOldPassword );    
    }     
    
    public ChangePasswordController() {}
}