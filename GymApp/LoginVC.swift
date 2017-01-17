//
//  LoginVC.swift
//  GymApp
//
//  Created by Sam Sobell on 11/22/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI
//import FirebaseTwitterAuthUI

class LoginVC: UIViewController, FUIAuthDelegate {
    
    //fileprivate(set) var authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    
    override func viewDidLoad() {
        let authUI = FUIAuth.defaultAuthUI()
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            //FUIFacebookAuth(),
            //FUITwitterAuth(),
        ]
        authUI?.providers = providers
        
        authUI?.delegate = self as FUIAuthDelegate?

        super.viewDidLoad()
        checkLogin();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkLogin() {
        let controller = FUIAuth.defaultAuthUI()?.authViewController()
        self.present(controller!, animated: true, completion: nil)
    }
    
    //called after login completed
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        print("test: tada!")
        if let error = error {
            print("Error logging in: ")
            print(error)
            return
        }
        self.performSegue(withIdentifier: "enter_app", sender: self)
    }
}
