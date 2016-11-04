//
//  Flights.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 31/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Flights {
    
    var Flight: [String:AnyObject] = [:]
    var key: String!
    var date: String!
//    var aircraftModel: String
//    var aircraftIdent: String
    var from: String!
    var to: String!
    var aircraftType: String!
    var aircraftRegistration: String!
    var Captain: String!
    var holdersOperatingCapacity: String!
    var departureTime: NSDate!
    var departureDate: NSDate!
    var departureDateTime : NSDate!
    var arrivalDate: NSDate!
    var arrivalTime: NSDate!
    var arrivalDateTime : NSDate!
    
//    var remarks: String
//    var noOfInstrApp: Int?
//    var noOfLandings: Int
//    var timeInSEL: NSTimeInterval?
//    var timeInMEL: NSTimeInterval?
//    var startUpTime: NSTimeInterval
//    var shutDownTime: NSTimeInterval
//    var hoursDay: NSTimeInterval?
//    var hoursNight: NSTimeInterval?
//    var hoursInstrumental: NSTimeInterval?
//    var hoursPIC: NSTimeInterval?
//    var hoursDual: NSTimeInterval?
//    var totalDurationOfFlight: NSTimeInterval
    var itemRef: FIRDatabaseReference?
    
    init(date: String, from: String, to: String, departureTime: NSDate, arrivalTime: NSDate){

        self.date = date
        self.from = from
        self.to = to
        self.Flight = ["Date":date, "From":from,"To":to]
        self.itemRef = nil
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
    }
    
    init(){
        
    }
    
    
    
    func saveNewFlight(date: String, from: String, to: String, userID: String, departureTime: NSDate, arrivalTime: NSDate, aircraftType: String, aircraftRegistration: String, key: String = ""){
        //Save user's profile
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
      //  dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        let convertedDepartureDate = dateFormatter.stringFromDate(departureTime)
        let convertedArrivalDate = dateFormatter.stringFromDate(arrivalTime)

        dateFormatter.dateFormat = "HH:mm"
        let convertedDepartureTime = dateFormatter.stringFromDate(departureTime)
        let convertedArrivalTime = dateFormatter.stringFromDate(arrivalTime)
                let ref = FIRDatabase.database().reference()
                let Flight: [String:AnyObject] = ["Date": date,
                                               "From": from,
                                               "To": to,
                                               "DepartureDate": convertedDepartureDate,
                                               "DepartureTime": convertedDepartureTime,
                                               "ArrivalDate": convertedArrivalDate,
                                               "ArrivalTime": convertedArrivalTime,
                                               "AircraftType": aircraftType,
                                               "AircraftRegistration": aircraftRegistration]
                ref.child("users").child(userID).child("Flights").childByAutoId().setValue(Flight)
    }
    
    init(snapshot: FIRDataSnapshot){
        self.key = snapshot.key
        self.itemRef = snapshot.ref
        
        if let flightDate = snapshot.value!["Date"] as? String{
            date = flightDate
        }else{
            date = ""
        }
        
        if let flightFrom = snapshot.value!["From"] as? String{
            from = flightFrom
        }else{
            from = ""
        }
        
        if let flightTo = snapshot.value!["To"] as? String{
            to = flightTo
        }else{
            to = ""
        }
        
        if let flightDepartureDate = snapshot.value!["DepartureDate"] as? String{
            let dateFormatter = NSDateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
            let convertedDate = dateFormatter.dateFromString(flightDepartureDate)
            departureDate = convertedDate
        }else{
            departureDate = nil
        }
        
        if let flightDepartureTime = snapshot.value!["DepartureTime"] as? String{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
            let convertedDate = dateFormatter.dateFromString(flightDepartureTime)
            
            departureTime = convertedDate
        }else{
            departureTime = nil
        }
        
        
        
        if let flightArrivalDate = snapshot.value!["ArrivalDate"] as? NSDate{
            arrivalDate = flightArrivalDate
        }else{
            arrivalDate = nil
        }
        if let flightArrivalTime = snapshot.value!["ArrivalTime"] as? NSDate{
            arrivalTime = flightArrivalTime
        }else{
            arrivalTime = nil
        }
        
        
        if let flightDepartureTime = snapshot.value!["DepartureTime"] as? String, let flightDepartureDate = snapshot.value!["DepartureDate"] as? String{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
            let convertedDate = dateFormatter.dateFromString("\(flightDepartureDate) \(flightDepartureTime)")
            
            departureDateTime = convertedDate
        }else{
            departureDateTime = nil
        }
        
        if let flightArrivalTime = snapshot.value!["ArrivalTime"] as? String, let flightArrivalDate = snapshot.value!["ArrivalDate"] as? String{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
            let convertedDate = dateFormatter.dateFromString("\(flightArrivalDate) \(flightArrivalTime)")
            
            arrivalDateTime = convertedDate
        }else{
            arrivalDateTime = nil
        }
        
        if let flightAircraftType = snapshot.value!["AircraftType"] as? String{
            aircraftType = flightAircraftType
        }else{
            aircraftType = nil
        }
        if let flightAircraftRegistration = snapshot.value!["AircraftRegistration"] as? String{
            aircraftRegistration = flightAircraftRegistration
        }else{
            aircraftRegistration = nil
        }
        
    }
    
    func toAnyObject() -> AnyObject{
        return ["Date": date, "From": from, "To": to, "DepartureTime": departureTime, "DepartureTime": departureTime, "ArrivalDate": arrivalDate, "ArrivalTime": arrivalTime, "AricraftType": aircraftType, "AircraftRegistration": aircraftRegistration]
    }
    
    
    
}
