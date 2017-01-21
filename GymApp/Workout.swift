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
    
    static let workoutsRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Workouts")
    static let exercisesRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Exercises")
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
            print(dict)
            for (key, value) in dict
            {
                let ref = self.ref?.child("Exercises").child(key)
                exerciseList.append(Exercise(ref: ref!, dataDict: value as! [String : AnyObject]))
            }
            exerciseList.sort(by: { $0.timestamp < $1.timestamp })
            completion(exerciseList)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func AddExercise(_ exercise : String, completion: @escaping ((Exercise) -> ()) = {_ in }) {
        Workout.exercisesRef.child(exercise).observeSingleEvent(of: .value, with: { (snapshot) in
            let newExerciseRef = self.ref?.child("Exercises").childByAutoId()
            completion(Exercise(ref: newExerciseRef!, dataDict: snapshot.value as! [String : AnyObject]))
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func AddExercise(_ exercise : Exercise) -> FIRDatabaseReference {
        return (self.ref?.child("Exercises").childByAutoId())!
    }
    
    func saveAndReplaceWorkout(userID : String, completion : @escaping ((Workout) -> ())) -> Workout
    {
        Workout.usersRef.child(userID).child("Workouts").childByAutoId().setValue(self.ref?.key)
        Workout.usersRef.child(userID).child("CurrentWorkout").removeValue()
        return Workout.init(userID: userID, completion: completion)
    }
}
