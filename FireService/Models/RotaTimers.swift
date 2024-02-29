//
//  RotaTimers.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 29/02/2024.
//

import Foundation

struct RotaTimers: Identifiable, Codable {
    
    var id = UUID().uuidString
    //    let number: Int
    
    var time: [Date]? //start time IMPROVE COMMENT
    
    
    //    var timeToLeave: TimeInterval?
    //    var exitDate: Date?
    var remainingTime: TimeInterval?   // ADD COMMENT
    var duration: TimeInterval? //  ADD COMMENT
    
    
    //    init(number: Int) {
    //        self.number = number
    //    }
}
