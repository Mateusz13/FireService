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
    let firemna2: Int = 1
    let fireman3: Int = 2
    let firemna4: Int = 3
    
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
        
        let pressureLeft0 = doublePressure0[fireman1] - 70
        let pressureLeft1 = doublePressure1[fireman1] - 70
        //        let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1 = doublePressure0[fireman1] - doublePressure1[fireman1]
        let pressureUsed2 = doublePressure1[fireman1] - doublePressure2[fireman1]
        
        
        let entireTime1 = pressureLeft0 / pressureUsed1 * timeInterval1
        let entireTime2 = pressureLeft1 / pressureUsed2 * timeInterval2
        
        let leftTime1 = entireTime1 - timeInterval1
        let leftTime2 = entireTime2 - timeInterval2
        
        exitTime1 = leftTime1
        
        print(leftTime1)
        print(leftTime2)
    }
    
}
