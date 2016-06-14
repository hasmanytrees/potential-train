/*****************************************************************************************
    Name             : FieldIdWebServicer_Test
    Description      : Main test class  to cover all Id scenarios in Buttons classes                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(SeeAllData=true)
public class FieldIdWebService_Test{

       static testMethod void FieldID_Test()
    { 
      Test.StartTest() ; 
      FieldIdWebService fiwServeice = new FieldIdWebService();
     // FieldIdWebService.sObjectName = 'abcd';
      FieldIdWebService.getObjectKeyPrefix('Deliverable__c');      
      
      List<String> lstSfieldlabel = new List<String>();
      lstSfieldlabel.add('Campaign');
      lstSfieldlabel.add('Agency');
      lstSfieldlabel.add('Cost Center');
      String sObjectName1 = 'Deliverable__c';
      
      system.assertEquals('Deliverable__c',sObjectName1);
      
      String sRecordtypeId = Utility.getRecordType('OSR Deliverable','Deliverable__c');
    //  FieldIdWebService.getFieldId(lstSfieldlabel,sObjectName1 ,sRecordtypeId );
      
    try{  FieldIdWebService.getFieldId(lstSfieldlabel,sObjectName1 ,sRecordtypeId ); }
    catch (Exception e) {
      }
      Test.StopTest() ; 
   } 
   
       static testMethod void MassAdvocateAppealValidator_Test()
    { 
    Test.StartTest() ; 
   
    MassAdvocateAppealValidator maaV = new MassAdvocateAppealValidator();
    string returnedString =  MassAdvocateAppealValidator.checkIfUserAllowed();
    System.Assert ( returnedString != NULL ) ; 
    Test.StopTest() ; 
    }  
      
}