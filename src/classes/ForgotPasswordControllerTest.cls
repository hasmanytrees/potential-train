/**
 * An apex page controller that exposes the site forgot password functionality
 */
@IsTest(seeAllData=false)
public with sharing class ForgotPasswordControllerTest {
     @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.sUsername = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
         System.assertEquals( 'test@salesforce.com',controller.sUsername); 
    }
}