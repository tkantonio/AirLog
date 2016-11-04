//
//  Registration.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 30/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Registration {
    
    
    
    func validateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(email)
    }
    
    func validateTelNo(value: String) -> Bool {
        let PHONE_REGEX = "^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    
    func registerUser(name: String, Surname: String, email: String, telephoneNo: String, password: String, completionHandler: (Bool) -> ()){
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print("\(error.debugDescription)")
                completionHandler(false)
            }else{
                print("zarejestrowany!!!")
                
                
                let dateformatter = NSDateFormatter()
                dateformatter.dateFormat = "MM/dd/yy h:mm"
                let now = dateformatter.stringFromDate(NSDate())
                
                //Save user's profile
                let ref = FIRDatabase.database().reference()
                let userDatalet: [String:AnyObject] = ["Name": name,
                    "Surname": Surname,
                    "Email": email,
                    "TelephoneNumber": telephoneNo,
                    "Password": password,
                    "RegisteredDate": now]
                ref.child("users").child(user!.uid).setValue(userDatalet)
                
                completionHandler(true)
                
            }
        })
    }
    
    
    
}