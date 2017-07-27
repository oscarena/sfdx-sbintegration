global with sharing class ProjectCalloutService {

	
	@InvocableMethod(label='postOpportunityToPMS' description='postOpportunityToPMS')
	
	public static void postOpportunityToPMS(List<Id> listIdOpp) {

		QueueablePMSCall qpc = new QueueablePMSCall(listIdOpp);
        System.enqueueJob(qpc);
	}

	public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{

		private List<Id> listIdOpp;
	        
	    public QueueablePMSCall(List<Id> listIdOpp){

	             this.listIdOpp = listIdOpp;
	    }


		public void execute(QueueableContext context) {


			HttpRequest req = new HttpRequest();
	        HTTPResponse res = new HttpResponse();
	        
			//TODO: update method return type and input parameters (they do need to be List)
			WOpp wOpp = new WOpp();
			System.debug('ProjectCalloutService.postOpportunityToPMS');

			try {

				List<Opportunity> listOpp = [SELECT id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHere Id IN : ListIdOpp ];

				System.debug('ProjectCalloutService.postOpportunityToPMS :: listOpp' +listOpp);

				wOpp.opportunityId = listOpp.get(0).id;
				wOpp.opportunityName = listOpp.get(0).Name;
				wOpp.accountName = listOpp.get(0).Account.Name;
				wOpp.closeDate = String.valueof(listOpp.get(0).CloseDate);
				wOpp.amount = listOpp.get(0).Amount;


				Http http = new Http();

				req.setEndpoint('callout:ProjectService');
	            req.setMethod('POST');
	            req.setBody(JSON.serialize(wOpp));
	            req.setHeader('Content-Type', 'Application/JSON');

	            ServiceTokens__c csServiceTokens = ServiceTokens__c.getValues('ProjectServiceToken');
				String sToken = csServiceTokens.Token__c;
				req.setHeader('token', sToken);

	            System.debug('ProjectCalloutService.postOpportunityToPMS :: req ' +req);

	            //Execute web service call here
	            if (Test.isRunningTest()){

	            	Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock(200, 'OK', 'BODY', new Map<String,String>() ) );

	            } 
				res = http.send(req);

		        System.debug('ProjectCalloutService.postOpportunityToPMS :: RESPONSE ' +res.toString());
	            System.debug('ProjectCalloutService.postOpportunityToPMS :: STATUS: '+res.getStatus());
	            System.debug('ProjectCalloutService.postOpportunityToPMS :: STATUS_CODE: '+res.getStatusCode());
	            System.debug('ProjectCalloutService.postOpportunityToPMS :: RESPONSE_BODY ' +res.getBody());
	            System.debug('ProjectCalloutService.postOpportunityToPMS :: RESPONSE_HEADER ' +res.getHeaderKeys());
				


			} catch (Exception e){

				System.debug('ProjectCalloutService.postOpportunityToPMS :: UNHANDLED EXCEPTION ' +e.getMessage());

			}



        }

    }

	global class WOpp{

		public string opportunityId;
		public string opportunityName;
		public string accountName;
		public string closeDate;
		public Decimal amount;

	}


}