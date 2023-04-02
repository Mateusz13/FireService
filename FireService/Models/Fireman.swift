//
//  Fireman.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation


struct Rota: Identifiable {
    
    let id = UUID().uuidString
    
    let number: Int
    
    var f1Name: String
    var f2Name: String
    
    var time: [Date]?
    
    var duration: TimeInterval = 0 //should be optional as well?
    
    var f1Pressures: [String]
    var f2Pressures: [String]
    
    var exitTime: TimeInterval?
    
    var doubleF1Pressures: [Double] {
        return f1Pressures.compactMap(Double.init)
    }
    
    
    var doubleF2Pressures: [Double] {
        return f2Pressures.compactMap(Double.init)
    }
    
    
    init(number: Int, f1Name: String = "", f2Name: String = "", f1Pressures: [String] = ["", "", ""], f2Pressures: [String] = ["", "", ""]) {
        self.number = number
        self.f1Name = f1Name
        self.f2Name = f2Name
        self.f1Pressures = f1Pressures
        self.f2Pressures = f2Pressures
    }
}





//    init(number: Int, f1Name: String = "", f2Name: String = "", f1Pressure0: String = "", f1Pressure1: String = "", f1Pressure2: String = "", f2Pressure0: String = "", f2Pressure1: String = "", f2Pressure2: String = "") {
//        self.number = number
//        self.f1Name = f1Name
//        self.f2Name = f2Name
//        self.f1Pressure0 = f1Pressure0
//        self.f1Pressure1 = f1Pressure1
//        self.f1Pressure2 = f1Pressure2
//        self.f2Pressure0 = f2Pressure0
//        self.f2Pressure1 = f2Pressure1
//        self.f2Pressure2 = f2Pressure2
//    }

