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
    static let usersRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Users")
    private var ref: FIRDatabaseReference?
    private var name : String?
    private var date : TimeInterval?
    private var duration : Int?
    
    init(completion : @escaping ((Workout) -> ()) = {_ in })
    {
        self.newWorkout(completion: completion)
    }
    
    init(workoutID : String, completion : @escaping ((Workout) -> ()) = {_ in })
    {
        self.workoutFromID(workoutID: workoutID, completion: completion)
    }
    
    init(userID : String, completion : @escaping ((Workout) -> ()))
    {
        Workout.usersRef.child(userID).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value?["CurrentWorkout"] == nil{
                self.newWorkout(completion: completion)
            }
            else{
                self.workoutFromID(workoutID: value?["CurrentWorkout"] as! String, completion: completion)
            }
        })
    }
    
    private func workoutFromID(workoutID : String, completion : @escaping ((Workout) -> ()) = {_ in }){
        self.ref = Workout.workoutsRef.child(workoutID)
        self.ref?.observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            self.date = dict["Date"] as? TimeInterval ?? NSDate.timeIntervalSinceReferenceDate
            self.name = dict["Name"] as? String ?? ""
            self.duration = dict["Duration"] as? Int ?? 0
            completion(self)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func newWorkout(completion : @escaping ((Workout) -> ()) = {_ in }){
        self.ref = Workout.workoutsRef.childByAutoId()
        self.date = NSDate.timeIntervalSinceReferenceDate
        self.name = ""
        self.duration = 0
        completion(self)
    }
    
    func RegisterCallback(_ completion : @escaping (([Exercise]) -> ())){
        self.ref?.child("Exercises").observe(FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            var exerciseList : [Exercise] = []
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
    
    func AddExercise(_ exercise : Exercise) -> FIRDatabaseReference {
        return (self.ref?.child("Exercises").childByAutoId())!
    }
    
    func saveAndReplaceWorkout(userID : String, completion : @escaping ((Workout) -> ())) -> Workout
    {
        Workout.usersRef.child(userID).child("CurrentWorkout").removeValue()
        return Workout(userID: userID, completion: completion)
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
        self.ref?.updateChildValues(["Name" : self.name ?? "", "Date" : self.date ?? NSDate.timeIntervalSinceReferenceDate, "Duration" : self.duration ?? 0])
    }
    
    class func getWorkoutsForUser(_ userID : String, completion : @escaping ([(Double, String)]) -> ()){
        Workout.usersRef.child(userID).child("Workouts").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            var result : [(Double, String)] = []
            for (key, value) in dict{
                result.append(value["Date"] as! Double, key)
            }
            result.sort(by: {$0.0 > $1.0})
            completion(result)
        })
    }
}
