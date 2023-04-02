//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


class CoreViewModel: ObservableObject {
    
    @Published var rotas: [Rota]
    
    @Published var startButtonActive: [Bool]
    @Published var calculateButtonActive: [[Bool]]
    @Published var showAlert: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    //    var timerCancellable: Cancellable?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let minimalPressure: Double = 50
    
    init() {
        let rotas = [Rota(number: 0), Rota(number: 1)]
        self.rotas = rotas
        //assing 100 at the begging or append in 'next' step ?
        self.startButtonActive = Array(repeating: true, count: 2)
        self.calculateButtonActive = [Array(repeating: true, count: 2), Array(repeating: true, count: 2)]
    }
    
    
    func startAction(forRota: Int) {
        
        let rota = rotas[forRota]
        
        if rota.f1Pressures[0] == "" || rota.f2Pressures[0] == "" {
            showAlert = true
        } else {
            
            self.rotas[forRota].time = Array(repeating: Date(), count: 3)
            
            //self.rotas[forRota].time?[0] = Date()
            //self.startButtonActive = Array(repeating: true, count: 10)
            
            self.startButtonActive[forRota] = false
            hideKeyboard()
        }
        
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.rotas[forRota].duration += 1
            }
            .store(in: &cancellables)
        //should we cancal the timer in ceratain condition?
        
    }
    
    
    func calculateExitTimeX(forRota: Int, forMeasurement: Int) {
        
        //        self.timerCancellable?.cancel()
        //        if forMeasurement != 1 {
        //            timer.upstream.connect().cancel()
        //        }
        
        
        var rota = rotas[forRota]
        
        
        guard rota.f1Pressures[forMeasurement] != "" && rota.f2Pressures[forMeasurement] != "" else {
            showAlert = true
            return
        }
        
        self.rotas[forRota].time?[forMeasurement] = Date()
        self.calculateButtonActive[forRota][forMeasurement-1] = false
        hideKeyboard()
        
        
        
        if rota.f1Pressures[forMeasurement] == "" || rota.f2Pressures[forMeasurement] == "" {
            showAlert = true
        } else {
            self.rotas[forRota].time?[forMeasurement] = Date()
            self.calculateButtonActive[forRota][forMeasurement-1] = false
            hideKeyboard()
        }
        
        var timeInterval: TimeInterval {
            return self.rotas[forRota].time?[forMeasurement].timeIntervalSince(self.rotas[forRota].time?[forMeasurement-1] ?? Date()) ?? 0
        }
        
        // calculation:
        print(timeInterval)
        
        //fireman1
        let initialPressureF1 = rota.doubleF1Pressures[forMeasurement-1] - minimalPressure
        let pressureUsedF1 = rota.doubleF1Pressures[forMeasurement-1] - rota.doubleF1Pressures[forMeasurement]
        let entireTimeOnActionF1 = initialPressureF1 / pressureUsedF1 * timeInterval
        let timeToLeaveF1 = entireTimeOnActionF1 - timeInterval
        
        
        //fireman2
        
        let initialPressureF2 = rota.doubleF2Pressures[forMeasurement-1] - minimalPressure
        let pressureUsedF2 = rota.doubleF2Pressures[forMeasurement-1] - rota.doubleF2Pressures[forMeasurement]
        let entireTimeOnActionF2 = initialPressureF2 / pressureUsedF2 * timeInterval
        let timeToLeaveF2 = entireTimeOnActionF2 - timeInterval
        
        
        
        if timeToLeaveF1 > timeToLeaveF2 {
            rota.exitTime = timeToLeaveF2
        } else {
            rota.exitTime = timeToLeaveF1
        }
        
        if !(0.001...3600).contains(rota.exitTime ?? 0) {
            showAlert = true
            self.calculateButtonActive[forRota][forMeasurement-1] = true
        } else {
            self.rotas[forRota].exitTime = rota.exitTime
            if forMeasurement == 1 {
                timer
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        guard self.rotas[forRota].exitTime != nil else {
                            return
                        }
                        if self.rotas[forRota].exitTime ?? 0 > 0 {
                            self.rotas[forRota].exitTime! -= 1
                        } else {
                            //timer.upstream.connect().cancel()
                            //self.timerCancellable?.cancel()
                            // should we cancal the timer in ceratain condition?
                        }
                    }
                    .store(in: &cancellables)
            }
        }
    }
}
    
//    func calculateExitTime(forRota: Int) {
//
//
//        var rota = rotas[forRota]
//        // calculation:
//
//        //fireman1
//        let pressureLeft0F1 = rota.doubleF1Pressure0 - minimalPressure
//        let pressureLeft1F1 = rota.doubleF1Pressure1 - minimalPressure
//        //let pressureLeft2 = iPressure2[fireman1] - 70
//
//        let pressureUsed1F1 = rota.doubleF1Pressure0 - rota.doubleF1Pressure1
//        let pressureUsed2F1 = rota.doubleF1Pressure1 - rota.doubleF1Pressure2
//
//
//        let entireTime1F1 = pressureLeft0F1 / pressureUsed1F1 * rota.timeInterval1
//        let entireTime2F1 = pressureLeft1F1 / pressureUsed2F1 * rota.timeInterval2
//
//        let leftTime1F1 = entireTime1F1 - rota.timeInterval1
//        let leftTime2F1 = entireTime2F1 - rota.timeInterval2
//
//
//        //fireman2
//        let pressureLeft0F2 = rota.doubleF2Pressure0 - minimalPressure
//        let pressureLeft1F2 = rota.doubleF2Pressure1 - minimalPressure
//        //let pressureLeft2 = iPressure2[fireman1] - 70
//
//        let pressureUsed1F2 = rota.doubleF2Pressure0 - rota.doubleF2Pressure1
//        let pressureUsed2F2 = rota.doubleF2Pressure1 - rota.doubleF2Pressure2
//
//
//        let entireTime1F2 = pressureLeft0F2 / pressureUsed1F2 * rota.timeInterval1
//        let entireTime2F2 = pressureLeft1F2 / pressureUsed2F2 * rota.timeInterval2
//
//        let leftTime1F2 = entireTime1F2 - rota.timeInterval1
//        let leftTime2F2 = entireTime2F2 - rota.timeInterval2
//
//
//        guard rota.doubleF2Pressure2 == 0 else {
//            if leftTime2F1 > leftTime2F2 {
//                rota.exitTime = leftTime2F2
//            } else {
//                rota.exitTime = leftTime2F1
//            }
//            self.rotas[forRota].exitTime = rota.exitTime
//            return
//        }
//
//        if leftTime1F1 > leftTime1F2 {
//            rota.exitTime = leftTime1F2
//        } else {
//            rota.exitTime = leftTime1F1
//        }
//
//        self.rotas[forRota].exitTime = rota.exitTime
//
//        timer
//                .sink { [weak self] _ in
//                    guard let self = self else { return }
//
//                    if self.rotas[forRota].exitTime! > 0 {
//                        self.rotas[forRota].exitTime! -= 1
//                    } else {
//                        //self.timerCancellable?.cancel()
//                        // should we cancal the timer in ceratain condition?
//                    }
//                }
//                .store(in: &cancellables)
//    }
