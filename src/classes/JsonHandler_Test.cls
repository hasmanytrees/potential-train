/*****************************************************************************************
    Name             : JsonHandler_Test
    Description      : This class is used as dynamic JSON Generator and 
                       also use 
                       in generating serialized String and de serialized 
                       list of sObject              
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class JsonHandler_Test{

  //Creating Test Data
   

         public testMethod static void JsonHandlerMethods()
     {
     
     Test.StartTest() ; 
     JsonHandler.ZipCodeDetails jShand = new JsonHandler.ZipCodeDetails();
     
     jShand.zip_code = '12345';
     jShand.distance= '15';
     jShand.city= 'Delhi';
     jShand.state= 'Delhi';
     
     system.assertEquals('Delhi',jShand.state);
     Test.StopTest() ; 
     }
     
     
     }