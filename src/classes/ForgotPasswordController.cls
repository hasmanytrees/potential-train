/*****************************************************************************************
    Name             : ForgotPasswordController
    Description      : An apex page controller that exposes the site forgot password functionality             
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String sUserName {get; set;}   
       
    public ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean bSuccess = Site.forgotPassword(sUserName);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (bSuccess) {              
            return pr;
        }
        return null;
    }
}