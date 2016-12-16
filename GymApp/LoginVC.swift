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

class LoginVC: UIViewController, FUIAuthDelegate {
    
    //fileprivate(set) var authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        // handle user and error as necessary
    }
    
    func checkLogin() {
        let controller = FUIAuth.defaultAuthUI()?.authViewController()
        self.present(controller!, animated: true, completion: nil)
    }
}
