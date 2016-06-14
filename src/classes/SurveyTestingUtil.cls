public with sharing class SurveyTestingUtil {
  public String        surveyId       {get; set;}
  public List<String>  questionIds    {get; set;}
  public String          contactId      {get; set;}
  public String        surveyTakerId  {get; set;}
  public String        contactId2     {get; set;}
   public String        repId     {get; set;}
  
   public String        accId     {get; set;}
   
     public String        caseId     {get; set;}
  
  
  public SurveyTestingUtil(){
    questionIds = new List<String>();
    createTestSurvey();
    createTestQuestions();
    createTestContact();
    createSurveyTaker();
    createTestResponses();
    
  }
  
  private static TestMethod void testConstructor(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    System.assert(tu.surveyId != null);
  }
  
  private void createSurveyTaker(){
    SurveyTaker__c st = new SurveyTaker__c();
    Recipient__c rep=new Recipient__c();
    st.Contact__c = contactId;
    st.Survey__c = surveyId;
    st.Taken__c = 'false';
    insert st;
    system.assertEquals('false',st.Taken__c);
   
    surveyTakerId = st.Id;
    Account acc=new Account(recordtypeId=Utility.getrecordtype('Partner','Account'),Name='Test',Business_Email__c='test1@test.com');
    insert acc;
    system.assertEquals('Test',acc.Name);
    
     rep.Survey__c=surveyId;
     rep.RelatedAccount__c=acc.Id;
    insert rep;
    repId=rep.Id;
    accId=acc.Id;
  }
  
  public void createTestSurvey(){
    Survey__c s = new Survey__c();
    s.Name = 'Testing Survey';
    s.Submit_Response__c = 'empty'; 
    insert s;
    system.assertEquals('Testing Survey',s.Name);
    surveyId = s.Id;
  }
  
  public void createTestQuestions(){
    questionIds.add(createQuestion(0));
    questionIds.add(createQuestion(1));
    questionIds.add(createQuestion(2));
    questionIds.add(createQuestion(3));
  }
  
  private String createQuestion(Integer i){
    Survey_Question__c q = new Survey_Question__c();
    q.Name = 'Testing Question';
    q.Survey__c = surveyId;
    q.Type__c = getType(i);
    q.Choices__c = getChoices();
    q.Question__c = 'Testing Question question';
    q.OrderNumber__c = i;
    q.Required__c = true;
    insert q;
    system.assertEquals('Testing Question',q.Name);
    return q.id;        
  }
  
  
  private void createTestContact() {
       lead NewLead = new Lead(Status = 'New', LastName = 'My Name',Company = 'My Company' );
            insert NewLead;
  
    Contact c = new Contact();
    c.LastName = 'Doe';
    c.FirstName = 'John';
    c.Email = 'surveyAppUser@hotmail.com';
    c.Lead__c = NewLead.id;
    insert c;
    system.assertEquals('Doe',c.LastName);
    contactId = c.Id;   
    
    Contact c2 = new Contact();
    c2.LastName = 'Doe2';
    c2.FirstName = 'John2';
    c2.Email = 'surveyAppUser2@hotmail.com';
    c2.Lead__c = NewLead.id;
    insert c2;
    system.assertEquals('Doe2',c2.LastName);
    contactId2 = c2.Id;   
  }
  
  private void createTestCase() {
    Case c = new Case();
    c.Priority= 'closed';
   
    c.Type= 'problem';
    insert c;
    system.assertEquals('closed',c.Priority);
    caseId     = c.Id;   
    
   
  }
  
  private String createTestResponses() {
    SurveyQuestionResponse__c r = new SurveyQuestionResponse__c();
    r.Response__c = 'two';
    Survey_Question__c sq = [Select id from Survey_Question__c where id=: questionIds[1] limit 1];
    r.Survey_Question__c = sq.id;
    r.SurveyTaker__c = surveyTakerId;
    insert r;
    system.assertEquals(sq.id,r.Survey_Question__c);
    return 'true';
  }
  
  private String getType(Integer i){
    if      (i==1)
     return 'Multi-Select--Vertical';
    else if (i==2)
     return 'Single Select--Vertical';
    else if (i==3)
     return 'Free Text';
    else
     return 'Single Select--Horizontal';
  }
  private String getChoices(){
    return 'one\ntwo\nthree\n';
  }
  
}