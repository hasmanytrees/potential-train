/******************************************************************************
    Name             : RoomWrapper
    Description      : It is  wrapper class to show all available venue room 
                       with a check box 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring &
                                         optimization
*******************************************************************************/

public with Sharing class RoomWrapper
{
  public Venue__c oRoom{get;set;}   //Venue instance
  public boolean bSelected{get;set;} //Venue instance
  public boolean bSaved{get;set;}  //boolean variable to show checkbox
  
  //Basic constructor   
  public RoomWrapper(Venue__c oVenue)
   {
      oRoom=new Venue__c ();
      oRoom= oVenue;
      bSelected=false;
      bSaved=false;
   }
 
 }