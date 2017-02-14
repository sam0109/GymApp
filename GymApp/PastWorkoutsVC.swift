//
//  PastWorkoutsVC.swift
//  GymApp
//
//  Created by Sam Sobell on 1/23/17.
//  Copyright © 2017 Sam Sobell. All rights reserved.
//

import UIKit
import FirebaseAuth

class PastWorkoutsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var workoutsTable: UITableView!
    var workouts : [(Double, String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workoutsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.workoutsTable.allowsMultipleSelectionDuringEditing = false;
        Workout.getWorkoutsForCurrentUser() { workouts in
            self.workouts = workouts
            self.workoutsTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.workoutsTable.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.workouts[indexPath.row].1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = tabBarController?.viewControllers?[0] as! EditWorkoutVC
        Workout.newWorkout(workoutID: workouts[indexPath.row].2){ workout in
            dest.registerNewWorkout(workout)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            Workout.deleteWorkout(workouts[indexPath.row].2)
        }
    }
}
