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
    
    //conversion
    
    
    var dTime0: [Double] = []
    var dTime1: [Double] = []
    var dTime2: [Double] = []
    
    var iPressure0: [Double] = []
    var iPressure1: [Double] = []
    var iPressure2: [Double] = []
    
    
    func conversion() {
        
//        let doubleTime0: [Double] = time0.map { Double($0) ?? 0 }
        
        //        time0.map {
        //            dTime0.append(Double($0) ?? 0)
        //        }
        for time in time0 {
            let doubleTime = Double(time) ?? 0
            dTime0.append(doubleTime)
        }
        for time in time1 {
            let doubleTime = Double(time) ?? 0
            dTime1.append(doubleTime)
        }
        for time in time2 {
            let doubleTime = Double(time) ?? 0
            dTime2.append(doubleTime)
        }
        for pressure in pressure0 {
            let intPressure = Double(pressure) ?? 0
            iPressure0.append(intPressure)
        }
        for pressure in pressure1 {
            let intPressure = Double(pressure) ?? 0
            iPressure1.append(intPressure)
        }
        for pressure in pressure2 {
            let intPressure = Double(pressure) ?? 0
            iPressure2.append(intPressure)
        }
    }
    
    
    
    //    init() {
    //        conversion()
    //
    //    }
    
    
    func calculateExitTime() {
                
        conversion()
        
        print(time0)
        print(dTime0)
        
        //        let timeInterval1 = ((Double(time1[0]) ?? 0) - (Double(time0[0]) ?? 0)) * 100
        //        let timeInterval2 = (time2[0] - time1[0]) * 100
        
        let timeInterval1 = (dTime1[rota1] - dTime0[rota1]) * 100
        let timeInterval2 = (dTime2[rota1] - dTime1[rota1]) * 100
        print(timeInterval2)
        //        let timeInterval20 = dTime2[rota1] - dTime0[rota1]
        
        let pressureLeft0 = iPressure0[fireman1] - 70
        let pressureLeft1 = iPressure1[fireman1] - 70
        //        let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1 = iPressure0[fireman1] - iPressure1[fireman1]
        let pressureUsed2 = iPressure1[fireman1] - iPressure2[fireman1]
        print(pressureUsed2)
        
        let entireTime1 = pressureLeft0 / pressureUsed1 * timeInterval1
        let entireTime2 = pressureLeft1 / pressureUsed2 * timeInterval2
        
        let leftTime1 = entireTime1 - timeInterval1
        let leftTime2 = entireTime2 - timeInterval2
        
        exitTime1 = leftTime1
        
        print(leftTime1)
        print(leftTime2)
    }
    
}
