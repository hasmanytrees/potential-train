/*****************************************************************************************
    Name             : ConvertToAccountHandler
    Description      : This class contains method which is called from Convert to Partner button
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class ConvertToAccountHandler_Test{

      public testMethod  static void testConvertContact()
    { 
       Test.StartTest() ;    
       lead NewLead = new Lead(Status = 'New', LastName = 'My Name',Company = 'My Company' );
        insert NewLead;
            
        Contact contactTest1=new Contact(LastName='test Contact',MailingCity='Colorado Spring',MailingStreet='NY',MailingState='CO',MailingPostalCode='93120',MailingCountry='US',
                                            Lead__c = NewLead.id, Preferred_Email__c = 'preferred@test.com');
        insert contactTest1;
        
        Contact contactTest2=new Contact(LastName='test Contact2',Work_Phone__c='123',Lead__c = NewLead.id,Alternative_Email__c = 'alternate@test.com');
        insert contactTest2;
        System.assertEquals('test Contact2',contactTest2.LastName);
        
        Account accountTest=new Account(Name='Test Name',Business_Email__c='test@tes.com',Type = 'Individual');
        insert accountTest;
        Contact contactTest3=new Contact(LastName='test Contact3',Work_Phone__c='123',AccountId= accountTest.id,Alternative_Email__c = 'alternate@test.com');
        insert contactTest3;
        System.assertEquals('test Contact3',contactTest3.LastName);
        ConvertToAccountHandler.convertContact(contactTest1.Id);
        ConvertToAccountHandler.convertContact(contactTest2.Id); 
        ConvertToAccountHandler.convertContact(contactTest3.Id); 
        
       Test.StopTest() ;         
    }
}