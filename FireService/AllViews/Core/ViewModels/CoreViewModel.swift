//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


class CoreViewModel: ObservableObject {
    
    
    @Published var allRotas: [Fireman] = []
    
    @Published var name: [String] = ["", "", ""]
    
    @Published var pressure0: [String] = ["", "", ""]
    @Published var pressure1: [String] = ["", "", ""]
    @Published var pressure2: [String] = ["", "", ""]
    
    @Published var time0: [String] = ["", "", ""]
    @Published var time1: [String] = ["", "", ""]
    @Published var time2: [String] = ["", "", ""]
    
    //    @Published var exitTime: [Double?] = []
    //    @Published var exitTime: [Double?] = [nil]
    
    @Published var exitTime1: Double? = nil
    
    
    let minimalPressure: Int = 70
    
    let fireman1: Int = 0
    let fireman2: Int = 1
    let fireman3: Int = 2
    let fireman4: Int = 3
    
    let rota1: Int = 0
    let rota2: Int = 1
    
    
    func calculateExitTime() {
        
        // convertion:
        let doubleTime0: [Double] = time0.map { Double($0) ?? 0 }
        let doubleTime1: [Double] = time1.map { Double($0) ?? 0 }
        let doubleTime2: [Double] = time2.map { Double($0) ?? 0 }
        
        let doublePressure0: [Double] = pressure0.map { Double($0) ?? 0 }
        let doublePressure1: [Double] = pressure1.map { Double($0) ?? 0 }
        let doublePressure2: [Double] = pressure2.map { Double($0) ?? 0 }
        
        // calculation:
        let timeInterval1 = (doubleTime1[rota1] - doubleTime0[rota1]) * 100
        let timeInterval2 = (doubleTime2[rota1] - doubleTime1[rota1]) * 100
        //        let timeInterval20 = dTime2[rota1] - dTime0[rota1]
        
        //fireman1
        let pressureLeft01 = doublePressure0[fireman1] - 70
        let pressureLeft11 = doublePressure1[fireman1] - 70
        //        let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed11 = doublePressure0[fireman1] - doublePressure1[fireman1]
        let pressureUsed21 = doublePressure1[fireman1] - doublePressure2[fireman1]
        
        let entireTime11 = pressureLeft01 / pressureUsed11 * timeInterval1
        let entireTime21 = pressureLeft11 / pressureUsed21 * timeInterval2
        
        let leftTime11 = entireTime11 - timeInterval1
        let leftTime21 = entireTime21 - timeInterval2
        
        print(leftTime11)
        print(leftTime21)
        
        //fireman2
        let pressureLeft02 = doublePressure0[fireman2] - 70
        let pressureLeft12 = doublePressure1[fireman2] - 70
        
        let pressureUsed12 = doublePressure0[fireman2] - doublePressure1[fireman2]
        let pressureUsed22 = doublePressure1[fireman2] - doublePressure2[fireman2]
        
        let entireTime12 = pressureLeft02 / pressureUsed12 * timeInterval1
        let entireTime22 = pressureLeft12 / pressureUsed22 * timeInterval2
        
        let leftTime12 = entireTime12 - timeInterval1
        let leftTime22 = entireTime22 - timeInterval2
        
        
        print(leftTime12)
        print(leftTime22)
        
        
        guard doubleTime2[rota1] == 0 else {
            if leftTime21 > leftTime22 {
                exitTime1 = leftTime22
            } else {
                exitTime1 = leftTime21
            }
            
            return
        }
        
        
        if leftTime11 > leftTime12 {
            exitTime1 = leftTime12
        } else {
            exitTime1 = leftTime11
        }
    }
}
