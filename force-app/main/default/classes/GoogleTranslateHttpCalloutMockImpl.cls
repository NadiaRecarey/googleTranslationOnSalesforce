/* 
 * Specifying a Mock Response for test Google Translate API Service Callouts 
 *
 * @author Nadia Recarey - nadia.recarey@modelit.xyz
 * @since January 2020
 */

@isTest
global with sharing class GoogleTranslateHttpCalloutMockImpl implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {
        // Create a fake response .
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"OK","translations":[{"translatedText":"Esto es una prueba"}]}');
        res.setStatusCode(200);

        return res;
    }
}