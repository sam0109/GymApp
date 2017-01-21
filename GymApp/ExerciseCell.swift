//
//  exerciseCell.swift
//  GymApp
//
//  Created by Sam Sobell on 1/19/17.
//  Copyright © 2017 Sam Sobell. All rights reserved.
//

import Foundation
import UIKit

class ExerciseCell : UITableViewCell, UITextFieldDelegate{
    
    @IBOutlet weak var statValue: UITextField!
    @IBOutlet weak var statName: UILabel!
    var closureOnChanged : (String?, String?) -> () = {_ in }
    
    @IBAction func textChanged(_ sender: Any) {
        self.closureOnChanged(self.statName.text, self.statValue.text)
    }
}
