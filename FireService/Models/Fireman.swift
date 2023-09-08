//
//  Fireman.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation


struct Rota: Identifiable, Codable {
    
    var id = UUID().uuidString
    
    let number: Int
    
    var f1Name: String
    var f2Name: String
    var f3Name: String
    var f4Name: String
    
    var time: [Date]? //start time?
    
    var f1Pressures: [String]
    var f2Pressures: [String]
    var f3Pressures: [String]
    var f4Pressures: [String]
    
//    var startTime: Date? (added because of chatGPT)
    
    var timeToLeave: TimeInterval?
    var exitDate: Date?
    var remainingTime: TimeInterval?
    var duration: TimeInterval?
    
    var doubleF1Pressures: [Double] {
        return f1Pressures.compactMap(Double.init)
    }
    
    var doubleF2Pressures: [Double] {
        return f2Pressures.compactMap(Double.init)
    }
    
    var doubleF3Pressures: [Double] {
        return f3Pressures.compactMap(Double.init)
    }
    
    var doubleF4Pressures: [Double] {
        return f4Pressures.compactMap(Double.init)
    }
    
    func doublePressures(forFireman index: Int, _ measurement: Int) -> Double {
            switch index {
            case 0:
                return doubleF1Pressures[measurement]
            case 1:
                return doubleF2Pressures[measurement]
            case 2:
                return doubleF3Pressures[measurement]
            case 3:
                return doubleF4Pressures[measurement]
            default:
                return 0.0
            }
        }
    
    init(number: Int, f1Name: String = "", f2Name: String = "", f3Name: String = "", f4Name: String = "", f1Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""], f2Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""], f3Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""], f4Pressures: [String] = ["", "", "", "", "", "", "", "", "", "", ""]) {
        self.number = number
        self.f1Name = f1Name
        self.f2Name = f2Name
        self.f3Name = f3Name
        self.f4Name = f4Name
        self.f1Pressures = f1Pressures
        self.f2Pressures = f2Pressures
        self.f3Pressures = f3Pressures
        self.f4Pressures = f4Pressures
    }
}



//struct TimerRota {
//    let number: Int
//    var duration: TimeInterval?
//    var remainingTime: TimeInterval?
//    var exitDate: Date?
//    var time: [Date]? //start time?
//
//    init(number: Int) {
//        self.number = number
//    }
//}


import Combine


final class TimerViewModel: ObservableObject {
    
    @Published var timerRotas: [Rota]
    
    let measurementsNumber: Int = 11 //10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        let timerRotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.timerRotas = timerRotas
    }
    
    func endAction(forRota: Int) {
        //        endButtonActive[forRota] = false
        self.timerRotas[forRota].remainingTime = (self.timerRotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
        self.timerRotas[forRota].duration = Date().timeIntervalSince1970 - (self.timerRotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
        NotificationManager.instance.cancelExitNotification(forRota: forRota)
        NotificationManager.instance.cancelFirstMeasurementNotification(forRota: forRota)
    }
    

    
    func handleFirstMeasurement(forRota: Int, forMeasurement: Int) {
        self.timerRotas[forRota].time = Array(repeating: Date(), count: measurementsNumber+2)
        hideKeyboard()
        timer
            .sink { [weak self] _ in
//                print("Timer ticked!")
                guard let self = self else { return }
//                if endButtonActive[forRota] {
                    self.timerRotas[forRota].duration = Date().timeIntervalSince1970 - (self.timerRotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                print(self.timerRotas[forRota].duration)
                    self.timerRotas[forRota].remainingTime = (self.timerRotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
//                }
            }
            .store(in: &cancellables)
        NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: forRota)
        return
    }
}

//    func updateDurationAndRemiaingTime(forRota: Int) {
//        timer
//        .sink { [weak self] _ in
//            DispatchQueue.global(qos: .background).async { // Move to a background queue
//                guard let self = self else { return }
//                var duration: Double = 0
//                var remainingTime: Double = 0
////                if self.endButtonActive[forRota] {
//                    duration = Date().timeIntervalSince1970 - (self.timerRotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
//                    remainingTime = (self.timerRotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
////                }
//
//                DispatchQueue.main.async { // Return to main thread to update UI
//                    self.timerRotas[forRota].duration = duration
//                    self.timerRotas[forRota].remainingTime = remainingTime
//                }
//            }
//        }
//        .store(in: &cancellables)
//    }


//    func handleFirstMeasurement(forRota: Int, forMeasurement: Int) {
//        self.timerRotas[forRota].time = Array(repeating: Date(), count: measurementsNumber+2)
//            hideKeyboard()
//            timer
//                .sink { [weak self] _ in
//                    DispatchQueue.global(qos: .background).async { // Move to a background queue
//                        guard let self = self else { return }
//                        var duration: Double = 0
//                        var remainingTime: Double = 0
////                        if self.vm.endButtonActive[forRota] {
//                        duration = Date().timeIntervalSince1970 - (self.timerRotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
//                        remainingTime = (self.timerRotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
////                        }
//
//                        DispatchQueue.main.async { // Return to main thread to update UI
//                            self.timerRotas[forRota].duration = duration
//                            self.timerRotas[forRota].remainingTime = remainingTime
//                        }
//                    }
//                }
//                .store(in: &cancellables)
//
//            NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: forRota)
//            return
//        }
//}




























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

