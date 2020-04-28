import { LightningElement, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getTranslatedText from "@salesforce/apex/GoogleTranslateHelper.getTranslatedText";

export default class BasicDatatable extends LightningElement {
  text = "";

  @track translatedText = "";

  populateText(event) {
    this.text = event.detail.value;
  }

  translate() {
    if (this.text) {
      getTranslatedText({ texts: this.text })
        .then(result => {
          if (result.length !== 0) {
            let dataClone = JSON.parse(JSON.stringify(result));
            this.translatedText = dataClone;
          }
        })
        .catch(error => {
          console.error("error message: ", error);
          const event = new ShowToastEvent({
            title: "Error!",
            message:
              "Something went wrong and we could not translate the texts."
          });
          this.dispatchEvent(event);
        });
    }
  }
}
