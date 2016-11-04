//
//  FlightDetailsVC.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 06/10/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FlightDetailsVC: UIViewController {

    var dbRef: FIRDatabaseReference!
    var flight: Flights!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFROM: UILabel!
    @IBOutlet weak var lblTO: UILabel!
    @IBOutlet weak var lblDepTime: UILabel!
    @IBOutlet weak var lblArrTime: UILabel!
    @IBOutlet weak var lblAircraftType: UILabel!
    @IBOutlet weak var lblAircraftReg: UILabel!
    
    var flightIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.lblFROM.text = flight.from
        self.lblTO.text = flight.to
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeZone = NSTimeZone(name: "UTC")
        timeFormatter.dateFormat = "HH:mm"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.lblDate.text = dateFormatter.stringFromDate(flight.departureDateTime)
        self.lblDepTime.text = timeFormatter.stringFromDate(flight.departureDateTime)
        self.lblArrTime.text = timeFormatter.stringFromDate(flight.arrivalDateTime)
        self.lblAircraftType.text = flight.aircraftType
        self.lblAircraftReg.text = flight.aircraftRegistration
    }




}
