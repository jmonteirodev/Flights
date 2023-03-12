/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-12-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class FlightController {
    public class CustomException extends Exception {}
    public static FlightController getInstance(){
        return new FlightController();
    }
    @AuraEnabled(cacheable=true)
    public static List<Airport__c> getAirportsOrderByIATACode(){
        try {
            return AirportSelector.getInstance().getAirportsOrderByIATACode();
        } catch (Exception e) {
            throw new CustomException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Flight__c> getFlightInformations(){
        try {
            return FlightSelector.getInstance().getFlightInformations();
        } catch (Exception e) {
            throw new CustomException(e.getMessage());
        }
    }

    /**
    This method creates a new Flight record based on the provided departure and arrival IATA codes.
    @param departureIATACode The IATA code of the departure airport.
    @param arrivalIATACode The IATA code of the arrival airport.
    @return The newly created Flight record.
    @throws CustomException if an error occurs during the flight creation process.
    */
    @AuraEnabled
    public static Flight__c createFlight(String departureIATACode, String arrivalIATACode) {
        List<Airport__c> departures = AirportSelector.getInstance().getAirportByIATACode(departureIATACode);
        List<Airport__c> arrivals = AirportSelector.getInstance().getAirportByIATACode(arrivalIATACode);

        if (departures.isEmpty() || arrivals.isEmpty()) {
            throw new CustomException('Airport not found.');
        }

        Flight__c flightValue = new Flight__c(
            DepartureAirport__c = departures[0].Id,
            ArrivalAirport__c = arrivals[0].Id,
            FlightDistance__c = FlightController.getInstance().calculateDistance(departures[0].Location__c.getLatitude(),departures[0].Location__c.getLongitude() , arrivals[0].Location__c.getLatitude() , arrivals[0].Location__c.getLongitude())
        );

        insert flightValue;
        return flightValue;
    }


    
    private Decimal calculateDistance(Decimal latitude1, Decimal longitude1, Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; // in meters
        // Transform coordinates from degrees to radians
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
        Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
        Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in metres
        return distance;
    }
}