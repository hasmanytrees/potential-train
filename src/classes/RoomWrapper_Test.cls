@isTest(seeAllData=true)
private class RoomWrapper_Test
{   
        public static testMethod void testRoomWrapper()
     {    
      Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharashtra', ZIP_Code__c='400059', Country__c='India', Room_No__c='A101');
      insert ven;
      system.assertEquals('Venue test',ven.Name);
      
        Venue__C venRoom1 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven.Id,Name='Venue test Room1', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom1;
        RoomWrapper roomwrap=new RoomWrapper(venRoom1 );
        
      system.assertEquals('Venue test Room1',venRoom1.Name);  
    
    }
}