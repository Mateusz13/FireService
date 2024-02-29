//
//  Fireman.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation


struct Rota: Identifiable, Codable {
    
    var id = UUID().uuidString
    let number: Int

    var f1Name: String
    var f2Name: String
    var f3Name: String
    var f4Name: String
    
    var time: [Date]? //start time?    IMPROVE COMMENT
    
    var f1Pressures: [String]
    var f2Pressures: [String]
    var f3Pressures: [String]
    var f4Pressures: [String]
    
    var timeToLeave: TimeInterval? // ADD COMMENT
    var exitDate: Date? // ADD COMMENT
//    var remainingTime: TimeInterval?
//    var duration: TimeInterval?
    
    var doubleF1Pressures: [Double] {
        return f1Pressures.compactMap(Double.init)
    }
    
    var doubleF2Pressures: [Double] {
        return f2Pressures.compactMap(Double.init)
    }
    
    var doubleF3Pressures: [Double] {
        return f3Pressures.compactMap(Double.init)
    }
    
    var doubleF4Pressures: [Double] {
        return f4Pressures.compactMap(Double.init)
    }
    
    func doublePressures(forFireman index: Int, _ measurement: Int) -> Double {
        switch index {
        case 0:
            return doubleF1Pressures[measurement]
        case 1:
            return doubleF2Pressures[measurement]
        case 2:
            return doubleF3Pressures[measurement]
        case 3:
            return doubleF4Pressures[measurement]
        default:
            return 0.0
        }
    }
    
    init(number: Int, f1Name: String = "", f2Name: String = "", f3Name: String = "", f4Name: String = "", f1Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""], f2Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""], f3Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""], f4Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""]) {
        self.number = number
        self.f1Name = f1Name
        self.f2Name = f2Name
        self.f3Name = f3Name
        self.f4Name = f4Name
        self.f1Pressures = f1Pressures
        self.f2Pressures = f2Pressures
        self.f3Pressures = f3Pressures
        self.f4Pressures = f4Pressures
    }
}
