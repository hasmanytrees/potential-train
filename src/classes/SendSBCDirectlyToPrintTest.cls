/******************************************************************************
Name             : SendSBCDirectlyToPrintTest
Description      : Test class for FetchBeneficaryISLRESTServices                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class SendSBCDirectlyToPrintTest{

    public testMethod static void SendSBCDirectlyToPrint(){  

         Account oBen = TestDataUtility.createBeneficiary () ; 
         Account oSup = TestDataUtility.createSupporter () ; 
         SBC_Communications__c  oSBC = TestDataUtility.createSBCCommRecord ( oBen, oSup , 'Beneficiary To Supporter'  ) ;
        
         List<SBC_Communications__c> lstSBC = new  List<SBC_Communications__c>  () ;     
         lstSBC.add( oSBC ) ; 
        Test.StartTest() ; 
            
            SendSBCDirectlyToPrint oSendSBC = new SendSBCDirectlyToPrint () ; 
            Database.BatchableContext BC ; 
            oSendSBC.start(BC) ; 
            oSendSBC.execute(BC , lstSBC ) ; 
            oSendSBC.finish ( BC ) ; 
        Test.StopTest() ; 
        
    }
    
    public testMethod static void SendSBCDirectlyToPrint1(){  

         Account oBen = TestDataUtility.createBeneficiary () ; 
         Account oSup = TestDataUtility.createSupporter () ; 
         SBC_Communications__c  oSBC = TestDataUtility.createSBCCommRecord ( oBen, oSup , 'Beneficiary To Supporter'  ) ;
        
         List<SBC_Communications__c> lstSBC = new  List<SBC_Communications__c>  () ; 
         
         lstSBC.add( oSBC ) ; 
         oSBC.Batch_Id__c = 'xyzTest'; 
         oSBC.SBC_Global_Id__c = NULL ; 
         update oSBC ; 

         SBC_Communications__c  oSBC1 = TestDataUtility.createSBCCommRecord ( oBen, oSup , 'Beneficiary To Supporter'  ) ;
         oSBC1.Batch_Id__c = 'xyzTest'; 
         oSBC1.SBC_Global_Id__c = NULL ; 
         update oSBC1 ; 
         
         lstSBC.add( oSBC1 ) ;
        Test.StartTest() ; 
            
            SendSBCDirectlyToPrint oSendSBC = new SendSBCDirectlyToPrint () ; 
            Database.BatchableContext BC ; 
            oSendSBC.start(BC) ; 
            oSendSBC.execute(BC , lstSBC ) ; 
            oSendSBC.finish ( BC ) ; 
        Test.StopTest() ; 
        
    }

}