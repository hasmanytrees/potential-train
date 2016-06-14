/*******************************************************************************
    Name             : SiteLoginController 
    Description      : This is an apex page controller that exposes the site 
                       login functionality
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               12/24/2014         Created
Shanu                  4/28/2015        Modified for code re-factoring &
                                                             optimization
*******************************************************************************/
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get
        ('startURL');
        return Site.login(username, password, startUrl);
    }
    
    global SiteLoginController () {}
}