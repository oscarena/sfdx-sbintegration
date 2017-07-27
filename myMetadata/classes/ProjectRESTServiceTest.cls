@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here

  	@isTest static void postProjectData_TEST(){

  		Opportunity oOpp = createOpportunity();
  		String msgResponse = '';

		RestRequest restReq = new RestRequest();
		RestContext.response = new RestResponse();

		//Test with an account that doesn't exist
		restReq.requestURI = '/project';
		//restReq.requestBody = Blob.valueOf('{"ProjectRef" : "P5", "ProjectName" : "P5",  "OpportunityId" : "0060Y000008voNZ", "StartDate" : "2017-06-01", "EndDate" : "2017-12-01", "Amount" : 15000, "Status" : "Running"}');
		RestContext.request = restReq;

		//No existe esa oportunidad
		msgResponse = ProjectRESTService.postProjectData('P5', 'P5', '0060Y000008voNZ', Date.valueOf('2017-06-01'),  Date.valueOf('2017-12-01'), double.valueof(15000), 'Running');
		System.assertEquals('NOT FOUND', msgResponse);

		//Existe oportunidad y no hay proyectos asociados
		msgResponse = ProjectRESTService.postProjectData('P1', 'P1', +oOpp.id, Date.valueOf('2017-06-01'),  Date.valueOf('2017-12-01'), double.valueof(15000), 'Running');
		System.assertEquals('OK', msgResponse);

		//Existe oportunidad y el proyecto asociado coincide
		Project__c oProject = createProject(oOpp);
		msgResponse = ProjectRESTService.postProjectData(oProject.ProjectRef__c, oProject.Name, +oOpp.id, Date.valueOf('2017-06-01'),  Date.valueOf('2017-12-01'), double.valueof(15000), 'Running');
		System.assertEquals('OK', msgResponse);

		//Existe oportunidad y ningun proyecto asociado coincide con la entrada
		msgResponse = ProjectRESTService.postProjectData('P2', 'P2', +oOpp.id, Date.valueOf('2017-06-01'),  Date.valueOf('2017-12-01'), double.valueof(15000), 'Running');
		System.assertEquals('OK', msgResponse);
		
  	}

  	private static Opportunity createOpportunity(){

  		Opportunity oOpp = new Opportunity();
  		oOpp.Name = 'TEST OPP';
  		oOpp.CloseDate = System.Today();
  		oOpp.StageName = 'Prospecting';

  		insert oOpp;
  		return oOpp;

  	}

  	private static Project__c createProject(Opportunity oOpp){

  		Project__c oProject = new Project__c();
  		oProject.opportunity__c = oOpp.Id;
  		oProject.Name = 'TEST PROJECT';
  		oProject.ProjectRef__c = 'REFERENCIA';
    	

  		insert oProject;
  		return oProject;
  	}







}