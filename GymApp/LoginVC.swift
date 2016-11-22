//
//  LoginVC.swift
//  GymApp
//
//  Created by Sam Sobell on 11/22/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInUIDelegate {

    var overlay: UIView!
    
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeCurrentUserId(user_id : String){
        UserDefaults.standard.set(user_id, forKey: "user_id")
    }
    
    @IBAction func createAccountAction(_ sender: AnyObject)
    {
        self.overlay = GAUtilities.showOverlay(view: self.view)
        if self.emailOutlet.text == "" || self.passwordOutlet.text == ""
        {
            GAUtilities.removeOverlay(overlay: self.overlay)
            GAUtilities.showMessagePrompt("Please enter an email and password.", controller: self)
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: self.emailOutlet.text!, password: self.passwordOutlet.text!) { (user, error) in
                
                if error == nil {
                    self.storeCurrentUserId(user_id: (user?.uid)!)
                    self.performSegue(withIdentifier: "createProfileSegue", sender: nil)
                }
                else
                {
                    GAUtilities.removeOverlay(overlay: self.overlay)
                    GAUtilities.showMessagePrompt(error!.localizedDescription, controller: self)
                }
            }
        }
    }
    
    @IBAction func loginAction(_ sender: AnyObject)
    {
        self.overlay = GAUtilities.showOverlay(view: self.view)
        if self.emailOutlet.text == "" || self.passwordOutlet.text == ""
        {
            GAUtilities.removeOverlay(overlay: self.overlay)
            GAUtilities.showMessagePrompt("Please enter an email and password.", controller: self)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailOutlet.text!, password: self.passwordOutlet.text!) { (user, error) in
                
                if error == nil {
                    self.storeCurrentUserId(user_id: (user?.uid)!)
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
                else
                {
                    GAUtilities.removeOverlay(overlay: self.overlay)
                    GAUtilities.showMessagePrompt(error!.localizedDescription, controller: self)
                }
            }
        }
    }

}
