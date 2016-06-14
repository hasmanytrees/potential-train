/*****************************************************************************************
    Name             : DeDupeSearchContactController_Test
    Description      : Main test class  to cover all Id scenarios in Buttons classes                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(SeeAllData=true)
public class DeDupeSearchContactController_Test{

       static testMethod void DeDupe_Test()
    { 
   Account oAccountVar2=new Account(Type='Business',Status__c='Active',Name='Testdata2',Business_Email__c='testdata2@testdata.com');
       insert oAccountVar2;   
   DeDupeSearchContactController dsc = new DeDupeSearchContactController();
   dsc.sContactFirstName = 'test Acc First Name';
      dsc.search();
       dsc.sContactLastName = 'Acc Last Name'; 
       dsc.search();
       dsc.sContactEmail= 'abc@gmail.com';
       dsc.search();
       dsc.sContactPhone= '8623782872';
       dsc.search();
       dsc.sContactAddress = 'address Contact';       
      
       dsc.search();
   Contact oContactVar21=new Contact(AccountId=oAccountVar2.Id,LastName='Testdata2',HomePhone='999999999999',MailingPostalCode='37478',Preferred_Email__c='testdata2@testdata.com',FirstName='Ttest');
       insert oContactVar21;
       Id [] fixedSearchResults= new Id[1];
       fixedSearchResults[0] = oContactVar21.id;
       Test.setFixedSearchResults(fixedSearchResults);
      dsc.sContactLastName = 'Testdata2';
     // dsc.search();
       dsc.sContactLastName = 'Ttest'; 
       //dsc.search();
       dsc.sContactEmail= 'testdata2@testdata.com';
       //dsc.search();
       dsc.sContactPhone= '999999999999';
       //dsc.search();
       dsc.sContactAddress = '37478';       
      
       dsc.search();
       
        dsc.init();
       
       Contact oContactVar1=new Contact(AccountId=oAccountVar2.Id,HomePhone='9999999999',LastName='Testdata',FirstName='test',Preferred_Email__c='testdata1@testdata.com');
       insert oContactVar1;
       Contact oContactVar2=new Contact(AccountId=oAccountVar2.Id,HomePhone='9999999999',LastName='Testdata',FirstName='test',Preferred_Email__c='testdata2@testdata.com', 
                                        dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oContactVar2; 
        Contact oContactVar3=new Contact(AccountId=oAccountVar2.Id,HomePhone='9999999999',LastName='Testdata',FirstName='test',Preferred_Email__c='testdata3@testdata.com',
                                        dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oContactVar3; 
        Contact oContactVar4=new Contact(AccountId=oAccountVar2.Id,HomePhone='9999999999',LastName='Testdata',FirstName='test',Preferred_Email__c='testdata4@testdata.com',
                                        dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oContactVar4; 
        DeDupeSearchContactController.ContactWrapper Accwrap = new DeDupeSearchContactController.ContactWrapper(oContactVar1,true);     
        Accwrap.oContact = oContactVar1;
        Accwrap.bIsSelected = true;   
        DeDupeSearchContactController.ContactWrapper Accwrap2 = new DeDupeSearchContactController.ContactWrapper(oContactVar1,true);     
        Accwrap2.oContact = oContactVar2;
        Accwrap2.bIsSelected = true; 
         DeDupeSearchContactController.ContactWrapper Accwrap3 = new DeDupeSearchContactController.ContactWrapper(oContactVar1,true);     
        Accwrap3.oContact = oContactVar3;
        Accwrap3.bIsSelected = true;
         DeDupeSearchContactController.ContactWrapper Accwrap4 = new DeDupeSearchContactController.ContactWrapper(oContactVar1,true);     
        Accwrap4.oContact = oContactVar4;
        Accwrap4.bIsSelected = true;   
        dsc.lstContactWrapper.add(Accwrap);
        dsc.lstContactWrapper.add(Accwrap2);
        dsc.lstContactWrapper.add(Accwrap3);
        dsc.lstContactWrapper.add(Accwrap4);
         fixedSearchResults= new Id[4];
       fixedSearchResults[0] = oContactVar1.id;
       fixedSearchResults[1] = oContactVar2.id;
       fixedSearchResults[2] = oContactVar3.id;
       fixedSearchResults[3] = oContactVar4.id;
       Test.setFixedSearchResults(fixedSearchResults);
        dsc.sContactLastName = 'Testdata'; 
         dsc.search();
       dsc.sSelectedContact = '0,' ;
        dsc.mergeContact();
        dsc.sSelectedContact = '0,1' ;
        dsc.mergeContact();
         dsc.sSelectedContact = '0,1,2,3';
        dsc.mergeContact();
   } 
   
   static testMethod void DeDupe_Test2()
    { 
     Account oAccountVar2=new Account(Type='Business',Status__c='Active',Name='Testdata2',Business_Email__c='testdata2@testdata.com');
       insert oAccountVar2;    
   DeDupeSearchContactController dsc = new DeDupeSearchContactController();
     
       dsc.sContactLastName = 'Acc Last Name'; 
       dsc.search();
       dsc.sURL = 'Demo URL';
       System.assertEquals('Demo URL', dsc.sURL);    
       Contact oContactVar1=new Contact(AccountId=oAccountVar2.Id,MailingPostalCode='3214',//MailingStreet='test street',MailingCity='test MailingCity',
                                           MailingState='test State',//MailingCountry='usa',
                                           FirstName='Ttest',
                                           LastName='Testdata1',Preferred_Email__c='testdata1@testdata.com');
       insert oContactVar1;
       Contact oContactVar2=new Contact(AccountId=oAccountVar2.Id,OtherPostalCode='3214590',//MailingStreet='test srteet',MailingCity='test MailingCity',
                                           MailingState='Pine Bluff',//MailingCountry='usa',
                                           FirstName='Ttest',
                                           LastName='Testdata1',Preferred_Email__c='testdata1@testdata.com');
       insert oContactVar2;
       Contact oContactVar3=new Contact(AccountId=oAccountVar2.Id,MailingPostalCode='32145',//MailingStreet='test srteet',MailingCity='test MailingCity',
                                           MailingState='Pine Bluff',//MailingCountry='usa',
                                           FirstName='Ttest',
                                           LastName='Testdata1',Preferred_Email__c='testdata1@testdata.com');
       insert oContactVar3;
       System.assert(oContactVar1.id <> null);
       
       
       DeDupeSearchContactController dsc2 = new DeDupeSearchContactController();
       Id [] fixedSearchResults= new Id[1];
       fixedSearchResults[0] = oContactVar1.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2.sContactAddress = '32145'; 
        dsc2.sContactFirstName = 'Testdata1'; 
       dsc2.search();
       fixedSearchResults[0] = oContactVar2.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2.sContactAddress = '3214590'; 
       dsc2.search();
       fixedSearchResults[0] = oContactVar2.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2 = new DeDupeSearchContactController();
       dsc2.sContactAddress = '32145'; 
       dsc2.search();
       dsc2.sSelectedContact=oContactVar2.id+','+oContactVar1.id;
       dsc2.mergeContact();
      
   } 
      
}