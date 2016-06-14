/*****************************************************************************************
    Name             : CommunitiesSelfRegConfirmControllerTest 
    Description      : Test class to cover scenario of  An apex page controller that takes the user to the right start page based on credentials or lack thereof
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Shubhojit              30/10/2014            Created
Subhojit               29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/


@IsTest(seeAllData=false)
public with sharing class CommunitiesSelfRegConfirmControllerTest {
     public testMethod static void testCommunitiesSelfRegConfirmController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesSelfRegConfirmController controller = new CommunitiesSelfRegConfirmController();
      }    
}