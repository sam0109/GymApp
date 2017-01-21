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

class EditWorkoutVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var exercisesTable: UITableView!
    var workout : Workout?
    var items: [Exercise] = []
    var selectedExercise : Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exercisesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.workout = Workout(userID: (FIRAuth.auth()?.currentUser?.uid)!){workout in
            workout.RegisterCallback(){exercises in
                self.items = exercises
                self.exercisesTable.reloadData()
            }
        }
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneEditingWorkout(_ sender: Any) {
        self.workout = workout?.saveAndReplaceWorkout(userID: (FIRAuth.auth()?.currentUser?.uid)!){workout in
            workout.RegisterCallback(){exercises in
                self.items = exercises
                self.exercisesTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count + 1;
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AddExerciseVC {
            dest.workout = self.workout
        }
        else if let dest = segue.destination as? EditExerciseVC {
            dest.exercise = self.selectedExercise!
        }
    }
}
