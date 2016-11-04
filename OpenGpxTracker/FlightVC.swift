//
//  FlightVC.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 31/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit
import FirebaseAuth


class FlightVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var arrivalDate: UITextField!
    @IBOutlet weak var fromTxt: UITextField!
    @IBOutlet weak var toTxt: UITextField!
    @IBOutlet weak var txtAircraftType: UITextField!
    @IBOutlet weak var txtAircraftReg: UITextField!
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { 
            
        })
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 4
    }

    @IBAction func touchInsideArrivalDate(sender: UITextField) {
        let datePickerViewArrival:UIDatePicker = UIDatePicker()
        datePickerViewArrival.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        datePickerViewArrival.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerViewArrival
        datePickerViewArrival.addTarget(self, action: #selector(FlightVC.datePickerValueChangedArrival), forControlEvents: UIControlEvents.ValueChanged)
        if arrivalDate.text == ""{
        datePickerValueChangedArrival(datePickerViewArrival)
        }
    }
    
    @IBAction func touchInsideDateTxt(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(FlightVC.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    if dateTxt.text == ""
        {
        datePickerValueChanged(datePickerView)
        }
}
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateTxt.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func datePickerValueChangedArrival(sender:UIDatePicker) {
        let dateFormatterArrival = NSDateFormatter()
        dateFormatterArrival.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatterArrival.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        arrivalDate.text = dateFormatterArrival.stringFromDate(sender.date)
        
    }
    
    @IBAction func saveFlight(sender: AnyObject) {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
        if let user = user {
            let flight = Flights()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let departureDateTime = dateFormatter.dateFromString(self.dateTxt.text!)
            let arrivalTime = dateFormatter.dateFromString(self.arrivalDate.text!)
            
            
            flight.saveNewFlight(self.dateTxt.text!, from: self.fromTxt.text!, to: self.toTxt.text!, userID: user.uid, departureTime: departureDateTime!, arrivalTime: arrivalTime!, aircraftType: self.txtAircraftType.text!, aircraftRegistration: self.txtAircraftReg.text!)

            }
        }
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FlightVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        fromTxt.delegate = self
        toTxt.delegate = self
        
        
    }
    

    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
