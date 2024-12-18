public with sharing class ProjectController {
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getActiveProjects() {
        return  
[
            SELECT Id, 	Project_Name__c, Start_Date__c, End_Date__c, Project_Budget__c,
                   (SELECT Amount__c FROM Expense__c)
            FROM Project__c
            WHERE Status__c = 'In Progress'
        ];
    }

    @AuraEnabled
    public static void updateProjectStatus(Id projectId) {
        Project__c project = [SELECT Id, Status__c FROM Project__c WHERE Id = :projectId LIMIT 1];
        project.Status__c = 'Completed';
        update project;
    }
}
