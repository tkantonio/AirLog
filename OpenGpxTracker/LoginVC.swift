//
//  LoginVC.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 22/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit


class LoginVC: UIViewController, FBSDKLoginButtonDelegate {

    var dbRef: FIRDatabaseReference!
    var flights = [Flights]()
    
   //  var FBLoginButton = FBSDKLoginButton()
     let FBLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLoginWithEmailOutlet: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblLoginIncorrect: UILabel!
    @IBOutlet weak var btnRegisterOutlet: UIButton!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @IBAction func btnLoginWithEmail(sender: AnyObject) {
        
        FIRAuth.auth()?.signInWithEmail(txtEmail.text!, password: txtPassword.text!, completion: {
            user, error in
            
            if error != nil {
                print("Nooooo")
                self.lblLoginIncorrect.hidden = false
                
            }
            else{
                print("Yessss!!!")
                self.lblLoginIncorrect.hidden = true
                self.performSegueWithIdentifier("NavigationController", sender: self)
            }
        })
        
        dismissKeyboard()
        
    }
    
    @IBAction func registerTapped(sender: AnyObject) {
      //  let vc = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterVC") as! RegisterVC
      //  self.presentViewController(vc, animated: true, completion: nil)
        self.performSegueWithIdentifier("ToRegisterVC", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FBLoginButton.delegate = self

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                print("User \(user.displayName) is already logged in via Facebook or Email!!!")
                self.lblLoginIncorrect.hidden = true
                self.performSegueWithIdentifier("NavigationController", sender: self)
                
  
                
                
            }
            else {
                
                self.FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.FBLoginButton.delegate = self
                
                
                self.view!.addSubview(self.FBLoginButton)
                
                //add constraints
                self.FBLoginButton.translatesAutoresizingMaskIntoConstraints = false
                
                let horizontalConstraint = NSLayoutConstraint(item: self.FBLoginButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
                let topConstraint = NSLayoutConstraint(item: self.FBLoginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.lblOr, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8)
                
                self.view.addConstraint(topConstraint)
                
                self.view.addConstraint(horizontalConstraint)
                
                self.FBLoginButton.layer.cornerRadius = 30
                self.btnLoginWithEmailOutlet.layer.cornerRadius = 5
                
                self.btnRegisterOutlet.layer.cornerRadius = 5
                
            }
            
            
        }
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton

        
    }
    
    func loginButton(FBLoginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            
            if error != nil{
                self.lblLoginIncorrect.hidden = false
            }else{
            print("Facebook user logged in!!!! Yayyy!!! \(user?.displayName)")
                
                
                self.lblLoginIncorrect.hidden = true
                self.lblLoginIncorrect.hidden = true
                self.performSegueWithIdentifier("NavigationController", sender: self)
                
                //Save user's profile
                let dateformatter = NSDateFormatter()
                dateformatter.dateFormat = "MM/dd/yy h:mm"
                let now = dateformatter.stringFromDate(NSDate())
                
                let ref = FIRDatabase.database().reference()
                self.dbRef = FIRDatabase.database().reference()

                self.dbRef.child("users").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                    
                    if snapshot.hasChild("65SyKGzL6uT9dWTJdZ6xVGEKUcT2"){
                        
                        
                        
                    }else{
                        
                        let userDatalet: [String:AnyObject] = ["Name": (user?.displayName)!,
                            "Surname": (user?.displayName)!,
                            "Email": "Facebook User",
                            "TelephoneNumber": "",
                            "Password": "Facebook User",
                            "RegisteredDate": now]
                        ref.child("users").child(user!.uid).setValue(userDatalet)                    }
                })

                


            }
        }
       
    }
    
    
    
    

    
    
    
    
    func loginButtonDidLogOut(FBLoginButton: FBSDKLoginButton!) {
        print("Facebook user logged out")
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
