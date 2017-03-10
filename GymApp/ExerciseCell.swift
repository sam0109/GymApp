//
//  exerciseCell.swift
//  GymApp
//
//  Created by Sam Sobell on 1/19/17.
//  Copyright © 2017 Sam Sobell. All rights reserved.
//

import Foundation
import UIKit

class IntCell : UITableViewCell, UITextFieldDelegate{
    
    @IBOutlet weak var statValue: UITextField!
    @IBOutlet weak var statName: UILabel!
    var closureOnChanged : (String?, String?) -> () = {_ in }
    
    @IBAction func textChanged(_ sender: Any) {
        self.closureOnChanged(self.statName.text, self.statValue.text)
    }
}

class PickerCell : UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var statName: UILabel!
    @IBOutlet weak var statValue: UITextField!
    
    var pickOption: [String]?
    
    var closureOnChanged : (String?, String?) -> () = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        statValue.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statValue.text = pickOption?[row]
        self.closureOnChanged(self.statName.text, pickOption?[row])
    }
}
