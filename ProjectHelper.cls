/*
 * 1- Create a class named ProjectHelper.
 * 2- Create method calculateRemainingBudget(String projectId)
 * 		•	Accepts the Project record ID as a parameter.
 * 		•	Get Data From Projec__c object
 * 		•	Sum Amount__c from Expense__c object where Project__c = project id
 * 		•	Check expeneseSum is not empty to get total expense
*/
public class ProjectHelper {
    // Create CalcRemBudget Method
    public static Decimal calculateRemainingBudget(String projectId){
        // Get Project Record by Project__c Custom Object
        Project__c pr = [select Id, Project_Budget__c from Project__c where Id = :projectId];
        AggregateResult[] expenseSum = [select SUM(Amount__c) totalExpense from Expense__c where Project__c = :projectId];
        Decimal totalExpense = 0;

        // Check if the query result is not empty and has a valid value
        if (!expenseSum.isEmpty()) {
            Object totalExpenseObj = expenseSum[0].get('totalExpense');
            if (totalExpenseObj != null) {
                totalExpense = (Decimal) totalExpenseObj;
            }
        }
       return pr.Project_Budget__c - totalExpense;          
    }
}