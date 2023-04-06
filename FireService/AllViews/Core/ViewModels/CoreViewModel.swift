//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


final class CoreViewModel: ObservableObject {
    
    @Published var rotas: [Rota]
    
    @Published var startOrCalculateButtonActive: [[Bool]]
    @Published var showAlert: Bool = false
    let measurementsNumber: Int = 10+1
    
    var cancellables = Set<AnyCancellable>()
    //    var timerCancellable: Cancellable?  // creat array ?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let minimalPressure: Double = 50
    
    init() {
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
        //assing 100 at the begging or append in 'next' step ?
        self.startOrCalculateButtonActive = [Array(repeating: true, count: measurementsNumber), Array(repeating: true, count: measurementsNumber), Array(repeating: true, count: measurementsNumber)]
    }
    
    func startActionOrCalculateExitTime(forRota: Int, forMeasurement: Int) {
        
        var rota = rotas[forRota]
        
        guard rota.f1Pressures[forMeasurement] != "" && rota.f2Pressures[forMeasurement] != "" else {
            showAlert = true
            return
        }
        
        guard forMeasurement != 0 else {
            self.rotas[forRota].time = Array(repeating: Date(), count: measurementsNumber)
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
            hideKeyboard()
            timer
                .sink { [weak self] _ in
                    guard let self = self else { return }
//                    self.rotas[forRota].duration += 1
                    
                    self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                    
                    
                        self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                    
                    
                }
                .store(in: &cancellables)
            NotificationManager.instance.scheduleMeasurement1Notification()
            return
        }
        
        self.rotas[forRota].time?[forMeasurement] = Date()
        self.startOrCalculateButtonActive[forRota][forMeasurement] = false
        NotificationManager.instance.cancelExitNotification(forRota: forRota)
        hideKeyboard()
        
        
        
        if rota.f1Pressures[forMeasurement] == "" || rota.f2Pressures[forMeasurement] == "" {
            showAlert = true
            return
        } else {
            self.rotas[forRota].time?[forMeasurement] = Date()
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
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
            rota.timeToLeave = timeToLeaveF2
        } else {
            rota.timeToLeave = timeToLeaveF1
        }
        
        if !(0.001...3600).contains(rota.timeToLeave ?? 0) {
            showAlert = true
            self.startOrCalculateButtonActive[forRota][forMeasurement] = true
            return
        } else {
            if let timeToLeave = rota.timeToLeave {
                self.rotas[forRota].timeToLeave = timeToLeave
                self.rotas[forRota].exitDate = Date().addingTimeInterval(timeToLeave)
                if timeToLeave > 30 {
                    let leaveNotificationTime = timeToLeave - 30.0
                    NotificationManager.instance.scheduleExitNotification(time: leaveNotificationTime, forRota: forRota)
                }
            }
        }
    }
}









































//    @Published var startButtonActive: [Bool]
//    self.startButtonActive = Array(repeating: true, count: 2)

//    func startAction(forRota: Int) {
//
//        let rota = rotas[forRota]
//
//        if rota.f1Pressures[0] == "" || rota.f2Pressures[0] == "" {
//            showAlert = true
//        } else {
//
//            self.rotas[forRota].time = Array(repeating: Date(), count: 3)
            
            //self.rotas[forRota].time?[0] = Date()
            //self.startButtonActive = Array(repeating: true, count: 10)
            
//            self.startButtonActive[forRota] = false
//            hideKeyboard()
//        }
        
//        timer
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                self.rotas[forRota].duration += 1
//            }
//            .store(in: &cancellables)
        //should we cancal the timer in ceratain condition?
//    }
    
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
//                rota.timeToLeave = leftTime2F2
//            } else {
//                rota.exitDate = leftTime2F1
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



//if forMeasurement == 1 {
//    timer
//        .sink { [weak self] _ in
//            guard let self = self else { return }
            
//                        guard self.rotas[forRota].timeToLeave != nil else {
//                            return
//                        }
//                        if self.rotas[forRota].timeToLeave ?? 2 > 1 {
//                            self.rotas[forRota].timeToLeave! -= 1
            
//                            self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
            
//                        } else {
                // should we cancal the timer in ceratain condition?
                //                             self.timer.upstream.connect().cancel()
                //                             self.timerCancellable?[forRota].cancel()
//                        }
//        }
//        .store(in: &cancellables)
//}
