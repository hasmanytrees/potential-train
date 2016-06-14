/*****************************************************************************************
    Name             : DeDupeSearchLeadController_Test
    Description      : Main test class  to cover all Id scenarios in Buttons classes                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(SeeAllData=true)
public class DeDupeSearchLeadController_Test{

       static testMethod void DeDupe_Test()
    { 
      
   DeDupeSearchLeadController dsc = new DeDupeSearchLeadController();
   dsc.sLeadFirstName = 'test Acc First Name';
      dsc.search();
       dsc.sLeadLastName = 'Acc Last Name'; 
       dsc.search();
       dsc.sLeadEmail = 'abc@gmail.com';
       dsc.search();
       dsc.sLeadPhone = '8623782872';
       dsc.search();
       dsc.sLeadAddress = 'address Lead';       
      
       dsc.search();
   Lead oLeadVar21=new Lead(LastName='Test787997data2',Phone='9945349999',PostalCode='37478',Email='test12312809data2@testdata.com',Company='Ttest',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar21;
       Id [] fixedSearchResults= new Id[1];
       fixedSearchResults[0] = oLeadVar21.id;
       Test.setFixedSearchResults(fixedSearchResults);
      dsc.sLeadFirstName = 'Testdata2';
     // dsc.search();
       dsc.sLeadLastName = 'Ttest'; 
       //dsc.search();
       dsc.sLeadEmail = 'testdata2@testdata.com';
       //dsc.search();
       dsc.sLeadPhone = '999999999999';
       //dsc.search();
       dsc.sLeadAddress = '37478';       
      
       dsc.search();
       
        dsc.init();
       
       Lead oLeadVar1=new Lead(Phone='7843528999',LastName='Testqwqedata',Company='test',Email='testdata1@testdata.com',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar1;
       Lead oLeadVar2=new Lead(Phone='5465090978',LastName='Testhjkhhljhldata',Company='test',Email='testdata2@testdata.com',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar2; 
        Lead oLeadVar3=new Lead(Phone='1245903467',LastName='Testslolwdderdata',Company='test',Email='testdata3@testdata.com',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar3; 
        Lead oLeadVar4=new Lead(Phone='8989673427',LastName='Testuyuhgshgdata',Company='test',Email='testdata4@testdata.com',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar4; 
        DeDupeSearchLeadController.LeadWrapper Accwrap = new DeDupeSearchLeadController.LeadWrapper(oLeadVar1,true);     
        Accwrap.oLead = oLeadVar1;
        Accwrap.bIsSelected = true;   
        DeDupeSearchLeadController.LeadWrapper Accwrap2 = new DeDupeSearchLeadController.LeadWrapper(oLeadVar1,true);     
        Accwrap2.oLead = oLeadVar2;
        Accwrap2.bIsSelected = true; 
         DeDupeSearchLeadController.LeadWrapper Accwrap3 = new DeDupeSearchLeadController.LeadWrapper(oLeadVar1,true);     
        Accwrap3.oLead = oLeadVar3;
        Accwrap3.bIsSelected = true;
         DeDupeSearchLeadController.LeadWrapper Accwrap4 = new DeDupeSearchLeadController.LeadWrapper(oLeadVar1,true);     
        Accwrap4.oLead = oLeadVar4;
        Accwrap4.bIsSelected = true;   
        dsc.lstLeadWrapper.add(Accwrap);
        dsc.lstLeadWrapper.add(Accwrap2);
        dsc.lstLeadWrapper.add(Accwrap3);
        dsc.lstLeadWrapper.add(Accwrap4);
         fixedSearchResults= new Id[4];
       fixedSearchResults[0] = oLeadVar1.id;
       fixedSearchResults[1] = oLeadVar2.id;
       fixedSearchResults[2] = oLeadVar3.id;
       fixedSearchResults[3] = oLeadVar4.id;
       Test.setFixedSearchResults(fixedSearchResults);
        dsc.sLeadFirstName = 'Testdata'; 
         dsc.search();
       dsc.sSelectedLead = '0,' ;
        dsc.mergeLead();
        dsc.sSelectedLead = '0,1' ;
        dsc.mergeLead();
         dsc.sSelectedLead = '0,1,2,3';
        dsc.mergeLead();
   } 
   
   static testMethod void DeDupe_Test2()
    { 
      
   DeDupeSearchLeadController dsc = new DeDupeSearchLeadController();
     
       dsc.sLeadLastName = 'Acc Last Name'; 
       dsc.search();
       dsc.sURL = 'Demo URL';
       System.assertEquals('Demo URL', dsc.sURL);    
       Lead oLeadVar1=new Lead(PostalCode='32145',Street='test srteet',City='test City',
                                           State='test State',Company='Ttest',
                                           LastName='Test43545345333334data1',Email='test123766data1@testdata.com',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar1;
       Lead oLeadVar2=new Lead(PostalCode='32145',Street='test srteet',City='test City',
                                           State='test State',Company='Ttest',
                                           LastName='Test2324232data1',Email='test21212121data1@testdata.com',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar2;
       Lead oLeadVar3=new Lead(PostalCode='32145',Street='test srteet',City='test City',
                                           State='test State',Company='Ttest',
                                           LastName='Test111111data1',Email='testdata11111@testdata.com',dupcheck__dc3DisableDuplicateCheck__c=true);
       insert oLeadVar3;
       System.assert(oLeadVar1.id <> null);
       
       
       DeDupeSearchLeadController dsc2 = new DeDupeSearchLeadController();
       Id [] fixedSearchResults= new Id[1];
       fixedSearchResults[0] = oLeadVar1.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2.sLeadAddress = '3214'; 
        dsc2.sLeadFirstName = 'Testdata1'; 
       dsc2.search();
       fixedSearchResults[0] = oLeadVar2.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2.sLeadAddress = '3214'; 
       dsc2.search();
       fixedSearchResults[0] = oLeadVar2.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2 = new DeDupeSearchLeadController();
       dsc2.sLeadAddress = '3214'; 
       dsc2.search();
       dsc2.sSelectedLead=oLeadVar2.id+','+oLeadVar1.id;
       dsc2.mergeLead();
      
   } 
      
}