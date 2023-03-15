public with sharing class FlightSelector {
    public static FlightSelector getInstance(){
        return new FlightSelector();
    }

    public List<Flight__c> getFlightInformations(){
        return [SELECT Id,ArrivalAirport__r.IATACode__c, DepartureAirport__r.IATACode__c, FlightDistance__c FROM Flight__c];
    }
}