@isTest(seeAllData=true)
public class CommunicationPrefEditExtension_Test{


          private Static List<Account> getAccountData()
      {    
     // List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();

        List<Account> listAccountTestData=new  List<Account>();
        Account accountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',Business_Email__c='testdata1@testdata.com');
        Account accountVar2=new Account(Type='Church',Status__c='Active',Name='Testdata2',Business_Email__c='testdata2@testdata.com');
        Account accountVar3=new Account(Type='Foundation',Status__c='Active',Name='Testdata3',Business_Email__c='testdata3@testdata.com');
        Account accountVar4=new Account(Type='Association',Status__c='Active',Name='Testdata4',Business_Email__c='testdata4@testdata.com'); 
        
        listAccountTestData.add(accountVar1);
        listAccountTestData.add(accountVar2);
        listAccountTestData.add(accountVar3);
        listAccountTestData.add(accountVar4);
        
        return  listAccountTestData;

    }


     public static testMethod void showCommPref()
 {
     //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
     
    //Communication_Preferences__c comPrefCS=new Communication_Preferences__c (Name='test',Category__c='Test',Medium__c='Email',Active__c=true,Language__c='English',Mapping_Fields__c='Appeals_Related_To_Child_Active__c;Appeals_Related_To_Child_Language__c;Appeals_Related_To_Child_Medium__c;Appeals_Related_Child_Email_Opt_Out__c;Appeals_Related_To_Child_Text_Opt_Out__c;Appeals_Related_To_Child_Mail_Opt_Out__c');
    //insert comPrefCS;
    //system.assertEquals('Email',comPrefCS.Medium__c);
    List<Account> listAccountTestData=getAccountData();
    insert listAccountTestData;      //Checking Insert scenarios
   
     system.assertEquals('Association',listAccountTestData[3].Type);
   
    PageReference pageRef=Page.CommunicationPrefEdit;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('accountId',listAccountTestData[0].Id);
    ApexPages.currentPage().getParameters().put('commPrefCSName','Test Name');
    ApexPages.currentPage().getParameters().put('commPrefCSId','Com Id');
 
    CommunicationPrefEditExtension controller= new CommunicationPrefEditExtension();
     ApexPages.currentPage().getParameters().put('commPrefCSId','FULL');
     controller= new CommunicationPrefEditExtension();
 
    controller.save();
 
 }



}