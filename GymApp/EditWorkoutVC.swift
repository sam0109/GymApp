//
//  CreateAWorkoutViewController.swift
//  GymApp
//
//  Created by Sam Sobell on 11/18/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditWorkoutVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate {

    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var exercisesTable: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!

    var workout : Workout?
    var workoutStartDate : TimeInterval?
    var selectedExercise : Exercise?
    var editingPastWorkout = false
    var dateFormatter : DateFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exercisesTable.allowsMultipleSelectionDuringEditing = false;
        if self.workout == nil{
            Workout.newWorkoutForUser(){workout in
                self.registerNewWorkout(workout)
            }
        }
        else{
            self.registerNewWorkout(self.workout!)
        }
        
        if(editingPastWorkout){
            self.navigationBar.topItem?.title = "Edit Workout";
        }
        
        //draw a line to separate exercisesTable
        self.exercisesTable.tableHeaderView = GAUtilities.drawLine(width: self.exercisesTable.frame.size.width)
        self.exercisesTable.tableHeaderView?.backgroundColor = self.exercisesTable.separatorColor
        
        //initialize the date formatter
        self.dateFormatter = DateFormatter()
        self.dateFormatter?.dateStyle = DateFormatter.Style.short
        self.dateFormatter?.timeStyle = DateFormatter.Style.short
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func registerNewWorkout(_ workout : Workout){
        self.workout = workout
        self.workout!.RegisterCallback(){
            self.exercisesTable.reloadData()
            self.dateTextField.text = self.dateFormatter?.string(from: NSDate(timeIntervalSinceReferenceDate: (self.workout?.date)!) as Date)
            self.workoutName.text = self.workout?.name ?? ""
            self.duration.text = String(self.workout?.duration ?? 0)
        }
    }

    @IBAction func doneEditingWorkout(_ sender: Any) {
        if (self.workoutName.text?.isEmpty)! {
            let alert = UIAlertController(title: "No Name", message: "Please enter a name for the workout!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if self.duration.text == "0" {
            let alert = UIAlertController(title: "Zero Duration", message: "Please enter a duration for the workout!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.workout?.update(Name: self.workoutName.text ?? "")
        self.workout?.update(Duration: Int(self.duration.text ?? "0") ?? 0)
        self.workout?.update(Date: self.workoutStartDate ?? NSDate.timeIntervalSinceReferenceDate)
        
        if editingPastWorkout {
            self.dismiss(animated: true, completion: {})
        }
        else {
            workout?.replaceCurrentWorkout(){self.registerNewWorkout($0)}
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.workout?.exercises.count ?? 0) + 1;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete
            && self.workout?.exercises.count != indexPath.row) {
            self.workout!.exercises[indexPath.row].deleteExercise()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.exercisesTable.dequeueReusableCell(withIdentifier: "exercise_cell")! as UITableViewCell
        
        if indexPath.row == (self.workout?.exercises.count ?? 0) {
            cell.textLabel?.text = "Add Exercise"
        }
        else{
            cell.textLabel?.text = self.workout!.exercises[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.workout!.exercises.count {
            performSegue(withIdentifier: "add_exercise", sender: self)
        }
        else{
            self.selectedExercise = self.workout!.exercises[indexPath.row]
            performSegue(withIdentifier: "edit_exercise", sender: self)
        }
    }
    
    @IBAction func durationEditing(_ sender: Any) {
        self.duration.inputAccessoryView = GAUtilities.addDoneButtonForTextField(target: self, action: #selector(durationDonePressed))
    }

    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EditWorkoutVC.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        self.dateTextField.inputAccessoryView = GAUtilities.addDoneButtonForTextField(target: self, action: #selector(startTimeDonePressed))
    }
    
    func startTimeDonePressed(){
        self.doneEditingStartTime(sender : self)
        dateTextField.resignFirstResponder()
    }
    
    func durationDonePressed(){
        self.doneEditingDuration(sender : self)
        duration.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        dateTextField.text = self.dateFormatter?.string(from: sender.date)
        self.workoutStartDate = sender.date.timeIntervalSinceReferenceDate
    }
    
    @IBAction func doneEditingName(_ sender: Any) {
        self.workout?.update(Name: self.workoutName.text ?? "")
    }

    @IBAction func doneEditingDuration(_ sender: Any) {
        self.workout?.update(Duration: Int(self.duration.text ?? "0") ?? 0)
    }
    
    @IBAction func doneEditingStartTime(_ sender: Any) {
        self.workout?.update(Date: self.workoutStartDate ?? NSDate.timeIntervalSinceReferenceDate)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        workoutName.resignFirstResponder()
        duration.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AddExerciseVC {
            dest.workout = self.workout
        }
        else if let dest = segue.destination as? EditExerciseVC {
            dest.exercise = self.selectedExercise!
        }
    }
}
