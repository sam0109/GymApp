//
//  EditExerciseVC.swift
//  GymApp
//
//  Created by Sam Sobell on 11/18/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import UIKit

class EditExerciseVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    var workout : Workout?
    var exercise : Exercise?
    var transitionedFromCreate = false
    var selectedExerciseName = ""
    
    @IBOutlet weak var valueTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        valueTable.separatorStyle = .none

        if transitionedFromCreate {
            self.exercise = Exercise(self.selectedExerciseName){
                self.valueTable.reloadData()
            }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercise?.properties?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = (exercise?.propertiesList[indexPath.row])! as String
        let property = exercise?.properties?[name] as! [String : AnyObject]
        let type = property["ValueType"] as! String
        
        if type == "Int" {
            let cell = self.valueTable.dequeueReusableCell(withIdentifier: "int_cell")! as! IntCell
            var propertyDict = exercise?.properties?[name] as? [String : AnyObject]
            let value = (propertyDict?["Value"])!
            cell.statName.text = name
            cell.statValue.text = "\(value)"
            cell.closureOnChanged = { name, value in
                propertyDict?["Value"] = value as AnyObject?
                self.exercise?.updateProperty(name!, value: propertyDict as AnyObject)
            }
            return cell
        }
        else if type == "Picker" {
            let cell = self.valueTable.dequeueReusableCell(withIdentifier: "picker_cell")! as! PickerCell
            
            var propertyDict = exercise?.properties?[name] as? [String : AnyObject]
            let value = propertyDict?["Value"]
            let pickOption = propertyDict?["Options"] as? [String]
            
            cell.statName.text = name
            cell.statValue.text = value as? String
            cell.pickOption = pickOption
            cell.closureOnChanged = { name, value in
                propertyDict?["Value"] = value as AnyObject?
                self.exercise?.updateProperty(name!, value: propertyDict as AnyObject)
            }
            return cell
        }
        else{
            fatalError("Unknown cell type: " + type)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.exercise?.saveExercise(self.workout)
        
        if transitionedFromCreate {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
        else {
            self.dismiss(animated: true)
        }
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
