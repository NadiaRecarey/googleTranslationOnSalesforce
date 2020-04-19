/*
 * Google Translate Helper Class
 *
 * @author Nadia Recarey <nadia.recarey@modelit.xyz>
 * @since  January 2020
 */

public with sharing class GoogleTranslateHelper {

	private static Custom_Settings__c settings;

	static {
		settings = Custom_Settings__c.getInstance();
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

		return translatedComments;
	}

	public static HTTPResponse googleTranslateCallout(List<String> texts) {
		HTTPResponse resp = null;

		String urlText = '';

		for (String text : texts) {
			text += '&q=' + text;
		}

		text = text.replace(' ', '%20');

		if (text != '' && (settings.Google_Translate_API_Key__c != null 
		  || settings.Google_Translate_API_Key__c != '')) {

			HttpRequest req = new HttpRequest();
			Http http = new Http();

			string url = 'https://www.googleapis.com/language/translate/v2?key='
					+ settings.Google_Translate_API_Key__c
					+ '&target=es&source=en&format=text' + urlText;

			req.setMethod('GET');
			req.setEndPoint(url);

			resp = http.send(req);

		} else if (settings.Google_Translate_API_Key__c == null 
		  || settings.Google_Translate_API_Key__c == '') {
			System.debug(LoggingLevel.WARN, 'The Google Translate API Key value is empty');
		} else if (text == '') {
			System.debug(LoggingLevel.WARN, 'The text intended to translate is empty');
		}

		return resp;
	}
}