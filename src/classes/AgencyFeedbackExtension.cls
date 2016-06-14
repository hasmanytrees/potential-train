/**************************************************************************
    Name             : AgencyFeedbackExtension
    Description      : Page Controller for AgencyFeedback page 
                       on Account layout.           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
***************************************************************************/
public with Sharing class AgencyFeedbackExtension{

    public Account oAccount{get;set;}    
    public boolean bIsAuthorized{get;set;}
    
     /**
    * Method name  : Parametrized Constructor
    * Description  : Used for Initializing the boolean variables and 
    getting the page parameters and calling the initialization method
    *                
    * Return Type  : void
    * Parameter    : Standard Controller Instance
    **/ 
    public AgencyFeedbackExtension(ApexPages.StandardController controller){

        Id accountId=(Id)controller.getId();
        //Getting profile which have access to this page.
        String sAccessProfiles=System.Label.AgencyFeedbackAccess; 
        //Getting Currently logged in user.
        Profile currentLoggedInUserProfile=[select Name from Profile 
                                            where Id=:UserInfo.getProfileId()];
        if(!sAccessProfiles.Contains(currentLoggedInUserProfile.Name)){
            bIsAuthorized=false;
            //Showing authorization error :You are not authorized to see 
            //                               this information
            ApexPages.addMessage(new ApexPages.Message(
            ApexPages.Severity.INFO,System.label.YouAreNotAuthorized));
        }
        else
            bIsAuthorized=true;
        // Querying account and get feedback rating fields.    
        oAccount=[select Id,Creative__c,Customer_Service__c,Pricing__c,
        Timeliness__c,Overall_Experience__c from Account where Id=:accountId]; 

    }

}