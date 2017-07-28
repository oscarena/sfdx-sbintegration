# SFDX  Superbadge Integration Specialist

## Dev, Build and Test

Esto es un proyecto SFDX es necesario convertirlo a metadataApi para poder desplegarlo en una org Developer

Para poder desbloquear el acceso a esta superbadge de integración necesitarás haber completado previamente y por tu cuenta los trailheads:

Apex Integration Services: https://trailhead.salesforce.com/en/modules/apex_integration_services
Asyncronous Apex: https://trailhead.salesforce.com/en/modules/asynchronous_apex
Api Basics: https://trailhead.salesforce.com/en/modules/api_basics
Process Automation: https://trailhead.salesforce.com/en/modules/business_process_automation


Para poder completar los challenges de la superbadge se recomienda crear una nueva org developer vacia para que no existan conflictos con otros trailheads. Las cuentas developer adicionales se pueden asociar a tu cuenta developer original donde tienes todas las chapas y poder ir sumando todas.

----

Una vez desplegado el proyecto deberas seguir estos puntos de la superbadge ya que las connected apps y el contenido de los custom settings no se desplega:

### Create Custom Settings and Connected App

In addition, the billing service is secured with user and password credentials. Store them as a ServiceCredentials Custom Setting (named BillingServiceCredential), and pass to the outbound call:

Username	"bsUser1".

Password	"bsPass1".

*Note: While it is best practice to encrypt credentials, for the purpose of this superbadge store them in clear text. *

The external PMS service calls your org’s custom Apex REST service back; configure it as a Connected App with the following information:

Connected App Name	"ProjectService".

API Name	"ProjectService".

Contact email	"Your email".

Enable OAuth Settings	Checked.

Callback URL	"https://sb-integration-pms.herokuapp.com/oauth/_callback".

Selected OAuth Scopes	Full access & Perform requests on your behalf at any time (refresh_token, offline_access).
Register the generated Consumer Key and Consumer Secret with the Square Peg security whitelisting process.

### Configure Org Registration

You will use a custom Heroku app to register your org by clicking this link: https://sb-integration-pms.herokuapp.com. This app registers your username with the Connected App’s consumer key and consumer secret in the Square Peg registry. This process returns a security token to store in your org as a ServiceTokens Custom Setting record (named ProjectServiceToken). Pass the token with any outbound call to the PMS RESTful web service as part of the header (with key named token). Follow the instructions on the registration app, and remember to test your connection. (Note: When you begin testing, bear in mind that it can take some time for your Connected App to propagate.)


## Resources


## Description of Files and Directories


## Issues


