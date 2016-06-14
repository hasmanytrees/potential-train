/*****************************************************************************************
    Name             : PartnerTypeInlineExtension
    Description      : This class is vf controller for LeadMassActionpage which is called from a list button and used to close multiple lead in bulk  using               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class PartnerTypeInlineExtension_Test{

      public testMethod static void testPartnerTypeInlineExtension()
  {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      Account accountTest=new Account(Name='Test Name',Business_Email__c='test@tes.com');
      
      insert accountTest;
      system.assertEquals('Test Name',accountTest.Name);
  
      user u = new user();
  
       Test.setCurrentPageReference(new PageReference('PartnerTypeInline')); 
       ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(accountTest);       
       PartnerTypeInlineExtension controller=new PartnerTypeInlineExtension(sc);
       
       controller.bIsArtist = true;
       controller.bIsBlogger= true;
       controller.bIsAdvocate= true;
       controller.bIsSpeaker= true;
       
       PartnerTypeInlineExtension.HistoryDetails wrapper = new PartnerTypeInlineExtension.HistoryDetails();
       wrapper.sPartnerType = 'test partnerType';
       wrapper.sChangeHistory = 'test sChangeHistory ';
       wrapper.sOldValue = 'test sOldValue ';
       wrapper.sNewValue = 'test sNewValue ';
       wrapper.sField= 'test sField';
       wrapper.oChangedBy = u;
       wrapper.sModifiedDate = 'test date';
             
       controller.getFieldsOnLoad();
       controller.sFieldName='Church';
       controller.generateField();
       controller.save();
       controller.changePageMode();
       controller.sRemoveFieldName='Church';
       controller.removeField();
       controller.save();
       controller.getHistory();
       
       accountTest.Partner_Profile_Type__c='Advocate;Church';
       update accountTest;
       system.assertEquals('Advocate;Church',accountTest.Partner_Profile_Type__c);
        User user6 = new User();
        user6.Username= 'testusertest66@test.com';
        user6.Email= 'test6@test.com';
        user6.Lastname= 'user';
        user6.Firstname= 'test66';
        user6.Alias= 'test';
        user6.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user6.TimeZoneSidKey= 'GMT';
        user6.LocaleSidKey= 'en_US';
        user6.Managerid = userinfo.getuserid();
        user6.EmailEncodingKey= 'ISO-8859-1';
        user6.LanguageLocaleKey= 'en_US';
        user6.Authorized_Campaign_Owner__c=true;
        user6.UserPermissionsMobileUser = true;
        insert user6;
       Partner_Type__c partnerTypeChurchTest=new Partner_Type__c (recordtypeId=Utility.getRecordTypeMap('Partner_Type__c').get('Church'),Type__c='Church',OwnerId=UserInfo.getUserId(),Account__c=accountTest.Id);
       insert partnerTypeChurchTest;
      
       Partner_Type__c partnerTypeAdvocateTest=new Partner_Type__c (recordtypeId=Utility.getRecordTypeMap('Partner_Type__c').get('Advocate'),Type__c='Advocate',OwnerId=UserInfo.getUserId(),Account__c=accountTest.Id);
       insert partnerTypeAdvocateTest;
       
       
       system.assertEquals('Advocate',partnerTypeAdvocateTest.Type__c);
       
       //List<Partner_Type__History> listHistory=[select Id,ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM Partner_Type__History 
       //                                            where ParentId =:partnerTypeAdvocateTest.id order by CreatedDate desc];
       
       //Map<Id,Partner_Type__c> mapPartnerType=new Map<Id,Partner_Type__c>([select Id,OwnerId,Type__c,recordtypeId from Partner_type__c where Account__c=:accountTest.Id]);
       
       Test.setCurrentPageReference(new PageReference('PartnerTypeInline')); 
       sc = new ApexPages.Standardcontroller(accountTest);
       controller=new PartnerTypeInlineExtension(sc);
       controller.getFieldsOnLoad();
       controller.sFieldName='College';
       controller.generateField();
       controller.save();
       controller.changePageMode();
       controller.sRemoveFieldName='Church';
       controller.removeField();
       controller.save();
       String sss= String.valueOf(partnerTypeChurchTest.OwnerId);
        partnerTypeChurchTest.OwnerId = user6.id;
       update partnerTypeChurchTest;
       partnerTypeAdvocateTest.OwnerId = user6.id;
       update partnerTypeAdvocateTest;
       controller.mapHistory.put(partnerTypeChurchTest.id, partnerTypeChurchTest.Type__c);
       controller.mapHistory.put(partnerTypeAdvocateTest.id, partnerTypeAdvocateTest.Type__c);
      
       controller.getHistory();       
       
       controller.oAccount = new Account();
       
       controller.save();
       
       Test.setCurrentPageReference(new PageReference('PartnerTypeInline')); 
       sc = new ApexPages.Standardcontroller(accountTest);
       controller=new PartnerTypeInlineExtension(sc);
  }

}