import { LightningElement, track } from 'lwc';
import getFlightInformations from '@salesforce/apex/FlightController.getFlightInformations';

export default class FlightInformation extends LightningElement {
    @track error;
    @track informations = [];
    @track newFlight = false;


    connectedCallback() {
        this.getFlightInformations();
    }

    showNewFlight(){
        this.newFlight = true;
    }

    hideNewFlight(){
        this.newFlight = false;
        this.getFlightInformations();
    }

    getFlightInformations() {
        this.informations = [];
        getFlightInformations()
          .then(result => {
            this.informations = result;
          }).catch(error => {
            this.error = error;
          });
    }
}