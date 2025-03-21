//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine

final class CoreViewModel: ObservableObject {
    @Published var resetting = false
    @Published var rotas: [Rota] {
        didSet {
            saveRotasInputs()
        }
    }
    @Published var numberOfFiremans: [Int] {
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
    var numberOfRotas: Int = 2 {
        didSet {
            saveNumberOfRotas()
        }
    }
    
    private let measurementsNumber: Int = 11
    private let maxRotasNumber: Int = 16
    private let exitNotificationTime = 300.0
    private let validTimeToLeaveRange = (0.001...12600)
    private let initialMinimalPressure = 50.0
    
    init() {
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
        self.startOrCalculateButtonActive = Array(repeating: Array(repeating: true, count: measurementsNumber+2), count: numberOfRotas+1)//(2 more for: .disabled(!startOrCalculateButtonActive[measurement+2])
        self.endButtonActive = Array(repeating: true, count: numberOfRotas+1)
        self.numberOfFiremans = Array(repeating: 1, count: numberOfRotas+1)
        self.minimalPressure = Array(repeating: initialMinimalPressure, count: maxRotasNumber)
        self.editData = Array(repeating: Array(repeating: false, count: measurementsNumber), count: numberOfRotas+1)
        getNumberOfRotas()
        getNumberOfFiremans()
        getStartOrCalculateButtonActive()
        getEndButtonActive()
        getRotasInputs()
        getMinimalPressure()
        getEditData()
        print(rotas)
    }
    
    func addRota() {
        numberOfRotas += 1
        self.rotas.append(Rota(number: numberOfRotas))
        self.startOrCalculateButtonActive.append(Array(repeating: true, count: measurementsNumber+2))
        self.editData.append(Array(repeating: false, count: measurementsNumber))
        self.endButtonActive.append(true)
        self.numberOfFiremans.append(1)
        self.minimalPressure.append(initialMinimalPressure)
    }
    
    func addFireman(forRota: Int) {
        numberOfFiremans[forRota] += 1
    }
    
    func endAction(forRota: Int) {
        endButtonActive[forRota] = false
        self.rotas[forRota].exitTime = Date()
        self.rotas[forRota].remainingTimeAtEnd = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
        self.rotas[forRota].totalDuration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
        NotificationManager.instance.cancelExitNotification(forRota: forRota)
        NotificationManager.instance.cancelFirstMeasurementNotification(forRota: forRota)
    }
    
    func reset() {
        resetting = true
        self.numberOfRotas = 2
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
        self.startOrCalculateButtonActive = Array(repeating: Array(repeating: true, count: measurementsNumber+2), count: numberOfRotas+1)
        self.endButtonActive = Array(repeating: true, count:  numberOfRotas+1)
        self.numberOfFiremans = Array(repeating: 1, count: numberOfRotas+1)
        self.minimalPressure = Array(repeating: initialMinimalPressure, count: maxRotasNumber)
        self.editData = Array(repeating: Array(repeating: false, count: measurementsNumber), count: numberOfRotas+1)
        NotificationManager.instance.cancelAllNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetting = false
        }
    }
    
    func startActionOrCalculateExitTime(forRota: Int, forMeasurement: Int) {
        let rota = rotas[forRota]
        //checking if all required pressure textfields are filled
        if !validatePressures(forRota: forRota, forMeasurement: forMeasurement) {
            showError()
            return
        }
        // Handle first measurement
        if forMeasurement == 0 {
            handleFirstMeasurement(forRota: forRota, forMeasurement: forMeasurement)
            return
        }
        // Handle subsequent measurements
        _ = handleSubsequentMeasurements(forRota: forRota, forMeasurement: forMeasurement, rota: rota, time: Date())
    }
    
    func recalculateExitTime(forRota: Int, forMeasurement: Int, previousTime: Date) -> Bool {
        let rota = rotas[forRota]
        //checking if all required pressure textfields are filled
        if !validatePressures(forRota: forRota, forMeasurement: forMeasurement) {
            showError()
            return false
        }
        return handleSubsequentMeasurements(forRota: forRota, forMeasurement: forMeasurement, rota: rota, time: previousTime, isRecalculating: true)
    }
    
    private func handleFirstMeasurement(forRota: Int, forMeasurement: Int) {
        self.rotas[forRota].time = Array(repeating: Date(), count: measurementsNumber+2)
        self.startOrCalculateButtonActive[forRota][forMeasurement] = false
        hideKeyboard()
        NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: forRota)
    }
    
    private func handleSubsequentMeasurements(forRota: Int, forMeasurement: Int, rota: Rota, time: Date, isRecalculating: Bool = false) -> Bool {
        //set time:
        self.rotas[forRota].time?[forMeasurement] = time
        
        if !isRecalculating {
            self.startOrCalculateButtonActive[forRota][forMeasurement] = false
        }
        
        NotificationManager.instance.cancelExitNotification(forRota: forRota)
        hideKeyboard()
        
        let timeInterval = calculateTimeInterval(forRota: forRota, forMeasurement: forMeasurement)
        let timeInterval2 = calculateTimeInterval2(forRota: forRota, forMeasurement: forMeasurement)
        let timesToLeave = calculateTimesToLeave(rota: rota, forRota: forRota, forMeasurement: forMeasurement, timeInterval: timeInterval, timeInterval2: timeInterval2)
        let minimumTimeToLeave = timesToLeave.min() ?? 0
        
        if validTimeToLeaveRange.contains(minimumTimeToLeave) {
            handleValidTimeToLeave(minimumTimeToLeave, forRota: forRota)
            return true
        } else {
            showError()
            if !isRecalculating {
                self.startOrCalculateButtonActive[forRota][forMeasurement] = true
            }
            return false
        }
    }
    
    // Helper Functions
    private func calculateTimeInterval(forRota: Int, forMeasurement: Int) -> TimeInterval {
        return self.rotas[forRota].time?[forMeasurement].timeIntervalSince(self.rotas[forRota].time?[forMeasurement-1] ?? Date()) ?? 0
    }
    
    private func calculateTimeInterval2(forRota: Int, forMeasurement: Int) -> TimeInterval {
        return Date().timeIntervalSince(self.rotas[forRota].time?[forMeasurement] ?? Date())
    }
    
    private func calculateTimesToLeave(rota: Rota, forRota: Int, forMeasurement: Int, timeInterval: TimeInterval, timeInterval2: TimeInterval) -> [Double] {
        var timesToLeave = [Double]()
        
        for index in 0..<numberOfFiremans[forRota]+1 {
            let initialPressure = rota.doublePressures(forFireman: index, forMeasurement-1) - minimalPressure[forRota]
            let pressureUsed = rota.doublePressures(forFireman: index, forMeasurement-1) - rota.doublePressures(forFireman: index, forMeasurement)
            let entireTimeOnAction = initialPressure / pressureUsed * timeInterval
            let timeToLeave = entireTimeOnAction - timeInterval - timeInterval2
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
    
    private func validatePressures(forRota: Int, forMeasurement: Int) -> Bool {
        let rota = rotas[forRota]
        let pressures = [rota.f1Pressures, rota.f2Pressures, rota.f3Pressures, rota.f4Pressures]
        return !pressures.prefix(numberOfFiremans[forRota]+1).contains { $0[forMeasurement].isEmpty }
    }
    
    private func showError() {
        showAlert = true
        HapticManager.notifiaction(type: .error)
    }
    
    func timeToLeaveTitle(forRota: Int) -> String {
//        guard resetting == false else { return "" }
        if minimalPressure[forRota] == 0.0 {
            return "Do 0 BAR(!): "
        } else {
            return "Do gwizdka: "
        }
    }
    
    //SAVE AND GET DATA FROM USER DEFAULTS:
    let rotasInputsKey: String = "rotasInputs"
    let numberOfFiremansKey: String = "numberOfFiremans"
    let minimalPressureKey: String = "minimalPressure"
    let endButtonActiveKey: String = "endButtonActive"
    let numberOfRotasKey: String = "numberOfRotas"
    let startOrCalculateButtonActiveKey: String = "startOrCalculateButtonActive"
    let editDataKey: String = "editData"
    
    func saveNumberOfRotas() {
        UserDefaultsManager.shared.save(numberOfRotas, forKey: numberOfRotasKey)
    }
    
    func saveRotasInputs() {
        UserDefaultsManager.shared.save(rotas, forKey: rotasInputsKey)
    }
    
    func saveNumberOfFiremans() {
        UserDefaultsManager.shared.save(numberOfFiremans, forKey: numberOfFiremansKey)
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
        if let storedNumberOfRotas = UserDefaultsManager.shared.retrieve(Int.self, forKey: numberOfRotasKey) {
            self.numberOfRotas = storedNumberOfRotas
        }
    }
    
    func getRotasInputs() {
        if let storedRotas = UserDefaultsManager.shared.retrieve([Rota].self, forKey: rotasInputsKey) {
            self.rotas = storedRotas
        }
    }
    
    func getNumberOfFiremans() {
        if let storedNumberOfFiremans = UserDefaultsManager.shared.retrieve([Int].self, forKey: numberOfFiremansKey) {
            self.numberOfFiremans = storedNumberOfFiremans
        }
    }
    
    func getMinimalPressure() {
        if let storedMinimalPressure = UserDefaultsManager.shared.retrieve([Double].self, forKey: minimalPressureKey) {
            self.minimalPressure = storedMinimalPressure
        }
    }
    
    func getEndButtonActive() {
        if let storedEndButtonActive = UserDefaultsManager.shared.retrieve([Bool].self, forKey: endButtonActiveKey) {
            self.endButtonActive = storedEndButtonActive
        }
    }
    
    func getStartOrCalculateButtonActive() {
        if let storedStartOrCalculateButtonActive = UserDefaultsManager.shared.retrieve([[Bool]].self, forKey: startOrCalculateButtonActiveKey) {
            self.startOrCalculateButtonActive = storedStartOrCalculateButtonActive
        }
    }
    
    func getEditData() {
        if let storedEditData = UserDefaultsManager.shared.retrieve([[Bool]].self, forKey: editDataKey) {
            self.editData = storedEditData
        }
    }
}
