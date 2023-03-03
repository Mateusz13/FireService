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
    
    var time0: String
    var time1: String
    var time2: String
    
    var f1Pressure0: String
    var f1Pressure1: String
    var f1Pressure2: String
    
    var f2Pressure0: String
    var f2Pressure1: String
    var f2Pressure2: String
    
    var exitTime: Double?
    
    var doubleTime0: Double {
        return Double(time0) ?? 0
    }
    
    var doubleTime1: Double {
        return Double(time1) ?? 0
    }
    
    var doubleTime2: Double {
        return Double(time2) ?? 0
    }
    
    var doubleF1Pressure0: Double {
        return Double(f1Pressure0) ?? 0
    }
    
    var doubleF1Pressure1: Double {
        return Double(f1Pressure1) ?? 0
    }
    
    var doubleF1Pressure2: Double {
        return Double(f1Pressure2) ?? 0
    }
    
    var doubleF2Pressure0: Double {
        return Double(f2Pressure0) ?? 0
    }
    
    var doubleF2Pressure1: Double {
        return Double(f2Pressure1) ?? 0
    }
    
    var doubleF2Pressure2: Double {
        return Double(f2Pressure2) ?? 0
    }
    
    
    init(number: Int, f1Name: String = "", f2Name: String = "", time0: String = "", time1: String = "", time2: String = "", f1Pressure0: String = "", f1Pressure1: String = "", f1Pressure2: String = "", f2Pressure0: String = "", f2Pressure1: String = "", f2Pressure2: String = "") {
        self.number = number
        self.f1Name = f1Name
        self.f2Name = f2Name
        self.time0 = time0
        self.time1 = time1
        self.time2 = time2
        self.f1Pressure0 = f1Pressure0
        self.f1Pressure1 = f1Pressure1
        self.f1Pressure2 = f1Pressure2
        self.f2Pressure0 = f2Pressure0
        self.f2Pressure1 = f2Pressure1
        self.f2Pressure2 = f2Pressure2
    }
}
