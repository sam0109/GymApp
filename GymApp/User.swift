//
//  User.swift
//  GymApp
//
//  Created by Sam Sobell on 11/21/16.
//  Copyright © 2016 Sam Sobell. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class User {
    private static var usersRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Users")
    private var ref : FIRDatabaseReference
    
    init() {
        ref = User.usersRef.childByAutoId()
    }
    
    func AddWorkout(_ workoutID : String) {
        let newRef = self.ref.child("Workouts").childByAutoId()
        newRef.setValue(workoutID)
    }
}
