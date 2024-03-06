//
//  RotaTimers.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 29/02/2024.
//

import Foundation

struct RotaTimers: Identifiable, Codable {
    
    var id = UUID().uuidString
    var remainingTime: TimeInterval?   // how much time remain to exit (updating every second)
    var duration: TimeInterval? // duration of the action (updating every second)
}
