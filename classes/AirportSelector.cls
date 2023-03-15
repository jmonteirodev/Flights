public with sharing class AirportSelector {
    public static AirportSelector getInstance(){
        return new AirportSelector();
    }

    public List<Airport__c> getAirportByIATACode(String IATACode){
        return [SELECT Id, IATACode__c, Location__c  FROM Airport__c WHERE IATACode__c =: IATACode];
    }

    public List<Airport__c> getAirportsOrderByIATACode(){
        return [SELECT Id, Name, IATACode__c FROM Airport__c ORDER BY IATACode__c];
    }
}