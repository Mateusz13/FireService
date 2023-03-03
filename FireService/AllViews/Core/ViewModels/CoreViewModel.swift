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
    
    let minimalPressure: Int = 70
    
    //    init() {
    //       rotas = [Rota()]
    //    }
    
    
    func calculateExitTime(forRota: Int) {
        
        var rota = rotas[forRota]
        
        
        // calculation:
        let timeInterval1 = (rota.doubleTime1 - rota.doubleTime0) * 100
        let timeInterval2 = (rota.doubleTime2 - rota.doubleTime1) * 100
        //let timeInterval20 = dTime2[rota1] - dTime0[rota1]
        
        
        //fireman1
        let pressureLeft0F1 = rota.doubleF1Pressure0 - 70
        let pressureLeft1F1 = rota.doubleF1Pressure1 - 70
        //let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1F1 = rota.doubleF1Pressure0 - rota.doubleF1Pressure1
        let pressureUsed2F1 = rota.doubleF1Pressure1 - rota.doubleF1Pressure2
        
        
        let entireTime1F1 = pressureLeft0F1 / pressureUsed1F1 * timeInterval1
        let entireTime2F1 = pressureLeft1F1 / pressureUsed2F1 * timeInterval2
        
        let leftTime1F1 = entireTime1F1 - timeInterval1
        let leftTime2F1 = entireTime2F1 - timeInterval2
        
        
        //fireman2
        let pressureLeft0F2 = rota.doubleF2Pressure0 - 70
        let pressureLeft1F2 = rota.doubleF2Pressure1 - 70
        //let pressureLeft2 = iPressure2[fireman1] - 70
        
        let pressureUsed1F2 = rota.doubleF2Pressure0 - rota.doubleF2Pressure1
        let pressureUsed2F2 = rota.doubleF2Pressure1 - rota.doubleF2Pressure2
        
        
        let entireTime1F2 = pressureLeft0F2 / pressureUsed1F2 * timeInterval1
        let entireTime2F2 = pressureLeft1F2 / pressureUsed2F2 * timeInterval2
        
        let leftTime1F2 = entireTime1F2 - timeInterval1
        let leftTime2F2 = entireTime2F2 - timeInterval2
        
        
        guard rota.doubleTime2 == 0 else {
            if leftTime2F1 > leftTime2F2 {
                rota.exitTime = leftTime2F2
            } else {
                rota.exitTime = leftTime2F1
            }
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
