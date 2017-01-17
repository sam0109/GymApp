//
//  Utilities.swift
//  GymApp
//
//  Created by Sam Sobell on 11/22/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import Foundation
import Firebase

//Generate name of the main storyboard file, by default: "Main"
var kMainStoryboardName: String {
    let info = Bundle.main.infoDictionary!
    
    if let value = info["TPMainStoryboardName"] as? String
    {
        return value
    }else{
        return "Main"
    }
}

class GAUtilities {
    class func showMessagePrompt(_ message: String, title: String = "Oops!", controller: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func showOverlay(_ view: UIView) -> UIView {
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

    class func nib(name: String) -> UINib?
    {
        let nib = UINib(nibName: name, bundle: Bundle.main);
        return nib
    }
        
    //Main storybord
    class func mainStoryboard() -> UIStoryboard
    {
        return storyboard(name: kMainStoryboardName)
    }
    class func storyboard(name: String) -> UIStoryboard
    {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard
    }
    
    //Obtain file from main bundle by name and fileType
    class func fileFromBundle(fileName: String?, fileType: String?) -> NSURL?
    {
        var url: NSURL?
        
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType)
        {
            url = NSURL.fileURL(withPath: path) as NSURL?
        }
        
        return url
    }
    
    class func plistValue(key:String) -> AnyObject?
    {
        let info = Bundle.main.infoDictionary!
        
        if let value: AnyObject = info[key] as AnyObject?
        {
            return value
        }else{
            return nil
        }
    }
    //instantiate view controller by name from main storyboard
    class func vcWithName(name: String) -> UIViewController?
    {
        let storyboard = mainStoryboard()
        let viewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: name)
        return viewController as? UIViewController
    }
    
    class func vcWithName(storyboardName:String, name: String) -> UIViewController?
    {
        let sb = storyboard(name: storyboardName)
        let viewController: AnyObject! = sb.instantiateViewController(withIdentifier: name)
        return viewController as? UIViewController
    }
    
    //Obtain view controller by idx from nib
    class func viewFromNib(nibName: String, atIdx idx:Int) -> UIView?
    {
        let view =  Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?[idx] as! UIView
        return view
    }
    
    class func viewFromNib(nibName: String, owner: AnyObject, atIdx idx:Int) -> UIView?
    {
        let bundle = Bundle(for: type(of: owner))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: owner, options: nil)[idx] as? UIView
        return view
    }
    
    class func viewFromNibV2(nibName: String, owner: AnyObject, atIdx idx:Int) -> UIView?
    {
        let view =  Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)?[idx] as! UIView
        return view
    }
}
