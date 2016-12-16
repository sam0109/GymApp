//
//  UIStoryboardExtension.swift
//  GymApp
//
//  Created by Sam Sobell on 12/15/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateViewController(_ storyboard: String, identifier: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
