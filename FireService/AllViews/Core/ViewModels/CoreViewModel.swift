//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


final class CoreViewModel: ObservableObject {
    
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
    
    @Published var editData: [[Bool]] {
        didSet {
            saveEditData()
        }
    }
    
    let measurementsNumber: Int = 11 //10
    let exitNotificationTime = 300.0
    let validTimeToLeaveRange = (0.001...12600)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var cancellables = Set<AnyCancellable>()
    //var timerCancellable: Cancellable?  // creat array ?
    
    let rotasInputsKey: String = "rotasInputs"
    let numberOfFiremansKey: String = "numberOfFiremans"
    let minimalPressureKey: String = "minimalPressure"
    let endButtonActiveKey: String = "endButtonActive"
    let numberOfRotasKey: String = "numberOfRotas"
    let startOrCalculateButtonActiveKey: String = "startOrCalculateButtonActive"
    let editDataKey: String = "editData"
    
    
    init() {
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
        self.startOrCalculateButtonActive = Array(repeating: Array(repeating: true, count: measurementsNumber+2), count: 3)//(2 more for: .disabled(!startOrCalculateButtonActive[measurement+2])
        self.endButtonActive = Array(repeating: true, count: numberOfRotas+1)
        self.numberOfFiremens = Array(repeating: 1, count: numberOfRotas+1)
        self.minimalPressure = Array(repeating: 50.0, count: measurementsNumber)
        self.editData = Array(repeating: Array(repeating: false, count: measurementsNumber), count: 3)
        getNumberOfRotas()
        getNumberOfFiremans()
        getStartOrCalculateButtonActive()
        getEndButtonActive()
        getRotasInputs()
        getMinimalPressure()
        getEditData()
    }

    
    func saveNumberOfRotas() {
        UserDefaultsManager.shared.save(numberOfRotas, forKey: numberOfRotasKey)
    }
    func saveRotasInputs() {
        UserDefaultsManager.shared.save(rotas, forKey: rotasInputsKey)
    }
    func saveNumberOfFiremans() {
        UserDefaultsManager.shared.save(numberOfFiremens, forKey: numberOfFiremansKey)
    }
    func saveMinimalPressure() {
        UserDefaultsManager.shared.save(minimalPressure, forKey: minimalPressureKey)
    }
    func saveEndButtonActive() {
        UserDefaultsManager.shared.save(endButtonActive, forKey: endButtonActiveKey)
    }
    func saveStartOrCalculateButtonActive() {
        UserDefaultsManager.shared.save(startOrCalculateButtonActive, forKey: startOrCalculateButtonActiveKey)
    }
    func saveEditData() {
        UserDefaultsManager.shared.save(editData, forKey: editDataKey)
    }
    
    func getNumberOfRotas() {
        self.numberOfRotas = UserDefaultsManager.shared.retrieve(Int.self, forKey: numberOfRotasKey) ?? 0
    }
    func getRotasInputs() {
        self.rotas = UserDefaultsManager.shared.retrieve([Rota].self, forKey: rotasInputsKey) ?? []
    }
    func getNumberOfFiremans() {
        self.numberOfFiremens = UserDefaultsManager.shared.retrieve([Int].self, forKey: numberOfFiremansKey) ?? []
    }
    func getMinimalPressure() {
        self.minimalPressure = UserDefaultsManager.shared.retrieve([Double].self, forKey: minimalPressureKey) ?? []
    }
    func getEndButtonActive() {
        self.endButtonActive = UserDefaultsManager.shared.retrieve([Bool].self, forKey: endButtonActiveKey) ?? []
    }
    func getStartOrCalculateButtonActive() {
        self.startOrCalculateButtonActive = UserDefaultsManager.shared.retrieve([[Bool]].self, forKey: startOrCalculateButtonActiveKey) ?? [[]]
    }
    func getEditData() {
        self.editData = UserDefaultsManager.shared.retrieve([[Bool]].self, forKey: editDataKey) ?? [[]]
    }

    
    func addRota() {
        numberOfRotas += 1
        self.rotas.append(Rota(number: numberOfRotas))
        self.startOrCalculateButtonActive.append(Array(repeating: true, count: measurementsNumber+2))
        self.editData.append(Array(repeating: false, count: measurementsNumber))
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
        self.startOrCalculateButtonActive = Array(repeating: Array(repeating: true, count: measurementsNumber+2), count: 3)
        self.endButtonActive = Array(repeating: true, count:  numberOfRotas+1)
        self.numberOfFiremens = Array(repeating: 1, count: numberOfRotas+1)
        self.minimalPressure = Array(repeating: 50.0, count: 50)
        self.editData = Array(repeating: Array(repeating: false, count: measurementsNumber), count: 3)
        NotificationManager.instance.cancelAllNotifications()
    }
    
    func updateDurationAndRemiaingTime(forRota: Int) {
        timer
        .sink { [weak self] _ in
            guard let self = self else { return }
            //self.rotas[forRota].duration += 1
            if endButtonActive[forRota] {
                self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
            }
        }
        .store(in: &cancellables)
    }
    

    func startActionOrCalculateExitTime(forRota: Int, forMeasurement: Int) {
        
        let rota = rotas[forRota]
        
        //checking if all required pressure textfields are filled
        if !validatePressures(forRota: forRota, forMeasurement: forMeasurement) {
            showAlert = true
            HapticManager.notifiaction(type: .error)
            return
        }
        
        // Handle first measurement
        if forMeasurement == 0 {
            handleFirstMeasurement(forRota: forRota, forMeasurement: forMeasurement)
            return
        }
        
        // Handle subsequent measurements
        handleSubsequentMeasurements(forRota: forRota, forMeasurement: forMeasurement, rota: rota)
    }

    
    private func validatePressures(forRota: Int, forMeasurement: Int) -> Bool {
        let rota = rotas[forRota]
        let pressures = [rota.f1Pressures, rota.f2Pressures, rota.f3Pressures, rota.f4Pressures]
        
        return !pressures.prefix(numberOfFiremens[forRota]+1).contains { $0[forMeasurement].isEmpty }
    }



    private func showError() {
        showAlert = true
        HapticManager.notifiaction(type: .error)
    }

    private func handleFirstMeasurement(forRota: Int, forMeasurement: Int) {
        self.rotas[forRota].time = Array(repeating: Date(), count: measurementsNumber+2)
        self.startOrCalculateButtonActive[forRota][forMeasurement] = false
        hideKeyboard()
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                if endButtonActive[forRota] {
                    self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                    self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                }
            }
            .store(in: &cancellables)
        NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: forRota)
        return
    }

    private func handleSubsequentMeasurements(forRota: Int, forMeasurement: Int, rota: Rota) {
        //set time:
        self.rotas[forRota].time?[forMeasurement] = Date()
        self.startOrCalculateButtonActive[forRota][forMeasurement] = false
        NotificationManager.instance.cancelExitNotification(forRota: forRota)
        hideKeyboard()
        
        let timeInterval = calculateTimeInterval(forRota: forRota, forMeasurement: forMeasurement)
        let timesToLeave = calculateTimesToLeave(rota: rota, forRota: forRota, forMeasurement: forMeasurement, timeInterval: timeInterval)
        let minimumTimeToLeave = timesToLeave.min() ?? 0

        if validTimeToLeaveRange.contains(minimumTimeToLeave) {
            handleValidTimeToLeave(minimumTimeToLeave, forRota: forRota)
        } else {
            showAlert = true
            HapticManager.notifiaction(type: .error)
            self.startOrCalculateButtonActive[forRota][forMeasurement] = true
        }
    }
    
    // Helper Functions

    private func calculateTimeInterval(forRota: Int, forMeasurement: Int) -> TimeInterval {
        return self.rotas[forRota].time?[forMeasurement].timeIntervalSince(self.rotas[forRota].time?[forMeasurement-1] ?? Date()) ?? 0
    }

    private func calculateTimesToLeave(rota: Rota, forRota: Int, forMeasurement: Int, timeInterval: TimeInterval) -> [Double] {
        var timesToLeave = [Double]()

        for index in 0..<numberOfFiremens[forRota] {
            let initialPressure = rota.doublePressures(forFireman: index, forMeasurement-1) - minimalPressure[forRota]
            let pressureUsed = rota.doublePressures(forFireman: index, forMeasurement-1) - rota.doublePressures(forFireman: index, forMeasurement)
            let entireTimeOnAction = initialPressure / pressureUsed * timeInterval
            let timeToLeave = entireTimeOnAction - timeInterval
            timesToLeave.append(timeToLeave)
        }

        return timesToLeave
    }

    private func handleValidTimeToLeave(_ timeToLeave: Double, forRota: Int) {
        self.rotas[forRota].timeToLeave = timeToLeave
        self.rotas[forRota].exitDate = Date().addingTimeInterval(timeToLeave)
        if timeToLeave > exitNotificationTime {
            let leaveNotificationTime = timeToLeave - exitNotificationTime
            NotificationManager.instance.scheduleExitNotification(time: leaveNotificationTime, forRota: forRota, minimalPressure: minimalPressure[forRota])
        }
    }



    func recalculateExitTime(forRota: Int, forMeasurement: Int, previousTime: Date) {
        
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
//        guard forMeasurement != 0 else {
//            self.rotas[forRota].time = Array(repeating: Date(), count: measurementsNumber+2)
//            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
//            hideKeyboard()
//            timer
//                .sink { [weak self] _ in
//                    guard let self = self else { return }
//                    //                    self.rotas[forRota].duration += 1
//                    if endButtonActive[forRota] {
//                        self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
//                        self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
//                    }
//                }
//                .store(in: &cancellables)
//            NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: forRota)
//            return
//        }
        
        
        //set time:
            self.rotas[forRota].time?[forMeasurement] = previousTime
        
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
            NotificationManager.instance.cancelExitNotification(forRota: forRota)
        
            hideKeyboard()
        
        var timeInterval: TimeInterval {
            return self.rotas[forRota].time?[forMeasurement].timeIntervalSince(self.rotas[forRota].time?[forMeasurement-1] ?? Date()) ?? 0
        }
        
        //time from now to previous time measurement
        var timeInterval2: TimeInterval {
            return Date().timeIntervalSince(self.rotas[forRota].time?[forMeasurement] ?? Date())
        }
        
//        print(timeInterval)
//        print(timeInterval2)
        
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
        
        
        if !validTimeToLeaveRange.contains(rota.timeToLeave ?? 0) {
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
                    NotificationManager.instance.scheduleExitNotification(time: leaveNotificationTime, forRota: forRota, minimalPressure: minimalPressure[forRota])
                }
            }
        }
    }
    
    func timeToLeaveTitle(forRota: Int) -> String {
        if minimalPressure[forRota] == 0.0 {
            return "Do 0 BAR(!): "
        } else {
            return "Do gwizdka: "
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
