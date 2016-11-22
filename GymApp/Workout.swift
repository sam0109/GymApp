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
    private let ref: FIRDatabaseReference
    
    init(_ user: User)
    {
        self.ref = Workout.workoutsRef.childByAutoId()
        user.AddWorkout(self.ref.key)
    }
    
    func RegisterCallback(_ completion : @escaping ((NSDictionary) -> ())){
        self.ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            completion(postDict as NSDictionary)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func AddExercise(_ name : String, completion: @escaping ((NSDictionary) -> ())) {
        Workout.exercisesRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
            let newExercise = self.ref.child("Exercises").childByAutoId()
            newExercise.setValue(snapshot.value as? NSDictionary)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
