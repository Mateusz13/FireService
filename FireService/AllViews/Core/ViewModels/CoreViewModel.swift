//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


class CoreViewModel: ObservableObject {
    
    
    @Published var rotas: [Rota] = [Rota(f1Name: "", f2Name: "", time0: "", time1: "", time2: "", f1Pressure0: "", f1Pressure1: "", f1Pressure2: "", f2Pressure0: "", f2Pressure1: "", f2Pressure2: ""), Rota(f1Name: "", f2Name: "", time0: "", time1: "", time2: "", f1Pressure0: "", f1Pressure1: "", f1Pressure2: "", f2Pressure0: "", f2Pressure1: "", f2Pressure2: ""), Rota(f1Name: "", f2Name: "", time0: "", time1: "", time2: "", f1Pressure0: "", f1Pressure1: "", f1Pressure2: "", f2Pressure0: "", f2Pressure1: "", f2Pressure2: "")]
    
    
    //    @Published var exitTime: [Double?] = []
    //    @Published var exitTime: [Double?] = [nil]
    
    @Published var exitTime1: Double? = nil
    
    
    let minimalPressure: Int = 70
    
    let rota1: Int = 0
    let rota2: Int = 1
    
    
    func calculateExitTime() {
        
        // convertion:
        
//        let doubleRotas = rotas.map { Double($0) ?? 0}
        
        let rota1 = rotas[0]
        let time0R1 = Double(rota1.time0) ?? 0
        let time1R1 = Double(rota1.time1) ?? 0
        let time2R1 = Double(rota1.time2) ?? 0
        
        let pressure0F1 = Double(rota1.f1Pressure0) ?? 0
        let pressure1F1 = Double(rota1.f1Pressure1) ?? 0
        let pressure2F1 = Double(rota1.f1Pressure2) ?? 0
        
        let pressure0F2 = Double(rota1.f2Pressure0) ?? 0
        let pressure1F2 = Double(rota1.f2Pressure1) ?? 0
        let pressure2F2 = Double(rota1.f2Pressure2) ?? 0
    
        
        // calculation:
        
        let timeInterval1 = (time1R1 - time0R1) * 100
        let timeInterval2 = (time2R1 - time1R1) * 100
        //let timeInterval20 = dTime2[rota1] - dTime0[rota1]
        
        //fireman1
        
        
        let pressureLeft0F1 = pressure0F1 - 70
        let pressureLeft1F1 = pressure1F1 - 70
        //let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1F1 = pressure0F1 - pressure1F1
        let pressureUsed2F1 = pressure1F1 - pressure2F1
        
        let entireTime1F1 = pressureLeft0F1 / pressureUsed1F1 * timeInterval1
        let entireTime2F1 = pressureLeft1F1 / pressureUsed2F1 * timeInterval2
        
        let leftTime1F1 = entireTime1F1 - timeInterval1
        let leftTime2F1 = entireTime2F1 - timeInterval2
        
        print(leftTime1F1)
        print(leftTime2F1)
        
        //fireman2
        let pressureLeft0F2 = pressure0F2 - 70
        let pressureLeft1F2 = pressure1F2 - 70
        //let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1F2 = pressure0F2 - pressure1F2
        let pressureUsed2F2 = pressure1F2 - pressure2F2
        
        let entireTime1F2 = pressureLeft0F2 / pressureUsed1F2 * timeInterval1
        let entireTime2F2 = pressureLeft1F2 / pressureUsed2F2 * timeInterval2
        
        let leftTime1F2 = entireTime1F2 - timeInterval1
        let leftTime2F2 = entireTime2F2 - timeInterval2
        
        print(leftTime1F2)
        print(leftTime2F2)
        
        
        guard time2R1 == 0 else {
            if leftTime2F1 > leftTime2F2 {
                exitTime1 = leftTime2F2
            } else {
                exitTime1 = leftTime2F1
            }
            return
        }
        
        
        if leftTime1F1 > leftTime1F2 {
            exitTime1 = leftTime1F2
        } else {
            exitTime1 = leftTime1F1
        }
    }
}
