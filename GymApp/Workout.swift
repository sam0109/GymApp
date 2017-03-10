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
    
    private var ref: FIRDatabaseReference?
    public private(set) var exercises : [Exercise] = []
    public private(set) var name : String?
    public private(set) var date : TimeInterval?
    public private(set) var duration : Int?

    class func newWorkout(workoutID : String, completion : @escaping ((Workout) -> ())){
        let workout = Workout()
        workout.workoutFromID(workoutID: workoutID, completion: completion)
    }
    
    class func newWorkoutForUser(completion : @escaping ((Workout) -> ())){
        AppDelegate.currentUserRef?.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let workout = Workout()
            if value?["CurrentWorkout"] == nil{
                workout.ref = AppDelegate.currentUserRef?.child("Workouts").childByAutoId()
                workout.date = NSDate.timeIntervalSinceReferenceDate
                workout.name = ""
                workout.duration = 0
                workout.saveWorkoutVals()
                AppDelegate.currentUserRef?.updateChildValues(["CurrentWorkout" : workout.ref!.key])
                completion(workout)
            }
            else{
                workout.workoutFromID(workoutID: value?["CurrentWorkout"] as! String, completion: completion)
            }
        })
    }
    
    private func workoutFromID(workoutID : String, completion : @escaping ((Workout) -> ())){
        self.ref = AppDelegate.currentUserRef?.child("Workouts").child(workoutID)
        self.ref?.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            self.date = dict["Date"] as? TimeInterval
            self.name = dict["Name"] as? String
            self.duration = dict["Duration"] as? Int
            completion(self)
        })
    }
    
    func RegisterCallback(_ completion : @escaping (() -> ())){
        self.ref?.observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            var exerciseList : [Exercise] = []
            for (key, value) in dict["Exercises"] as? [String : AnyObject] ?? [:]
            {
                let ref = self.ref?.child("Exercises").child(key)
                exerciseList.append(Exercise(ref: ref!, dataDict: value as! [String : AnyObject]))
            }
            exerciseList.sort(by: { $0.timestamp < $1.timestamp })
            self.exercises = exerciseList
            self.date = dict["Date"] as? TimeInterval
            self.name = dict["Name"] as? String
            self.duration = dict["Duration"] as? Int
            completion()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func AddExercise(_ exercise : Exercise) -> FIRDatabaseReference {
        return (self.ref?.child("Exercises").childByAutoId())!
    }
    
    func replaceCurrentWorkout(completion : @escaping ((Workout) -> ()))
    {
        AppDelegate.currentUserRef?.child("CurrentWorkout").removeValue()
        Workout.newWorkoutForUser(completion: completion)
    }
    
    func isCurrentWorkout(_ completion : @escaping (Bool) -> ()){
        AppDelegate.currentUserRef?.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if self.ref?.key == value?["CurrentWorkout"] as? String{
                completion(true)
            }
            completion(false)
        })
    }
    
    func update(Name: String){
        self.name = Name
        self.saveWorkoutVals()
    }
    
    func update(Date: TimeInterval){
        self.date = Date
        self.saveWorkoutVals()
    }
    
    func update(Duration: Int){
        self.duration = Duration
        self.saveWorkoutVals()
    }
    
    func saveWorkoutVals(){
        self.ref?.updateChildValues(["Name" : self.name!, "Date" : self.date!, "Duration" : self.duration!])
        AppDelegate.workoutsListRef?.child(self.ref!.key).updateChildValues(["Name": self.name!, "Date" : self.date!])
    }
    
    class func deleteWorkout(_ workoutID : String){
        AppDelegate.workoutsListRef?.child(workoutID).removeValue()
        AppDelegate.workoutsRef?.child(workoutID).removeValue()
    }
    
    class func getWorkoutsForCurrentUser(completion : @escaping ([(Double, String, String)]) -> ()){
        AppDelegate.currentUserRef?.observe(FIRDataEventType.value, with: { (snapshot) in
            let userVals = snapshot.value as? [String : AnyObject] ?? [:]
            let currentWorkout = userVals["CurrentWorkout"] as? String ?? ""
            let dict = userVals["WorkoutsList"] as? [String : AnyObject] ?? [:]
            var result : [(Double, String, String)] = []
            for (key, value) in dict{
                if key != currentWorkout {
                    result.append(value["Date"] as! Double, value["Name"] as! String , key)
                }
            }
            result.sort(by: {$0.0 > $1.0})
            completion(result)
        })
    }
}
