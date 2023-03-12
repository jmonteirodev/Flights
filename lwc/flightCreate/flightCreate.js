import { LightningElement, wire, track } from 'lwc';
import getAirportsOrderByIATACode from '@salesforce/apex/FlightController.getAirportsOrderByIATACode';
import createFlight from '@salesforce/apex/FlightController.createFlight';

export default class FlightCreate extends LightningElement {

    departure = '';
    arrival = '';
    @track options = [];
    @track optionsArrival = [];

    chooseArrival(event) {
        this.arrival = event.detail.value;
    }

    chooseDeparture(event) {
        this.departure = event.detail.value;
        this.optionsArrival = this.options.filter(option => option.value !== this.departure);
    }

    save() {
        createFlight({ arrivalIATACode: this.arrival, departureIATACode: this.departure }).then(result => {
            const passEventr = new CustomEvent('flightcreated', {
                detail: { flight: result }
            });
            this.dispatchEvent(passEventr);
        }).error(error => {
            console.log(error);
        });
    }

    @wire(getAirportsOrderByIATACode) airportsOrderByIATACode({ data, error }) {
        if (data) {
            console.log(data);
            for (let info of data) {
                this.options.push({ label: info.Name, value: info.IATACode__c });
            }
            this.optionsArrival = this.options;
            console.log(this.options);
        } else if (error) {
            this.error = error.body;
        }
    };
}