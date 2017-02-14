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

class EditWorkoutVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var exercisesTable: UITableView!
    var workout : Workout?
    var workoutStartDate : TimeInterval?
    var items: [Exercise] = []
    var selectedExercise : Exercise?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exercisesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.exercisesTable.allowsMultipleSelectionDuringEditing = false;
        if self.workout == nil{
            Workout.newWorkoutForUser(){workout in
                self.registerNewWorkout(workout)
            }
        }
        else{
            self.registerNewWorkout(self.workout!)
        }
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNewWorkout(_ workout : Workout){
        self.workout = workout
        self.workout!.RegisterCallback(){exercises in
            self.items = exercises
            self.exercisesTable.reloadData()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            self.dateTextField.text = dateFormatter.string(from: NSDate(timeIntervalSinceReferenceDate: (self.workout?.date)!) as Date)
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
        
        workout?.replaceWorkout(){self.registerNewWorkout($0)}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count + 1;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.items[indexPath.row].deleteExercise()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.exercisesTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if indexPath.row == items.count {
            cell.textLabel?.text = "Add Exercise"
        }
        else{
            cell.textLabel?.text = self.items[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == items.count {
            performSegue(withIdentifier: "add_exercise", sender: self)
        }
        else{
            self.selectedExercise = self.items[indexPath.row]
            performSegue(withIdentifier: "edit_exercise", sender: self)
        }
    }

    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EditWorkoutVC.datePickerValueChanged), for: UIControlEvents.valueChanged)

    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateTextField.text = dateFormatter.string(from: sender.date)
        self.workoutStartDate = sender.date.timeIntervalSinceReferenceDate
    }
    
    @IBAction func doneEditingName(_ sender: Any) {
        self.workout?.update(Name: self.workoutName.text ?? "")
    }
    
    @IBAction func doneEditingDuration(_ sender: Any) {
        self.workout?.update(Duration: Int(self.workoutName.text ?? "0") ?? 0)
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
