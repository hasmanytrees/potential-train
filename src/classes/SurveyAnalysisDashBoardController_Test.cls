@isTest(seeAllData=true)
private class SurveyAnalysisDashBoardController_Test{

    public static testMethod void SurveyTest() 
    {
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
        insert EventTest1;
        system.assertEquals('Test Event1',EventTest1.Name);
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        system.assertEquals('Venue test',Ven.Name);        
        
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc1', status ='Scheduled', 
        Event__c = EventTest1.id, Venue__c = ven.id,Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, 
        Cancellation_Reason__c = 'test Cancel' );
        
        insert EventLocationTest1;
        system.assertEquals('Test Event Loc1',EventLocationTest1.Name);        
        
        
        survey__c survey = new survey__c(RecordtypeId=Utility.getRecordType('Survey Templete','Survey__c'),EVEL__c = EventLocationTest1.id, Submit_Response__c = 'test response'  );
        insert Survey;
        system.assertEquals('test response',survey.Submit_Response__c);                   
        
        SurveyTaker__c SurveyTaker = new SurveyTaker__c(Event_Location__c = EventLocationTest1.id );
        insert SurveyTaker;                 
        
        Recipient__c Recipient = new Recipient__c(Campaign__c = EventLocationTest1.id );
        insert Recipient;
        
        List<Survey_Question__c> listSurveyQuestion = new List<Survey_Question__c>();
        Survey_Question__c SurveyQuestion = new Survey_Question__c(Survey__c = survey.id, Question__c = 'I found out about this event through.', OrderNumber__c = 0, Choices__c = 'An Email', Type__c = 'Single Select--Vertical');
        insert SurveyQuestion;
        Survey_Question__c SurveyQuestion1 = new Survey_Question__c(Survey__c = survey.id, Question__c = 'I found out about this event through.', OrderNumber__c = 0, Choices__c = 'Searching in My Account', Type__c = 'Multi-Select--Vertical');
        insert SurveyQuestion1;
        system.assertEquals('I found out about this event through.',SurveyQuestion.Question__c); 
        
        listSurveyQuestion.add(SurveyQuestion); 
        listSurveyQuestion.add(SurveyQuestion1);
       
        
       // Survey_Question_Answers__c SurveyQuestionAnswers  = new Survey_Question_Answers__c(Event_Location__c = EventLocationTest1.id );
        
        SurveyQuestionResponse__c SurveyQuestionResponse = new SurveyQuestionResponse__c(Survey_Question__c = SurveyQuestion.id, SurveyTaker__c = SurveyTaker.id, Response__c = 'An Email' );
        insert SurveyQuestionResponse;
            
         ApexPages.currentPage().getParameters().put('eventLocationId',EventLocationTest1.id);
         
         SurveyAnalysisDashBoardController tsdController=new SurveyAnalysisDashBoardController();
             
         SurveyAnalysisDashBoardController.PieWedgeChartData pwcd = new SurveyAnalysisDashBoardController.PieWedgeChartData('myName',3);
         tsdController.lstPieWedgeData.clear();
        
     }
      public static testMethod void SurveyTest_emptySurveyQuestionList() 
    {
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
        insert EventTest1;
        system.assertEquals('Test Event1',EventTest1.Name);
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        system.assertEquals('Venue test',Ven.Name);        
        
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc1', status ='Scheduled', 
        Event__c = EventTest1.id, Venue__c = ven.id,Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, 
        Cancellation_Reason__c = 'test Cancel' );
        
        insert EventLocationTest1;
        system.assertEquals('Test Event Loc1',EventLocationTest1.Name);           
        
        
        survey__c survey = new survey__c(RecordtypeId=Utility.getRecordType('Survey Templete','Survey__c'),EVEL__c = EventLocationTest1.id, Submit_Response__c = 'test response'  );
        insert Survey;
        system.assertEquals('test response',survey.Submit_Response__c);           
        
        SurveyTaker__c SurveyTaker = new SurveyTaker__c(Event_Location__c = EventLocationTest1.id );
        insert SurveyTaker; 
        
        Recipient__c Recipient = new Recipient__c(Campaign__c = EventLocationTest1.id );
        insert Recipient;
        
     /*   Survey_Question__c SurveyQuestion = new Survey_Question__c(Survey__c = survey.id, Question__c = 'I found out about this event through.', OrderNumber__c = 0, Choices__c = 'An Email', Type__c = 'Single Select--Vertical');
        insert SurveyQuestion;
        List<Survey_Question__c> listSurveyQuestion = null;
       // Survey_Question_Answers__c SurveyQuestionAnswers  = new Survey_Question_Answers__c(Event_Location__c = EventLocationTest1.id );
        
        SurveyQuestionResponse__c SurveyQuestionResponse = new SurveyQuestionResponse__c(Survey_Question__c = SurveyQuestion.id, SurveyTaker__c = SurveyTaker.id, Response__c = 'An Email' );
        insert SurveyQuestionResponse; */
            
          ApexPages.currentPage().getParameters().put('eventLocationId',EventLocationTest1.id);
         
          SurveyAnalysisDashBoardController tsdController=new SurveyAnalysisDashBoardController();
           
          List<SurveyAnalysisDashBoardController.PieWedgeData> listPieWedgeData = new List<SurveyAnalysisDashBoardController.PieWedgeData>();
             
          SurveyAnalysisDashBoardController.PieWedgeChartData pwcd = new SurveyAnalysisDashBoardController.PieWedgeChartData('myName',3);
         
          
     }
     }