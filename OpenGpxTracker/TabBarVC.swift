//
//  TabBarVC.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 22/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FirebaseMessaging

class TabBarVC: UITabBarController {

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Air Log"

        
//        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//            if let user = user {
//                
//                self.title = "Air Log"
//
//            }
//            else {}
//        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnLogOutTouchedInside(sender: AnyObject) {
        
        //Log out of Fireapp
        try! FIRAuth.auth()!.signOut()
        
        
        //Log out of Facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        //Go to login page
        self.performSegueWithIdentifier("ToHomePage", sender: self)

    }

}
