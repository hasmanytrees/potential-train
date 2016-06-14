@isTest(seeAllData=false)
private class FilterListHandler_Test{

         public static testMethod void testFilterListHandler()
     {         
        FilterListHandler listHandler=new FilterListHandler();
        
        //------------
        listHandler.fieldList.add(new selectOption('-None-','-None-'));
        listHandler.fieldList.add(new selectOption('Name','Room Name'));
        listHandler.fieldList.add(new selectOption('Capacity__c','Room Capacity'));
        listHandler.fieldList.add(new selectOption('Comment__c','Comment'));
        //-------------------
        listHandler.valueTypeMap.put('Name','Quote Need');
        listHandler.valueTypeMap.put('Comment__c','Quote Need');
        //------------        
        listHandler.operatorList.add(new selectOption('-None-','-None-'));
        listHandler.operatorList.add(new selectOption('=','equals'));
        listHandler.operatorList.add(new selectOption('like','contains'));
        listHandler.operatorList.add(new selectOption(' >','greater than'));
        listHandler.operatorList.add(new selectOption(' <','less than'));
        listHandler.operatorList.add(new selectOption(' !=','Not Equals'));    
        //------------------      
        
        listHandler.sKeyWordSearch ='12';
        
        listHandler.resetSelectedValue();
        
        FilterListCompController Flist_controller = new FilterListCompController();
        
        
        Flist_controller.pageBlockTitle='PageBlockTitle';
        Flist_controller.bDisplayMaxResultSize=true;
        Flist_controller.sLogicString='sLogicString';
        
        Flist_controller.setselectedFirstParam('Room_No__c');
        Flist_controller.setselectedSecondParam('+');
        Flist_controller.getselectedThirdParam();
        Flist_controller.getselectedFirstParam();
        Flist_controller.getselectedSecondParam();     
        Flist_controller.getiDefaultSize();
        Flist_controller.setfilterListHandler(listHandler);
        Flist_controller.getfilterListHandler();
        Flist_controller.setiDefaultSize(5);
        
        system.assertEquals(5,Flist_controller.getiDefaultSize());
        
        Flist_controller.iDefaultSize=1;
        //Flist_controller.setiDefaultSize(1);
        Flist_controller.setselectedThirdParam('Selected');    
        Flist_controller.increaseCounter();
        Flist_controller.removeCounter();    
        Flist_controller.setoperatorList();
        
        Flist_controller.sLinkName ='Fewer Filter <<<';
        Flist_controller.oneLinkCounter();
        
        string sSelectedField = 'Comment__c';
        string sSelectedOperator = ' like ';
        string sSelectedTextvalue = '+';     
        
        listHandler.sSelectedFieldList.add(sSelectedField );    
        listHandler.sSelectedOperatorList.add(sSelectedOperator );
        listHandler.sSelectedTextValue.add(sSelectedTextvalue );  
         
        Flist_controller.formQuery();
        // Flist_controller.formatInput();
    }
    
        public static testMethod void testFilterListHandler_Negative_sLinkName()
     {         
        FilterListHandler listHandler=new FilterListHandler();
        
        //------------
        listHandler.fieldList.add(new selectOption('-None-','-None-'));
        listHandler.fieldList.add(new selectOption('Name','Room Name'));
        listHandler.fieldList.add(new selectOption('Capacity__c','Room Capacity'));
        listHandler.fieldList.add(new selectOption('Comment__c','Comment'));
        //-------------------
        listHandler.valueTypeMap.put('Name','Quote Need');
        listHandler.valueTypeMap.put('Comment__c','Quote Need');
        //------------        
        listHandler.operatorList.add(new selectOption('-None-','-None-'));
        listHandler.operatorList.add(new selectOption('=','equals'));
        listHandler.operatorList.add(new selectOption('like','contains'));
        listHandler.operatorList.add(new selectOption(' >','greater than'));
        listHandler.operatorList.add(new selectOption(' <','less than'));
        listHandler.operatorList.add(new selectOption(' !=','Not Equals'));    
        //------------------      
        
        listHandler.sKeyWordSearch ='12';
        
        listHandler.resetSelectedValue();
        
        FilterListCompController Flist_controller = new FilterListCompController();
        
        
        Flist_controller.pageBlockTitle='PageBlockTitle';
        Flist_controller.bDisplayMaxResultSize=true;
        Flist_controller.sLogicString='sLogicString';
        
        Flist_controller.setselectedFirstParam('selectedVal');
        Flist_controller.setselectedSecondParam('selectedVal');
        Flist_controller.getselectedThirdParam();
        Flist_controller.getselectedFirstParam();
        Flist_controller.getselectedSecondParam();
        Flist_controller.getiDefaultSize();
        Flist_controller.setfilterListHandler(listHandler);
        Flist_controller.getfilterListHandler();
        Flist_controller.setiDefaultSize(5);
        
        system.assertEquals(5,Flist_controller.getiDefaultSize());
        
        Flist_controller.iDefaultSize=1;
        //Flist_controller.setiDefaultSize(1);
        Flist_controller.setselectedThirdParam('Selected');    
        Flist_controller.increaseCounter();
        Flist_controller.removeCounter();    
        Flist_controller.setoperatorList();
        
        Flist_controller.sLinkName ='More Filter >>>';
        Flist_controller.oneLinkCounter();
        
        string sSelectedField = 'Comment__c';
        string sSelectedOperator = ' = ';
        string sSelectedTextvalue = '+';     
        
        listHandler.sSelectedFieldList.add(sSelectedField );    
        listHandler.sSelectedOperatorList.add(sSelectedOperator );
        listHandler.sSelectedTextValue.add(sSelectedTextvalue );  
         
        Flist_controller.formQuery();
        // Flist_controller.formatInput();
    }
    
       public static testMethod void testFilterListHandler_MultiSelect()
     {         
        FilterListHandler listHandler=new FilterListHandler();
        
        //------------
        listHandler.fieldList.add(new selectOption('-None-','-None-'));
        listHandler.fieldList.add(new selectOption('Name','Room Name'));
        listHandler.fieldList.add(new selectOption('Capacity__c','Room Capacity'));
        listHandler.fieldList.add(new selectOption('Comment__c','Comment'));
        //-------------------
        listHandler.valueTypeMap.put('Name','multiselect');
        listHandler.valueTypeMap.put('Comment__c','multiselect');
        //------------        
        listHandler.operatorList.add(new selectOption('-None-','-None-'));
        listHandler.operatorList.add(new selectOption('=','equals'));
        listHandler.operatorList.add(new selectOption('like','contains'));
        listHandler.operatorList.add(new selectOption(' >','greater than'));
        listHandler.operatorList.add(new selectOption(' <','less than'));
        listHandler.operatorList.add(new selectOption(' !=','Not Equals'));    
        //------------------      
        
        listHandler.sKeyWordSearch ='12';
        
        listHandler.resetSelectedValue();
        
        FilterListCompController Flist_controller = new FilterListCompController();
        
        
        Flist_controller.pageBlockTitle='PageBlockTitle';
        Flist_controller.bDisplayMaxResultSize=true;
        Flist_controller.sLogicString='sLogicString';
        
        Flist_controller.setselectedFirstParam('selectedVal');
        Flist_controller.setselectedSecondParam('selectedVal');
        Flist_controller.getselectedThirdParam();
        Flist_controller.getselectedFirstParam();    
        Flist_controller.getselectedSecondParam();
        Flist_controller.getiDefaultSize();
        Flist_controller.setfilterListHandler(listHandler);
        Flist_controller.getfilterListHandler();
        Flist_controller.setiDefaultSize(5);
        
        system.assertEquals(5,Flist_controller.getiDefaultSize());
        
        Flist_controller.iDefaultSize=1;
        //Flist_controller.setiDefaultSize(1);
        Flist_controller.setselectedThirdParam('Selected');    
        Flist_controller.increaseCounter();
        Flist_controller.removeCounter();    
        Flist_controller.setoperatorList();
        
        Flist_controller.sLinkName ='More Filter >>>';
        Flist_controller.oneLinkCounter();
        
        string sSelectedField = 'Comment__c';
        string sSelectedOperator = ' like ';
         string sSelectedOperator1 = '=';
        string sSelectedTextvalue = '+';     
        
        listHandler.sSelectedFieldList.add(sSelectedField );    
        listHandler.sSelectedOperatorList.add(sSelectedOperator );
          listHandler.sSelectedOperatorList.add(sSelectedOperator1 );
        listHandler.sSelectedTextValue.add(sSelectedTextvalue );  
         
        Flist_controller.formQuery();
        // Flist_controller.formatInput();
    }
    
      public static testMethod void testFilterListHandler_MultiSelect1()
     {         
        FilterListHandler listHandler=new FilterListHandler();
        
        //------------
        listHandler.fieldList.add(new selectOption('-None-','-None-'));
        listHandler.fieldList.add(new selectOption('Name','Room Name'));
        listHandler.fieldList.add(new selectOption('Capacity__c','Room Capacity'));
        listHandler.fieldList.add(new selectOption('Comment__c','Comment'));
        //-------------------
        listHandler.valueTypeMap.put('Name','multiselect');
        listHandler.valueTypeMap.put('Comment__c','multiselect');
        //------------        
        listHandler.operatorList.add(new selectOption('-None-','-None-'));
        listHandler.operatorList.add(new selectOption('=','equals'));
        listHandler.operatorList.add(new selectOption('like','contains'));
        listHandler.operatorList.add(new selectOption(' >','greater than'));
        listHandler.operatorList.add(new selectOption(' <','less than'));
        listHandler.operatorList.add(new selectOption(' !=','Not Equals'));    
        //------------------      
        
        listHandler.sKeyWordSearch ='12';
        
        listHandler.resetSelectedValue();
        
        FilterListCompController Flist_controller = new FilterListCompController();        
        Flist_controller.pageBlockTitle='PageBlockTitle';
        Flist_controller.bDisplayMaxResultSize=true;
        Flist_controller.sLogicString='sLogicString';
        
        Flist_controller.setselectedFirstParam('selectedVal');
        Flist_controller.setselectedSecondParam('selectedVal');
        Flist_controller.getselectedThirdParam();
        Flist_controller.getselectedFirstParam();
        Flist_controller.getselectedSecondParam();
        Flist_controller.getiDefaultSize();
        Flist_controller.setfilterListHandler(listHandler);
        Flist_controller.getfilterListHandler();
        Flist_controller.setiDefaultSize(5);
       
        system.assertEquals(5,Flist_controller.getiDefaultSize());
       
        Flist_controller.iDefaultSize=1;
        Flist_controller.setselectedThirdParam('Selected');    
        Flist_controller.increaseCounter();
        Flist_controller.removeCounter();    
        Flist_controller.setoperatorList();
        
        Flist_controller.sLinkName ='More Filter >>>';
        Flist_controller.oneLinkCounter();
        
        string sSelectedField = 'Comment__c';
      //  string sSelectedOperator = ' like ';
         string sSelectedOperator1 = '=';
        string sSelectedTextvalue = '+';     
        
        listHandler.sSelectedFieldList.add(sSelectedField );    
      //  listHandler.sSelectedOperatorList.add(sSelectedOperator );
          listHandler.sSelectedOperatorList.add(sSelectedOperator1 );
        listHandler.sSelectedTextValue.add(sSelectedTextvalue );  
         
        Flist_controller.formQuery();
        // Flist_controller.formatInput();
    }
    
          public static testMethod void testFilterListHandler_Null()
     {         
        FilterListHandler listHandler=new FilterListHandler();
        
        //------------
        listHandler.fieldList.add(new selectOption('-None-','-None-'));
        listHandler.fieldList.add(new selectOption('Name','Room Name'));
        listHandler.fieldList.add(new selectOption('Capacity__c','Room Capacity'));
        listHandler.fieldList.add(new selectOption('Comment__c','Comment'));
        //-------------------
        listHandler.valueTypeMap.put('Name','multiselect');
        listHandler.valueTypeMap.put('Comment__c','multiselect');
        //------------        
        listHandler.operatorList.add(new selectOption('-None-','-None-'));
        listHandler.operatorList.add(new selectOption('=','equals'));
        listHandler.operatorList.add(new selectOption('like','contains'));
        listHandler.operatorList.add(new selectOption(' >','greater than'));
        listHandler.operatorList.add(new selectOption(' <','less than'));
        listHandler.operatorList.add(new selectOption(' !=','Not Equals'));    
        //------------------      
        
        listHandler.sKeyWordSearch ='12';
        
        listHandler.resetSelectedValue();
        
        FilterListCompController Flist_controller = new FilterListCompController();
        
        
        Flist_controller.pageBlockTitle='PageBlockTitle';
        Flist_controller.bDisplayMaxResultSize=true;
        Flist_controller.sLogicString='sLogicString';
        
        Flist_controller.setselectedFirstParam('selectedVal');
        Flist_controller.setselectedSecondParam('selectedVal');
        Flist_controller.getselectedThirdParam();
        Flist_controller.getselectedFirstParam();
        Flist_controller.getselectedSecondParam();
        Flist_controller.getiDefaultSize();
        Flist_controller.setfilterListHandler(listHandler);
        Flist_controller.getfilterListHandler();
        Flist_controller.setiDefaultSize(5);
        
        system.assertEquals(5,Flist_controller.getiDefaultSize());
        
        Flist_controller.iDefaultSize=1;
        //Flist_controller.setiDefaultSize(1);
        Flist_controller.setselectedThirdParam('Selected');    
        Flist_controller.increaseCounter();
        Flist_controller.removeCounter();    
        Flist_controller.setoperatorList();
        
        Flist_controller.sLinkName ='More Filter >>>';
        Flist_controller.oneLinkCounter();
        
        string sSelectedField = 'Comment__c';
      //  string sSelectedOperator = ' like ';
         string sSelectedOperator1 = '=';
        string sSelectedTextvalue = '+';     
        
        listHandler.sSelectedFieldList.add(sSelectedField );    
      //  listHandler.sSelectedOperatorList.add(sSelectedOperator );
          listHandler.sSelectedOperatorList.add(sSelectedOperator1 );
        listHandler.sSelectedTextValue.add(sSelectedTextvalue );  
         
        Flist_controller.formQuery();
        // Flist_controller.formatInput();
        
       try{ listHandler = null; }catch(exception ex){}
        Flist_controller.formQuery();
       
    }
}