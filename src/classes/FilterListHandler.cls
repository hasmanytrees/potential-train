/*****************************************************************************************
    Name             : FilterListHandler
    Description      :It is the main master class for storing details for filter input in InputFieldList_Example class
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/

public with Sharing class FilterListHandler
 {
 
  
   public List<selectOption> fieldList{get;set;}      //It contains all the field list to show on filter
   public List<selectOption> operatorList{get;set;}   //It contains all the Operator list to show on filter
   public Map<String,String> valueTypeMap{get;set;}   //It contains the mapping of field whether auto quote needs to be added example valueTypeMap.put('Gender','Quote Need')
   public List<String> sSelectedFieldList{get;set;}    // It contains all selected field input
   public List<String> sSelectedOperatorList{get;set;}  // It contains all selected operator input
   public  List<String> sSelectedTextValue{get;set;}    // It contains all text input
   public String sKeyWordSearch{get;set;}               //this field is for text field search
   public Integer iMaxResultSize{get;set;}             //It is for search limit
   public FilterListCompController compControllerRef{get;set;}
  
  
  /**************************************Constructor of the class*****************************************/ 
    public FilterListHandler()
     {
        sSelectedFieldList=new List<String>();
        sSelectedOperatorList=new List<String>();
        sSelectedTextValue=new List<String>();
        fieldList=new List<selectOption>();
        operatorList=new List<selectOption>();
        valueTypeMap=new Map<String,String>();
        iMaxResultSize=0;
       
     }
     
     
 /***************************************Below function is used to clear all list with previous value*****************************/    
   public void resetSelectedValue()
    {
    
       sSelectedFieldList.clear();
       sSelectedOperatorList.clear();
       sSelectedTextValue.clear();
    
    
    
    }  
     
     
     
 
 }