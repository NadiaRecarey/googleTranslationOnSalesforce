/*
 * Google Translate Helper Class
 *
 * @author Nadia Recarey <nadia.recarey@modelit.xyz>
 * @since  April 2020
 */

public with sharing class GoogleTranslateHelper {

	/**
	 * In this case, I have in my org a Hierarchy Custom Setting
	 * "Translate_Settings__c" with a field "API_Key__c" where I
	 * store my google translate API Key.
	 */
	private static Translate_Settings__c settings;

	static {
		settings = Translate_Settings__c.getInstance();
	}

	/**
	 * The response of the google translate API 
	 * should be something like this:
	 * 
	 *  {
	 *		"data": {
	 *			"translations": [
	 *			{
	 *				"translatedText": "Hallo Welt",
	 *				"detectedSourceLanguage": "en"
	 *			},
	 *			{
	 *				"translatedText": "Mein Name ist Jeff",
	 *				"detectedSourceLanguage": "en"
	 *			}
	 *			]
	 *		}
	 *	}
	 */
	@auraEnabled
	public static List<String> getTranslatedText(List<String> texts) {

		List<String> translatedTexts = new List<String>();

		HTTPResponse resp = googleTranslateCallout(texts);

		if (resp != null) {
			String jsonResults = '';

			jsonResults = resp.getBody();

			JSONParser parser = JSON.createParser(jsonResults);


			while (parser.nextToken() != null) {
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) 
				&& (parser.getText() == 'translatedText')) {
					parser.nextToken();
					translatedTexts.add(parser.getText());
				}
			}
		}

		return translatedTexts;
	}

	public static HTTPResponse googleTranslateCallout(List<String> texts) {
		HTTPResponse resp = null;

		String urlText = '';

		for (String text : texts) {
			urlText += '&q=' + text;
		}

		urlText = urlText.replace(' ', '%20');

		if (urlText != '' && (settings.API_Key__c != null 
		  || settings.API_Key__c != '')) {

			HttpRequest req = new HttpRequest();
			Http http = new Http();

			string url = 'https://www.googleapis.com/language/translate/v2?key='
					+ settings.API_Key__c
					+ '&target=es&source=en&format=text' + urlText;

			req.setMethod('GET');
			req.setEndPoint(url);

			resp = http.send(req);

		} else if (settings.API_Key__c == null 
		  || settings.API_Key__c == '') {
			System.debug(LoggingLevel.WARN, 'The Google Translate API Key value is empty');
		} else if (urlText == '') {
			System.debug(LoggingLevel.WARN, 'The text intended to translate is empty');
		}

		return resp;
	}
}