/*****************************************************************************************
    Name             : CommunitiesLandingControllerTest 
    Description      : Test class to cover scenario of An apex page controller that takes the user to the right start page based on credentials or lack thereof    
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Shubhojit              30/10/2014            Created
Subhojit               29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/


@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest(seeAllData=false)
    public static void testCommunitiesLandingController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        PageReference pageRef=controller.forwardToStartPage();
      }
}