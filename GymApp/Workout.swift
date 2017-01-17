//
//  Workout.swift
//  GymApp
//
//  Created by Sam Sobell on 11/21/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Workout {
    
    private static let workoutsRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Workouts")
    private static let exercisesRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Exercises")
    private static let usersRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Users")
    private var ref: FIRDatabaseReference?
    
    init()
    {
        self.ref = Workout.workoutsRef.childByAutoId()
    }
    
    init(workoutID : String)
    {
        self.ref = Workout.workoutsRef.child(workoutID)
    }
    
    init(userID : String, completion : @escaping ((Workout) -> ()))
    {
        Workout.usersRef.child(userID).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value?["CurrentWorkout"] == nil{
                self.ref = Workout.workoutsRef.childByAutoId()
                self.ref?.updateChildValues(["CreatedDate" : NSDate.timeIntervalSinceReferenceDate])
                Workout.usersRef.child(userID).updateChildValues(["CurrentWorkout" : self.ref?.key as Any])
            }
            else{
                self.ref = Workout.workoutsRef.child(value?["CurrentWorkout"] as! String)
            }
            completion(self)
        })
    }
    
    func RegisterCallback(_ completion : @escaping (([Exercise]) -> ())){
        self.ref?.child("Exercises").observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            var exerciseList : [Exercise] = []
            for (_, value) in dict
            {
                print(value)
                exerciseList.append(Exercise(value as! [String : AnyObject]))
            }
            exerciseList.sort(by: { $0.timestamp > $1.timestamp })
            completion(exerciseList)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func AddExercise(_ exercise : Exercise, completion: @escaping (() -> ()) = {}) {
        Workout.exercisesRef.child(exercise.name).observeSingleEvent(of: .value, with: { (snapshot) in
            let newExercise = self.ref?.child("Exercises").childByAutoId()
            newExercise?.setValue(snapshot.value as? NSDictionary)
            completion()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
