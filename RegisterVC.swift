//
//  TestVC.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 30/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit


class RegisterVC: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telNo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var validationError: UILabel!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    @IBAction func loginBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("ToLoginFromRegister", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                print("User \(user.displayName) registered and logged in ???.....")
          //      self.performSegueWithIdentifier("ToLoginFromRegister", sender: self)
                
            }


    }
    }
    

    @IBAction func registerClicked(sender: AnyObject) {
        print("rejestruje")
        let newUser = Registration()
        if name != "" && name != " "{
            if surname.text != "" && surname.text != " "{
                if newUser.validateEmail(email.text!){
                    if newUser.validateTelNo(telNo.text!){
                        if password.text == password2.text{
                            newUser.registerUser(name.text!, Surname: surname.text!, email: email.text!, telephoneNo: telNo.text!, password: password.text!, completionHandler: { (Bool) in
                                if Bool == true{
                                    print("Zarejestrowany")
                                    self.validationError.hidden = true
                                    
                                    self.loginBtnOutlet.hidden = false
                                    
                                    //Log out of Fireapp
                                    try! FIRAuth.auth()!.signOut()
                                    
                                    //Log out of Facebook app
                                    FBSDKAccessToken.setCurrentAccessToken(nil)
                                    
                                    
                                }else{
                                    print("Rejestracja niepomyslna!")
                                }

                            })
                            // use success here
                        }else{
                            print("Passwords don't match")
                            validationError.hidden = false
                        }
                    }else{
                        print("TelNo chujowy")
                        validationError.hidden = false
                    }
                }
                else{
                    print("Email chujowy")
                    validationError.hidden = false
                }
                }else{
                    print("Surname blank")
                validationError.hidden = false
                }
            }else{
                print("Name blank")
            validationError.hidden = false
            }
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
