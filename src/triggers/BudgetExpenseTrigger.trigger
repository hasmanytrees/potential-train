/*****************************************************************************************
    Name             : BudgetExpenseTrigger 
    Description      : Main Budget/Expense Trigger to handle any changes and new 
                       Budget and Expense Rollup to Campaign/Event level.               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet Kanjilal            1/26/2015          Created
Subhojit Chakraborty   4/2/2015           Modified for code re-factoring & optimization
******************************************************************************************/
trigger BudgetExpenseTrigger on BudgetExpense__c(after insert,after update,after delete) 
{
    if(Trigger.isAfter)
    {
        if(Trigger.isDelete)
        {
            if(Trigger_Methods_Activation__c.getInstance('performPostDeleteOperations').Is_Trigger_Method_Required_In_Delete__c)
            {
                //Perform Post Delete Operations and gets old Budget/Expense Record
                //map after Budget/Expense Record is deleted.
                BudgetExpenseTriggerHandler.performPostDeleteOperations(Trigger.oldMap);
            }
        }
        else
        {    //Handles Insert and Update scenarios for Budget/Expense and rolls up to Campaign/Event level.
            if(Trigger_Methods_Activation__c.getInstance('performBudgetExpenseRollUp').Is_Trigger_Method_Required_In_Insert__c 
            || Trigger_Methods_Activation__c.getInstance('performBudgetExpenseRollUp').Is_Trigger_Method_Required_In_Update__c)
            {
                //Perform Budget Expense Rollup if an insertion or update operation takes place.
                BudgetExpenseTriggerHandler.performBudgetExpenseRollUp(Trigger.NewMap);
            }
        }
    }
}