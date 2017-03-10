//
//  Exercise.swift
//  GymApp
//
//  Created by Sam Sobell on 1/11/17.
//  Copyright © 2017 Sam Sobell. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Exercise {

    let name: String
    var timestamp : TimeInterval
    var properties : [String : AnyObject]?
    var propertiesList : [String] = []
    var ref : FIRDatabaseReference?
    
    //for loading an exercise from a workout
    init(ref : FIRDatabaseReference, dataDict input : [String : AnyObject]){
        self.ref = ref
        self.name = input["Name"] as? String ?? ""
        if (input["Timestamp"] as? Double)! <= 0.0 {
            self.timestamp = NSDate.timeIntervalSinceReferenceDate
        }
        else{
            self.timestamp = input["Timestamp"] as? TimeInterval ?? NSDate.timeIntervalSinceReferenceDate
        }
        self.properties = input["Properties"] as? [String : AnyObject] ?? [:]
        for (key, _) in self.properties!{
            self.propertiesList.append(key)
        }
        self.propertiesList.sort()
        self.saveExercise()
    }
    
    //for creating an exercise from a template
    init(_ exerciseName : String, completion: @escaping (() -> ()) = {}) {
        self.name = exerciseName
        self.timestamp = NSDate.timeIntervalSinceReferenceDate
        AppDelegate.currentUserRef?.child("Exercises").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(exerciseName){
                let result = (snapshot.value as? [String : AnyObject] ?? [:])[exerciseName] as? [String : AnyObject]
                self.properties = result?["Properties"] as? [String : AnyObject] ?? [:]
                for (key, _) in self.properties!{
                    self.propertiesList.append(key)
                }
                self.propertiesList.sort()
                completion()
            }
            else{
                AppDelegate.exercisesRef.child(exerciseName).observeSingleEvent(of: .value, with: { (snapshot) in
                    let result = snapshot.value as? [String : AnyObject] ?? [:]
                    self.properties = result["Properties"] as? [String : AnyObject] ?? [:]
                    for (key, _) in self.properties!{
                        self.propertiesList.append(key)
                    }
                    self.propertiesList.sort()
                    completion()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func saveExercise(_ workout : Workout? = nil){
        if self.ref == nil {
            self.ref = workout?.AddExercise(self) ?? self.ref
        }
        self.ref?.updateChildValues(["Name" : self.name, "Timestamp" : self.timestamp, "Properties" : self.properties!])
        AppDelegate.currentUserRef?.child("Exercises").child(self.name).updateChildValues(["Name" : self.name, "Timestamp" : 0, "Properties" : self.properties!])
        //update user default values
        //weird bug happens if you do saving in two stages. It seems to take too long so upon loading immediately after saving you only get the first stage. Just FYI.
    }
    
    func updateProperty(_ name : String, value : AnyObject){
        self.properties?[name] = value
    }
    
    func deleteExercise(){
        self.ref?.removeValue()
    }
    
    class func getExercises(_ completion : @escaping (([String]) -> ()) = {_ in }) {
        AppDelegate.exercisesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let exercisesDict = snapshot.value as? [String : AnyObject] ?? [:]
            var exercises : [String] = []
            for (key, _) in exercisesDict {
                exercises.append(key)
            }
            completion(exercises)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
