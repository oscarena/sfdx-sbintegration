public class BillingCalloutService {
    //Implement business and callout logic methods here
    public static void callBillingService(List<Project__c> newList, Map<Id, Project__c> newMap,
            List<Project__c> oldList, Map<Id, Project__c> oldMap) {

        if(!newList.isEmpty()) {
            Project__c project = newList[0];
            System.debug('BillingCalloutService.callBillingService :: project ' +project);

            if (project.Status__c == 'Billable' && oldMap.get(project.Id).Status__c != 'Billable') {
                // Get Service Credentials from custom settings
                ServiceCredentials__c credentials = ServiceCredentials__c.getInstance('BillingServiceCredential');
                billProject(project.ProjectRef__c, project.Billable_Amount__c, credentials.Username__c, credentials.Password__c);
            }
        }
    }

    @Future(callout=true)
    private static void billProject(String projectRef, Decimal billAmount, String username, String password) {

        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.projectRef = projectRef;
        project.billAmount = billAmount;
        project.username = username;
        project.password = password;

        BillingServiceProxy.InvoicesPortSoap11 invoiceCall = new BillingServiceProxy.InvoicesPortSoap11();
        // Make the callout and update the Status if callout is successful
        
        String response = '';
        
        response = invoiceCall.billProject(project); 
        System.debug('BillingCalloutService.billProject :: response ' +response);       
                
        if(response != null && response.equalsIgnoreCase('OK')) {

        	List<Project__c> listProjects = [Select Id, Status__c
            	        					From Project__c
                	    					Where ProjectRef__c = :projectRef
            								];
			System.debug('BillingCalloutService.billProject :: listProjects ' +listProjects);            								
            
            if(!listProjects.isEmpty()) {
                listProjects.get(0).Status__c = 'Billed';
                update listProjects;
            }
            System.debug('BillingCalloutService.billProject :: listProjects ' +listProjects);
        }

    }
}