//
//  Exercise.swift
//  GymApp
//
//  Created by Sam Sobell on 1/11/17.
//  Copyright © 2017 Sam Sobell. All rights reserved.
//

import Foundation

class Exercise {
    let name: String
    let timestamp : TimeInterval
    
    init(_ input: [String : AnyObject] = [:]){
        self.name = input["Name"] as? String ?? "Crunches"
        self.timestamp = input["Timestamp"] as? TimeInterval ?? NSDate.timeIntervalSinceReferenceDate
    }
}
