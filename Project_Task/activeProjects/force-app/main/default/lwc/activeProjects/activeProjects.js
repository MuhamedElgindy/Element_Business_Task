import { LightningElement, wire } from 'lwc';
import getActiveProjects from '@salesforce/apex/ProjectController.getActiveProjects';
import updateProjectStatus from '@salesforce/apex/ProjectController.updateProjectStatus';
import { refreshApex } from '@salesforce/apex';

export default class ActiveProjects extends LightningElement {
    projects; // Holds the list of projects
    wiredProjects; // Cache for the wired data

    // Fetch active projects using the Apex method
    @wire(getActiveProjects)
    wiredProjectsHandler(response) {
        this.wiredProjects = response;
        const { data, error } = response;
        if (data) {
            this.projects = data.map(project => ({
                ...project,
                RemainingBudget: project.Project_Budget__c - project.Expense__c.reduce((sum, expense) => sum + expense.Amount__c, 0)
            }));
        } else if (error) {
            console.error(error);
        }
    }

    // Mark a project as completed
    markAsCompleted(event) {
        const projectId = event.target.dataset.id;
        updateProjectStatus({ projectId })
            .then(() => refreshApex(this.wiredProjects))
            .catch(error => console.error(error));
    }
}
