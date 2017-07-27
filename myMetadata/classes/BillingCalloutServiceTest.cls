@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here

  @isTest static void testBillingCallout(){
  	//Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

  	ServiceCredentials__c credentials = new ServiceCredentials__c(Name='BillingServiceCredential', Username__c = 'username', Password__c = 'password');
  	insert credentials;

  	Opportunity oOpp = new Opportunity();	
  	oOpp.Name = 'OPP TEST';
  	oOpp.Amount = 1500;
  	//oOpp.AccountId = oAcc.id;
  	oOpp.StageName = 'Prospecting';
  	oOpp.type = 'New Project';
  	oOpp.CloseDate = System.today();

  	insert oOpp;


  	Project__c oProject = new Project__c();

  	oProject.ProjectRef__c = 'REFERENCIA';
    oProject.Name = 'TEST PROJECT';
    oProject.Opportunity__c = oOpp.id;
    oProject.Start_date__c = System.today();
    oProject.End_Date__c = System.today()+1;
    oProject.Billable_Amount__c = 15000;
    oProject.Status__c = 'Running';

    insert oProject;

    oProject.Status__c = 'Billable';

    Test.startTest();
    update oProject;
    System.debug('BillingCalloutServiceTest.testBillingCallout :: oProject ' +oProject);
    Test.stopTest();

    Project__c op2 = [SELECT Status__c FROM Project__c WHERE id =: oProject.id];

    System.assertEquals('Billed', op2.Status__c);




  }




  
}