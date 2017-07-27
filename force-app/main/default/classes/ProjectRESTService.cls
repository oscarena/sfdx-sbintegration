@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService  {

    @httpPost
    global static string postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){

    	// NO ASUSTARSE POR VER ESA MIERDA DE RESPONSE
    	// EL TRAILHEAD NO ACEPTABA RestContext


    	List<Opportunity> listOpportunity = [SELECT id, Name, DeliveryInstallationStatus__c, 
    												(SELECT id, ProjectRef__c, Name, Opportunity__c, Start_date__c, End_Date__c, Billable_Amount__c, Status__c, Opportunity__r.DeliveryInstallationStatus__c 
    												FROM Projects__r )
    										FROM Opportunity
    										WHERE Id =: opportunityId];
		
		List<Opportunity> listOpportunityToUpdate = new List<Opportunity>();
		List<Project__c> listProjectToUpdate = new List<Project__c>();
		String msgResponse = '';

    	Savepoint sp = Database.setSavepoint();

    	System.debug('ProjectRESTService.postProjectData :: listOpportunity ' +listOpportunity);

    	try {

    		if (!listOpportunity.isEmpty()){

    			if (!listOpportunity.get(0).projects__r.isEmpty()){

    				System.debug ('OPP NO VACIA PR NO VACIA');
					System.debug('ProjectRESTService.postProjectData :: listOpportunity.get(0).projects__r ' +listOpportunity.get(0).projects__r);

					Boolean existeProyecto = false;

					for (Project__c inProject : listOpportunity.get(0).projects__r){

						if (inProject.ProjectRef__c.equals(projectRef)) {

							existeProyecto = true;

							System.debug('ProjectRESTService.postProjectData :: inProject ' +inProject);
							System.debug('ProjectRESTService.postProjectData :: inProject.Opportunity__r ' +inProject.Opportunity__r);

							//listOpportunity.get(0).Projects__r.get(0).ProjectRef__c = projectRef;
							inProject.Name = projectName;
							inProject.Start_date__c =startDate;
							inProject.End_Date__c = endDate;
							inProject.Billable_Amount__c = amount;
							inProject.Status__c = status;
							inProject.Opportunity__r.DeliveryInstallationStatus__c = 'In progress';

							listProjectToUpdate.add(inProject);
							listOpportunityToUpdate.add(inProject.Opportunity__r);
						}
					}

					if (existeProyecto){

						System.debug('ProjectRESTService.postProjectData :: listProjectToUpdate ' +listProjectToUpdate);
						System.debug('ProjectRESTService.postProjectData :: listOpportunityToUpdate ' +listOpportunityToUpdate);

						update listProjectToUpdate;
						update listOpportunityToUpdate;
						//RestContext.response.statuscode = 200;
			    		//RestContext.response.responseBody = Blob.valueof('OK');
			    		msgResponse = 'OK';


					} else {

						System.debug('NO EXISTE PTOYECTO');
						insertAndUpdateProject(ProjectRef, ProjectName, OpportunityId, StartDate, EndDate, Amount, Status);

	    				//RestContext.response.statuscode = 200;
	    				//RestContext.response.responseBody = Blob.valueof('OK');
	    				msgResponse = 'OK';
					}


				} else {

					insertAndUpdateProject(ProjectRef, ProjectName, OpportunityId, StartDate, EndDate, Amount, Status);
	    			//RestContext.response.statuscode = 200;
	    			//RestContext.response.responseBody = Blob.valueof('OK');
	    			msgResponse = 'OK';

				}

    		} else {

    			//RestContext.response.statuscode = 404;
	    		//RestContext.response.responseBody = Blob.valueof('NOT FOUND');
	    		msgResponse = 'NOT FOUND';

    		}

    	} catch (Exception e){

    		System.debug('ProjectRESTService.postProjectData :: UNHANDLED EXCEPTION ' +e);
    		//RestContext.response.statuscode = 500;
    		Database.rollback(sp);
    		return e.getMessage();

    	}
    	return msgResponse;

    }

    private static void insertAndUpdateProject(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){
    	
    	Project__c oProject = new Project__c();

    	oProject.ProjectRef__c = projectRef;
    	oProject.Name = projectName;
    	oProject.Opportunity__c = opportunityId;
    	oProject.Start_date__c = startDate;
    	oProject.End_Date__c = endDate;
    	oProject.Billable_Amount__c = amount;
    	oProject.Status__c = status;
    	
    	insert oProject;
		System.debug('ProjectRESTService.insertAndUpdateProject :: oProject after insert ' +oProject);

		List<Opportunity> listOpportunityToUpdate = [SELECT id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =: opportunityId];

		listOpportunityToUpdate.get(0).DeliveryInstallationStatus__c = 'In progress';

		System.debug('ProjectRESTService.insertAndUpdateProject :: listOpportunityToUpdate ' +listOpportunityToUpdate);

		update listOpportunityToUpdate;

    }



}