@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here

  @isTest static void testCallout(){

  	Opportunity oOpp = createDataTest();

  	System.debug('ProjectCalloutServiceTest.testCallout :: oOpp ' + oOpp);

  	oOpp.type = 'New Project';
  	oOpp.StageName = 'Closed Won';
  	
  	System.debug('ProjectCalloutServiceTest.testCallout :: oOpp ' + oOpp);

  	//test.startTest();
    update oOpp;
    //test.stopTest();

    

  }

  private static Opportunity createDataTest(){
  	
  	ServiceTokens__c csServiceTokens = new ServiceTokens__c(Name='ProjectServiceToken', Token__c = '123456789');
  	insert csServiceTokens;

  	Account oAcc = new Account (Name = 'TEST');
  	insert oAcc;

  	System.debug('ACCOUNT' +oAcc);

  	Opportunity oOpp = new Opportunity();	
  	oOpp.Name = 'OPP TEST';
  	oOpp.Amount = 1500;
  	oOpp.AccountId = oAcc.id;
  	oOpp.StageName = 'Prospecting';
  	oOpp.type = 'New Project';
  	oOpp.CloseDate = System.today();

  	insert oOpp;

  	return oOpp;

  }



}