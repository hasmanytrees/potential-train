/************************************************************************
*Class Name         :FilterListCompController
*Deascriotion       : It is the component controller for filterList vf component
*Created By         : Subhojit 
*Created On         : 12/26/2013 

******************************************************************************/

public with Sharing class FilterListCompController{

    public String pageBlockTitle{get;set;}  
    // User inout for value for pageblockSection of filter input

    public String selectedFirstParam;         //selected value for Field     
    
    public String selectedSecondParam;       //selected value for OperatorList
    public String selectedThiredParam ;     //Inout value for text value field
    public Integer iMaxSize{get;set;}       
    //Max size of filter list (inout by user)
    public Integer iMinSize{get;set;}          // Min size of Filter List
    public List<Integer> counter{get;set;}      
    // Conter is used to display list in repeat in vf
    public Integer iDefaultSize;          
    //user input for default no of the filter row
    public boolean bDisplayMaxResultSize{get;set;}  
    //user inout to display max result
    boolean bInternalVar;                 //Internal variable for setting logic
    public String sLogicString{get;set;} 
    Integer index=0; 
    public String sLinkName{get;set;}
    public boolean bShowlink{get;set;}                                 
    public String query{get;set;} 
    Integer iCheckVar=0;  //It alays contains the last row of te filter table 
    

    public FilterListHandler filterListHandler;
    
    public Integer iLastRow{set;                  
        
        get
        {
            system.debug('.............'+counter.size());
            return counter.size()-1;      
        }   
    }

    /*************************************Class Constructor*******************/

    public FilterListCompController()
    {        
        filterListHandler=new FilterListHandler();
        iMaxSize=5;
        iMinSize=3;
        counter=new List<Integer>();
        bInternalVar=true;
        setOperatorList();
        bShowlink=true;
        iMaxSize=5;
        iMinSize=3;
        sLinkName='More Filter >>>';
    }
    
    /***********************Below functions are set and get functions ********/     
    
    
    public void setselectedFirstParam(String selectedVal)
    {
        
        //This function uses to take selected value and stire in the list     
        
        filterListHandler.sSelectedFieldList.add(selectedVal);      
    }

    public void setselectedSecondParam(String selectedVal)
    {
        filterListHandler.sSelectedOperatorList.add(' '+selectedVal+' ');
        system.debug('...2nd...'+filterListHandler.sSelectedOperatorList+'...');
    }

    public String getselectedThirdParam()
    {   
        return null;   
    }

    public String getselectedFirstParam()
    { 
        return null;      
    }

    public String getselectedSecondParam()
    {
        return null;    
    }

    public Integer getiDefaultSize()
    {  
        return iDefaultSize;  
    }
    

    public void setfilterListHandler(FilterListHandler val)
    {
        filterListHandler=val;
        filterListHandler.compControllerRef=this;
        filterListHandler.operatorList.clear();
        setoperatorList();   
    }

    public FilterListHandler getfilterListHandler()
    {   
        return filterListHandler;
    }
    

    public void setiDefaultSize(Integer lim)  
    {
        // based on default size coujter value in list is set
        if(bInternalVar==true)
        {
            for(Integer i=0;i<lim;i++)
            {  
                counter.add(i);
            }
            bInternalVar=false;
            iDefaultSize=lim;
            
            if(iDefaultSize==1)
            {
                sLinkName='More Filter >>>';      
            }
        }
    }

    public void setselectedThirdParam(String selectedVal)
    {
        filterListHandler.sSelectedTextValue.add(selectedVal);
    }
    /***********************Set Functions Ends*****************************/

    /***********Below private function is used for setting the query string 
    with proper formating****************/ 

    private void formatInput()
    {       
        for(Integer i=0;i< filterListHandler.sSelectedFieldList.size();i++)
        {         
            try
            {
                if(filterListHandler.valueTypeMap.get
                ( filterListHandler.sSelectedFieldList[i])=='Quote Need')  
                // Used to add quote for string values
                {                    
                    if(filterListHandler.sSelectedOperatorList[i]==' like ')   
                    // use to add % for like operator 
                    {
                        filterListHandler.sSelectedTextValue[i]=' \'%'+ 
                        filterListHandler.sSelectedTextValue[i]+'%\'';
                        system.debug('..............from if..........'+ 
                        filterListHandler.sSelectedTextValue[i]);
                    }
                    else
                    {                      
                        filterListHandler.sSelectedTextValue[i]=' \''+ 
                        filterListHandler.sSelectedTextValue[i]+'\'';
                        system.debug('..............from else..........'+ 
                        filterListHandler.sSelectedOperatorList[i]);
                    }                     
                } 
                else if (filterListHandler.valueTypeMap.get
                ( filterListHandler.sSelectedFieldList[i])=='multiselect')
                {
                    if(filterListHandler.sSelectedOperatorList[i]==' like ')
                    {
                        filterListHandler.sSelectedOperatorList[i]=' includes ';
                        filterListHandler.sSelectedTextValue[i]=
                        ' (\''+ filterListHandler.sSelectedTextValue[i]
                        .replaceAll(',',';')+'\')';  
                    }
                    else
                    {                      
                        filterListHandler.sSelectedTextValue[i]=
                        ' \''+ filterListHandler.sSelectedTextValue[i]+'\'';
                        system.debug('..............from else..........'+
                        filterListHandler.sSelectedOperatorList[i]);
                    }                        
                }                     
                system.debug('............'+sLogicString); 
            }
            catch(Exception ex)
            {
                Utility.insertErrorLogApplication(ex.getMessage
                ()+'\n'+ex.getStackTraceString(),'FilterListHandler',
                String.valueOf(filterListHandler.sSelectedFieldList[i]),
                'FilterListComp_Controller','formatInput','Application',
                UserInfo.getUserId(), String.valueOf(filterListHandler),null);
            }   
        }
    }


    /******************************Fumction for Add Filter********************/
    public void increaseCounter()
    {
        //Integer i=9;
        index=0;
        // filterListHandler.resetSelectedValue();
        counter.clear();
        bInternalVar=true;
        setiDefaultSize(iDefaultSize+1);
        iLastRow=iDefaultSize-1;
        system.debug('.......................'+counter.size());
    }


    /**************************Function for Remove filter*********************/



    public void removeCounter()
    {
        index=0;
        // filterListHandler.resetSelectedValue();
        counter.clear();
        bInternalVar=true;
        setiDefaultSize(iDefaultSize-1);
        iLastRow=iDefaultSize-1;
    }

    /*******************************Bewlow fumction is default input ofr 
    operator .User can override or add new values form their calling class****/

    public void setoperatorList()
    {
    filterListHandler.operatorList.add(new selectOption('-None-','-None-'));
    filterListHandler.operatorList.add(new selectOption('=','equals'));
    filterListHandler.operatorList.add(new selectOption('like','contains'));
    filterListHandler.operatorList.add(new selectOption(' >','greater than'));
    filterListHandler.operatorList.add(new selectOption(' <','less than'));
    filterListHandler.operatorList.add(new selectOption(' !=','Not Equals'));     
    }


  /******Below function is used to create query string from selcted values****/


    public void formQuery()
    {   
        formatInput();
        query='';   
        for(Integer i=0;i<filterListHandler.sSelectedFieldList.size();i++)
        {
            if(((filterListHandler.sSelectedFieldList[i]!='-None-')&&
            (filterListHandler.sSelectedOperatorList[i]!=' -None- ')) )
            {
                if ((filterListHandler.sSelectedFieldList[i]!='')&&
                (filterListHandler.sSelectedOperatorList[i]!=''))
                {
                    system.debug('..........hhhh..........'+
                    filterListHandler.sSelectedFieldList);                             
                    
                   
                    query+=' '+filterListHandler.sSelectedFieldList[i]+
                    filterListHandler.sSelectedOperatorList[i]+
                    filterListHandler.sSelectedTextValue[i]+' '+'AND'+' ';
                    
                } 
            }   

        }
        /********* resetting all selected values**************/
        
        filterListHandler.sSelectedTextValue.clear();
        filterListHandler.sSelectedOperatorList.clear();
        filterListHandler.sSelectedFieldList.clear();
        system.debug('......value....................'+ 
        filterListHandler.sSelectedTextValue+'............'+
        filterListHandler.sSelectedFieldList);   
    }


    public void oneLinkCounter()
    {
        if(sLinkName=='Fewer Filter <<<')
        {
            //iDefaultSize=4;
            if(iCheckVar==0)
            {            
                iCheckVar=iDefaultSize;
                system.debug('.....................'+iMinSize);               
            }
            iDefaultSize=iCheckVar+1;
            removeCounter();
            sLinkName='More Filter >>>';
        }
        else
        {
            //iDefaultSize=4;
            if(iCheckVar==0)
            {            
                iCheckVar=iDefaultSize;
                system.debug('.....................'+iMinSize);               
            }      
            iDefaultSize=6;
            
            increaseCounter();
            sLinkName='Fewer Filter <<<';      
        }    
    } 

}