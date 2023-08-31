//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


final class CoreViewModel: ObservableObject {
    
    @Published var editData: [[Bool]] = [Array(repeating: false, count: 11), Array(repeating: false, count: 11), Array(repeating: false, count: 11)]
    
    @Published var rotas: [Rota] {
        didSet {
            saveRotasInputs()
        }
    }
    @Published var numberOfFiremens: [Int] {
        didSet {
            saveNumberOfFiremans()
        }
    }
    @Published var startOrCalculateButtonActive: [[Bool]] {
        didSet {
            saveStartOrCalculateButtonActive()
        }
    }
    @Published var endButtonActive: [Bool] {
        didSet {
            saveEndButtonActive()
        }
    }
    @Published var showAlert: Bool = false
    var numberOfRotas: Int = 2 {
        didSet {
            saveNumberOfRotas()
        }
    }
    @Published var minimalPressure : [Double] {
        didSet {
            saveMinimalPressure()
        }
    }
    
    let measurementsNumber: Int = 13 //12 (2 more for: .disabled(!startOrCalculateButtonActive[measurement+2])
    let exitNotificationTime = 300.0
//    let minimalPressure: Double = 50
    var cancellables = Set<AnyCancellable>()
    //var timerCancellable: Cancellable?  // creat array ?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let rotasInputsKey: String = "rotasInputs"
    let numberOfFiremansKey: String = "numberOfFiremans"
    let minimalPressureKey: String = "minimalPressure"
    let endButtonActiveKey: String = "endButtonActive"
    let numberOfRotasKey: String = "numberOfRotas"
    let startOrCalculateButtonActiveKey: String = "startOrCalculateButtonActive"
    
    
    init() {
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
        self.startOrCalculateButtonActive = [Array(repeating: true, count: measurementsNumber), Array(repeating: true, count: measurementsNumber), Array(repeating: true, count: measurementsNumber)]
        self.endButtonActive = Array(repeating: true, count: numberOfRotas+1)
        self.numberOfFiremens = Array(repeating: 1, count: numberOfRotas+1)
        self.minimalPressure = Array(repeating: 50.0, count: 50)
        getNumberOfRotas()
        getNumberOfFiremans()
        getStartOrCalculateButtonActive()
        getEndButtonActive()
        getRotasInputs()
        getMinimalPressure()
    }
    
    func saveNumberOfRotas() {
        if let encodedData = try? JSONEncoder().encode(numberOfRotas) {
            UserDefaults.standard.set(encodedData, forKey: numberOfRotasKey)
        }
    }
    
    func saveRotasInputs() {
        if let encodedData = try? JSONEncoder().encode(rotas) {
            UserDefaults.standard.set(encodedData, forKey: rotasInputsKey)
        }
    }
    
    func saveNumberOfFiremans() {
        if let encodedData = try? JSONEncoder().encode(numberOfFiremens) {
            UserDefaults.standard.set(encodedData, forKey: numberOfFiremansKey)
        }
    }
    
    func saveMinimalPressure() {
        if let encodedData = try? JSONEncoder().encode(minimalPressure) {
            UserDefaults.standard.set(encodedData, forKey: minimalPressureKey)
        }
    }
    
    func saveEndButtonActive() {
        if let encodedData = try? JSONEncoder().encode(endButtonActive) {
            UserDefaults.standard.set(encodedData, forKey: endButtonActiveKey)
        }
    }
    
    func saveStartOrCalculateButtonActive() {
        if let encodedData = try? JSONEncoder().encode(startOrCalculateButtonActive) {
            UserDefaults.standard.set(encodedData, forKey: startOrCalculateButtonActiveKey)
        }
    }
    
    func getNumberOfRotas() {
        guard
            let data = UserDefaults.standard.data(forKey: numberOfRotasKey),
            let savedData = try? JSONDecoder().decode(Int.self, from: data)
        else { return }
        self.numberOfRotas = savedData
    }
    
    func getRotasInputs() {
        guard
            let data = UserDefaults.standard.data(forKey: rotasInputsKey),
            let savedData = try? JSONDecoder().decode([Rota].self, from: data)
        else { return }
        self.rotas = savedData
    }
    
    func getNumberOfFiremans() {
        guard
            let data = UserDefaults.standard.data(forKey: numberOfFiremansKey),
            let savedData = try? JSONDecoder().decode([Int].self, from: data)
        else { return }
        self.numberOfFiremens = savedData
    }
    
    func getMinimalPressure() {
        guard
            let data = UserDefaults.standard.data(forKey: minimalPressureKey),
            let savedData = try? JSONDecoder().decode([Double].self, from: data)
        else { return }
        self.minimalPressure = savedData
    }
    
    func getEndButtonActive() {
        guard
            let data = UserDefaults.standard.data(forKey: endButtonActiveKey),
            let savedData = try? JSONDecoder().decode([Bool].self, from: data)
        else { return }
        self.endButtonActive = savedData
    }
    
    func getStartOrCalculateButtonActive() {
        guard
            let data = UserDefaults.standard.data(forKey: startOrCalculateButtonActiveKey),
            let savedData = try? JSONDecoder().decode([[Bool]].self, from: data)
        else { return }
        self.startOrCalculateButtonActive = savedData
    }
    
    func addRota() {
        numberOfRotas += 1
        self.rotas.append(Rota(number: numberOfRotas))
        self.startOrCalculateButtonActive.append(Array(repeating: true, count: measurementsNumber))
        self.endButtonActive.append(true)
        self.numberOfFiremens.append(1)
    }
    
    func addFireman(forRota: Int) {
        numberOfFiremens[forRota] += 1
    }
    
    func endAction(forRota: Int) {
        endButtonActive[forRota] = false
        self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
        self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
        NotificationManager.instance.cancelExitNotification(forRota: forRota)
        NotificationManager.instance.cancelFirstMeasurementNotification(forRota: forRota)
    }
    
    func reset() {
        timer.upstream.connect().cancel()
        self.numberOfRotas = 2
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
        self.startOrCalculateButtonActive = [Array(repeating: true, count: measurementsNumber), Array(repeating: true, count: measurementsNumber), Array(repeating: true, count: measurementsNumber)]
        self.endButtonActive = Array(repeating: true, count:  numberOfRotas+1)
        self.numberOfFiremens = Array(repeating: 1, count: numberOfRotas+1)
        self.minimalPressure = Array(repeating: 50.0, count: 50)
        NotificationManager.instance.cancelAllNotifications()
    }
    
    func updateDurationAndRemiaingTime(forRota: Int) {
        timer
        .sink { [weak self] _ in
            guard let self = self else { return }
            //                    self.rotas[forRota].duration += 1
            if endButtonActive[forRota] {
                self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
            }
        }
        .store(in: &cancellables)
    }
    
    func startActionOrCalculateExitTime(forRota: Int, forMeasurement: Int) {
        
        var rota = rotas[forRota]
        
        //checking if all required pressure textfields are filled
        guard rota.f1Pressures[forMeasurement] != "" && rota.f2Pressures[forMeasurement] != "" else {
            showAlert = true
            HapticManager.notifiaction(type: .error)
            return
        }
        
        if numberOfFiremens[forRota] == 2 {
            guard rota.f3Pressures[forMeasurement] != "" else {
                showAlert = true
                HapticManager.notifiaction(type: .error)
                return
            }
        } else if numberOfFiremens[forRota] == 3 {
            guard rota.f3Pressures[forMeasurement] != "" && rota.f4Pressures[forMeasurement] != "" else {
                showAlert = true
                HapticManager.notifiaction(type: .error)
                return
            }
        }
        
        //for the first measurement (start timer and save start time)
        guard forMeasurement != 0 else {
            self.rotas[forRota].time = Array(repeating: Date(), count: measurementsNumber)
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
            hideKeyboard()
            timer
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    //                    self.rotas[forRota].duration += 1
                    if endButtonActive[forRota] {
                        self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                        self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                    }
                }
                .store(in: &cancellables)
            NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: forRota)
            return
        }
        
            self.rotas[forRota].time?[forMeasurement] = Date()
        
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
            NotificationManager.instance.cancelExitNotification(forRota: forRota)
            hideKeyboard()
        
        var timeInterval: TimeInterval {
            return self.rotas[forRota].time?[forMeasurement].timeIntervalSince(self.rotas[forRota].time?[forMeasurement-1] ?? Date()) ?? 0
        }
        
        // calculation:
        
        //fireman1
        let initialPressureF1 = rota.doubleF1Pressures[forMeasurement-1] - minimalPressure[forRota]
        let pressureUsedF1 = rota.doubleF1Pressures[forMeasurement-1] - rota.doubleF1Pressures[forMeasurement]
        let entireTimeOnActionF1 = initialPressureF1 / pressureUsedF1 * timeInterval
        let timeToLeaveF1 = entireTimeOnActionF1 - timeInterval
        
        
        //fireman2
        
        let initialPressureF2 = rota.doubleF2Pressures[forMeasurement-1] - minimalPressure[forRota]
        let pressureUsedF2 = rota.doubleF2Pressures[forMeasurement-1] - rota.doubleF2Pressures[forMeasurement]
        let entireTimeOnActionF2 = initialPressureF2 / pressureUsedF2 * timeInterval
        let timeToLeaveF2 = entireTimeOnActionF2 - timeInterval
        
        let timesToLeave2: [Double] = [timeToLeaveF1, timeToLeaveF2]
        rota.timeToLeave = timesToLeave2.min()
        
        //fireman3
        
        if numberOfFiremens[forRota] == 2 {
            let initialPressureF3 = rota.doubleF3Pressures[forMeasurement-1] - minimalPressure[forRota]
            let pressureUsedF3 = rota.doubleF3Pressures[forMeasurement-1] - rota.doubleF3Pressures[forMeasurement]
            let entireTimeOnActionF3 = initialPressureF3 / pressureUsedF3 * timeInterval
            let timeToLeaveF3 = entireTimeOnActionF3 - timeInterval
            
            let timesToLeave3: [Double] = [timeToLeaveF1, timeToLeaveF2, timeToLeaveF3]
            rota.timeToLeave = timesToLeave3.min()
            
        } else if numberOfFiremens[forRota] == 3 {
            //fireman3
            let initialPressureF3 = rota.doubleF3Pressures[forMeasurement-1] - minimalPressure[forRota]
            let pressureUsedF3 = rota.doubleF3Pressures[forMeasurement-1] - rota.doubleF3Pressures[forMeasurement]
            let entireTimeOnActionF3 = initialPressureF3 / pressureUsedF3 * timeInterval
            let timeToLeaveF3 = entireTimeOnActionF3 - timeInterval
            //fireman4
            let initialPressureF4 = rota.doubleF4Pressures[forMeasurement-1] - minimalPressure[forRota]
            let pressureUsedF4 = rota.doubleF4Pressures[forMeasurement-1] - rota.doubleF4Pressures[forMeasurement]
            let entireTimeOnActionF4 = initialPressureF4 / pressureUsedF4 * timeInterval
            let timeToLeaveF4 = entireTimeOnActionF4 - timeInterval
            
            let timesToLeave4: [Double] = [timeToLeaveF1, timeToLeaveF2, timeToLeaveF3, timeToLeaveF4]
            rota.timeToLeave = timesToLeave4.min()
        }
        
        
        if !(0.001...12600).contains(rota.timeToLeave ?? 0) {
            showAlert = true
            HapticManager.notifiaction(type: .error)
            self.startOrCalculateButtonActive[forRota][forMeasurement] = true
            return
        } else {
            if let timeToLeave = rota.timeToLeave {
                self.rotas[forRota].timeToLeave = timeToLeave
                self.rotas[forRota].exitDate = Date().addingTimeInterval(timeToLeave)
                if timeToLeave > exitNotificationTime {
                    let leaveNotificationTime = timeToLeave - exitNotificationTime
                    NotificationManager.instance.scheduleExitNotification(time: leaveNotificationTime, forRota: forRota)
                }
            }
        }
    }
    
    
    
    func startActionOrCalculateExitTime2(forRota: Int, forMeasurement: Int, previousTime: Date) {
        
        var rota = rotas[forRota]
        
        //checking if all required pressure textfields are not filled
        guard rota.f1Pressures[forMeasurement] != "" && rota.f2Pressures[forMeasurement] != "" else {
            showAlert = true
            HapticManager.notifiaction(type: .error)
            return
        }
        
        if numberOfFiremens[forRota] == 2 {
            guard rota.f3Pressures[forMeasurement] != "" else {
                showAlert = true
                HapticManager.notifiaction(type: .error)
                return
            }
        } else if numberOfFiremens[forRota] == 3 {
            guard rota.f3Pressures[forMeasurement] != "" && rota.f4Pressures[forMeasurement] != "" else {
                showAlert = true
                HapticManager.notifiaction(type: .error)
                return
            }
        }
        
        //for the first measurement (start timer and save start time)
        guard forMeasurement != 0 else {
            self.rotas[forRota].time = Array(repeating: Date(), count: measurementsNumber)
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
            hideKeyboard()
            timer
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    //                    self.rotas[forRota].duration += 1
                    if endButtonActive[forRota] {
                        self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                        self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                    }
                }
                .store(in: &cancellables)
            NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: forRota)
            return
        }
        
        //save time
            self.rotas[forRota].time?[forMeasurement] = previousTime
        
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
            NotificationManager.instance.cancelExitNotification(forRota: forRota)
            hideKeyboard()
        
        var timeInterval: TimeInterval {
            return self.rotas[forRota].time?[forMeasurement].timeIntervalSince(self.rotas[forRota].time?[forMeasurement-1] ?? Date()) ?? 0
        }
        
        var timeInterval2: TimeInterval {
            return Date().timeIntervalSince(self.rotas[forRota].time?[forMeasurement] ?? Date())
        }
        
        print(timeInterval)
        print(timeInterval2)
        
        //calculation:
        
        //fireman1
        let initialPressureF1 = rota.doubleF1Pressures[forMeasurement-1] - minimalPressure[forRota]
        let pressureUsedF1 = rota.doubleF1Pressures[forMeasurement-1] - rota.doubleF1Pressures[forMeasurement]
        let entireTimeOnActionF1 = initialPressureF1 / pressureUsedF1 * timeInterval
        let timeToLeaveF1 = entireTimeOnActionF1 - timeInterval - timeInterval2
        
        
        //fireman2
        
        let initialPressureF2 = rota.doubleF2Pressures[forMeasurement-1] - minimalPressure[forRota]
        let pressureUsedF2 = rota.doubleF2Pressures[forMeasurement-1] - rota.doubleF2Pressures[forMeasurement]
        let entireTimeOnActionF2 = initialPressureF2 / pressureUsedF2 * timeInterval
        let timeToLeaveF2 = entireTimeOnActionF2 - timeInterval - timeInterval2
        
        let timesToLeave2: [Double] = [timeToLeaveF1, timeToLeaveF2]
        rota.timeToLeave = timesToLeave2.min()
        
        //fireman3
        
        if numberOfFiremens[forRota] == 2 {
            let initialPressureF3 = rota.doubleF3Pressures[forMeasurement-1] - minimalPressure[forRota]
            let pressureUsedF3 = rota.doubleF3Pressures[forMeasurement-1] - rota.doubleF3Pressures[forMeasurement]
            let entireTimeOnActionF3 = initialPressureF3 / pressureUsedF3 * timeInterval
            let timeToLeaveF3 = entireTimeOnActionF3 - timeInterval - timeInterval2
            
            let timesToLeave3: [Double] = [timeToLeaveF1, timeToLeaveF2, timeToLeaveF3]
            rota.timeToLeave = timesToLeave3.min()
            
        } else if numberOfFiremens[forRota] == 3 {
            //fireman3
            let initialPressureF3 = rota.doubleF3Pressures[forMeasurement-1] - minimalPressure[forRota]
            let pressureUsedF3 = rota.doubleF3Pressures[forMeasurement-1] - rota.doubleF3Pressures[forMeasurement]
            let entireTimeOnActionF3 = initialPressureF3 / pressureUsedF3 * timeInterval
            let timeToLeaveF3 = entireTimeOnActionF3 - timeInterval - timeInterval2
            //fireman4
            let initialPressureF4 = rota.doubleF4Pressures[forMeasurement-1] - minimalPressure[forRota]
            let pressureUsedF4 = rota.doubleF4Pressures[forMeasurement-1] - rota.doubleF4Pressures[forMeasurement]
            let entireTimeOnActionF4 = initialPressureF4 / pressureUsedF4 * timeInterval
            let timeToLeaveF4 = entireTimeOnActionF4 - timeInterval - timeInterval2
            
            let timesToLeave4: [Double] = [timeToLeaveF1, timeToLeaveF2, timeToLeaveF3, timeToLeaveF4]
            rota.timeToLeave = timesToLeave4.min()
        }
        
        
        if !(0.001...12600).contains(rota.timeToLeave ?? 0) {
            showAlert = true
            HapticManager.notifiaction(type: .error)
            self.startOrCalculateButtonActive[forRota][forMeasurement] = true
            return
        } else {
            if let timeToLeave = rota.timeToLeave {
                self.rotas[forRota].timeToLeave = timeToLeave
                self.rotas[forRota].exitDate = Date().addingTimeInterval(timeToLeave)
                if timeToLeave > exitNotificationTime {
                    let leaveNotificationTime = timeToLeave - exitNotificationTime
                    NotificationManager.instance.scheduleExitNotification(time: leaveNotificationTime, forRota: forRota)
                }
            }
        }
    }
}



































//    func subtractRota() {
////        timer.upstream.connect().cancel()
//        numberOfRotas -= 1
//        self.rotas.removeLast()
//        self.startOrCalculateButtonActive.removeLast()
//        self.endButtonActive.removeLast()
//        self.numberOfFiremens.removeLast()
//    }





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
