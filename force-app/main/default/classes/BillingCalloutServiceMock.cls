@isTest
global class BillingCalloutServiceMock implements WebServiceMock {
	//Implement http mock callout here
   
   public static void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        // Create response element from the autogenerated class.
        // Populate response element.
        // Add response element to the response parameter, as follows:
        BillingServiceProxy.billProjectResponse_element responseElement = new BillingServiceProxy.billProjectResponse_element();
        responseElement.status = 'OK';

        response.put('response_x', responseElement); 
   }
}