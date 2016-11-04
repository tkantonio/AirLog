//
//  AirLogVC.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 19/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit


class AirLogVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let detailsSegueIdentifier = "ShowDetailSegue"
    
    var dbRef: FIRDatabaseReference!
    var flights = [Flights]()
    var allFlightsInterval: NSTimeInterval = 0

    
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotalHours: UILabel!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       

        let flight = flights[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("flightCell") as? FlightCell{

            let currentFlightDuration = calculateDateDifference(flight.departureDateTime, date2: flight.arrivalDateTime)
            
            cell.configureCell("From: \(flight.from) - To: " + flight.to, subtext: "\(flight.date)   Duration: \(stringFromTimeInterval(currentFlightDuration))")

            allFlightsInterval = allFlightsInterval + currentFlightDuration
            
            lblTotalHours.text = "Total: " + (stringFromTimeInterval(allFlightsInterval) as String) as String
            
            return cell
        }else{
            return FlightCell()
        }
        
        

    }
    
    func calculateDateDifference(date1: NSDate, date2: NSDate) -> NSTimeInterval{
        //date difference
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let interval = date2.timeIntervalSinceDate(date1)
        
        return interval
    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
//        let ms = Int((interval % 1) * 1000)
//        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d hours %0.2d min",hours,minutes)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return flights.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        allFlightsInterval = 0
        lblTotalHours.text = "Total: 00 hours 00 min"
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                self.dbRef = FIRDatabase.database().reference().child("users").child(user.uid).child("Flights")
                print("Wzialem ref do \(self.dbRef)")
                self.startObservingDB()
                
            } else {
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        allFlightsInterval = 0
    }
    
    func startObservingDB(){
        dbRef.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            var newFlights = [Flights]()
            print("Skanuje po zmiany")
            for flight in snapshot.children {
                let flightObject = Flights(snapshot: flight as! FIRDataSnapshot)
                newFlights.append(flightObject)
            }
            
            self.flights = newFlights
            self.allFlightsInterval = 0
            self.lblTotalHours.text = "Total: 00 hours 00 min"
            self.tableView.reloadData()
            
            self.dbRef.keepSynced(true)

            
        }) { (error:NSError) in
            print(error.description)
        }
    }
    
    
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let flight = flights[indexPath.row]
            allFlightsInterval = 0
            lblTotalHours.text = "Total: 00 hours 00 min"
            flight.itemRef?.removeValue()
        }
        
    }
    
    @IBAction func goToMETAR(sender: AnyObject) {

        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterVC") as! RegisterVC
        self.presentViewController(vc, animated: true, completion: nil)

        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == detailsSegueIdentifier,
            let destination = segue.destinationViewController as? FlightDetailsVC,
            flightIndex = tableView.indexPathForSelectedRow?.row
        {
            
       //    destination.flightIndex = flightIndex
            destination.flight = flights[flightIndex]
          //  print(destination.flightIndex)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print(indexPath.row)
    }
    

}
