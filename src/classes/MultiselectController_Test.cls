/*****************************************************************************************
    Name             : MultiselectController_Test
    Description      : This REST webservice is used to Call to query all Account and related Contact for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                  30/10/2014            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class MultiselectController_Test{

    public static testMethod void testAllMethods()
    {
        MultiselectController ref = new MultiselectController();
        ref.leftOptionsHidden = 'Found Left';
        ref.rightOptionsHidden = 'Found Right';
        
        ref = new MultiselectController();
        List<SelectOption> selOpts =  new  List<SelectOption>();
        selOpts.add(new selectOption('123','123')); 
       
        ref.lstLeftOptions = selOpts;
        ref.leftOptionsHidden = 'Found Left&Found Left 1';
        ref.rightOptionsHidden = 'Found Right&Found Right 1';
    }

}