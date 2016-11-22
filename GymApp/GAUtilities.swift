//
//  Utilities.swift
//  GymApp
//
//  Created by Sam Sobell on 11/22/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import Foundation
import Firebase

class GAUtilities {
    class func showMessagePrompt(_ message: String, title: String = "Oops!", controller: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func showOverlay(view: UIView) -> UIView {
        let overlay = UIView(frame: view.frame)
        overlay.center = view.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        view.addSubview(overlay)
        view.bringSubview(toFront: overlay)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
        UIView.commitAnimations()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.center = overlay.center
        indicator.startAnimating()
        overlay.addSubview(indicator)
        
        return overlay
    }
    
    class func removeOverlay(overlay: UIView) {
        overlay.removeFromSuperview()
    }
}
