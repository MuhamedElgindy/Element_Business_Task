@isTest
public class ProjectHelperTest {
    @isTest
    static void testCalculateRemainingBudget() {
        // Create test Project record
        Project__c testProject = new Project__c(
            Project_Name__c = 'Test Project',
            Project_Budget__c = 10000
        );
        insert testProject;

        // Create related Expense records
        Expense__c expense1 = new Expense__c(
            Project__c = testProject.Id,
            Amount__c = 2000
        );
        Expense__c expense2 = new Expense__c(
            Project__c = testProject.Id,
            Amount__c = 1500
        );
        insert new List<Expense__c>{ expense1, expense2 };

        // Calculate expected remaining budget
        Decimal expectedRemainingBudget = 10000 - (2000 + 1500);

        // Call the method and assert the result
        Decimal actualRemainingBudget = ProjectHelper.calculateRemainingBudget(testProject.Id);
        System.assertEquals(expectedRemainingBudget, actualRemainingBudget, 'Remaining budget calculation is incorrect');
    }

    @isTest
    static void testCalculateRemainingBudgetWithNoExpenses() {
        Project__c testProject = new Project__c(
            Project_Name__c = 'No Expense Project',
            Project_Budget__c = 5000
        );
        insert testProject;

        Decimal actualRemainingBudget = ProjectHelper.calculateRemainingBudget(testProject.Id);
        System.assertEquals(5000, actualRemainingBudget, 'Remaining budget should equal the project budget when no expenses exist');
    }

    @isTest
    static void testInvalidProjectId() {
        try {
            ProjectHelper.calculateRemainingBudget('invalidId');
            System.assert(false, 'Expected an exception to be thrown for an invalid Project ID');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Unexpected exception message: ' + e.getMessage());
        }
    }
}