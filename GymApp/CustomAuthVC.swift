//
//  CustomAuthVC.swift
//  GymApp
//
//  Created by Sam Sobell on 2/15/17.
//  Copyright © 2017 Sam Sobell. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class CustomAuthVC: FUIAuthPickerViewController {
    
    //remove the next two functions once FB fixes bug:
    //https://github.com/firebase/FirebaseUI-iOS/issues/128
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
