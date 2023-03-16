//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


class CoreViewModel: ObservableObject {
    
    
    @Published var rotas: [Rota] = [Rota(number: 0), Rota(number: 1)]
    
    let minimalPressure: Double = 50
    
    //    init() {
    //       rotas = [Rota()]
    //    }
    
    
    func calculateExitTime(forRota: Int) {
        
        var rota = rotas[forRota]
        // calculation:

        //fireman1
        let pressureLeft0F1 = rota.doubleF1Pressure0 - minimalPressure
        let pressureLeft1F1 = rota.doubleF1Pressure1 - minimalPressure
        //let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1F1 = rota.doubleF1Pressure0 - rota.doubleF1Pressure1
        let pressureUsed2F1 = rota.doubleF1Pressure1 - rota.doubleF1Pressure2
        
        
        let entireTime1F1 = pressureLeft0F1 / pressureUsed1F1 * rota.timeInterval1
        let entireTime2F1 = pressureLeft1F1 / pressureUsed2F1 * rota.timeInterval2
        
        let leftTime1F1 = entireTime1F1 - rota.timeInterval1
        let leftTime2F1 = entireTime2F1 - rota.timeInterval2
        
        
        //fireman2
        let pressureLeft0F2 = rota.doubleF2Pressure0 - minimalPressure
        let pressureLeft1F2 = rota.doubleF2Pressure1 - minimalPressure
        //let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1F2 = rota.doubleF2Pressure0 - rota.doubleF2Pressure1
        let pressureUsed2F2 = rota.doubleF2Pressure1 - rota.doubleF2Pressure2
        
        
        let entireTime1F2 = pressureLeft0F2 / pressureUsed1F2 * rota.timeInterval1
        let entireTime2F2 = pressureLeft1F2 / pressureUsed2F2 * rota.timeInterval2
        
        let leftTime1F2 = entireTime1F2 - rota.timeInterval1
        let leftTime2F2 = entireTime2F2 - rota.timeInterval2
        
//        print(leftTime1F1)
//        print(leftTime1F2)
//        print(leftTime2F1)
//        print(leftTime2F2)
//        print(rota.timeInterval1)
//        print(rota.timeInterval2)
        
        guard rota.doubleF2Pressure2 == 0 else {
            if leftTime2F1 > leftTime2F2 {
                rota.exitTime = leftTime2F2
            } else {
                rota.exitTime = leftTime2F1
            }
            self.rotas[forRota].exitTime = rota.exitTime
            return
        }
        
        if leftTime1F1 > leftTime1F2 {
            rota.exitTime = leftTime1F2
        } else {
            rota.exitTime = leftTime1F1
        }
            
        self.rotas[forRota].exitTime = rota.exitTime
    }
}
