String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
String compositeGraphUrl = baseURL + '/services/data/v50.0/composite/graph/';

HttpRequest request = new HttpRequest();
request.setMethod('POST');
request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
request.setHeader('Content-Type', 'application/json');

StaticResource resource = [SELECT Id, Body 
                            FROM StaticResource 
                            WHERE Name = 'graphs' 
                            LIMIT 1];

String body = resource.Body.toString();
request.setBody(body);
request.setEndpoint(compositeGraphUrl);
String prettyResponse = '';

try {
    Http http = new Http();
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
        prettyResponse = JSON.serializePretty(JSON.deserializeUntyped(response.getBody()));
    } else {
        System.debug( ' response ' + response.getBody() );
        throw new CalloutException( response.getBody() );
    }
} catch (Exception e) {
    System.debug('ERROR:' + e);
    throw e;
}

System.debug('Response: ' + prettyResponse);