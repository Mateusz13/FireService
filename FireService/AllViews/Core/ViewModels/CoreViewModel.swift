//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation

// MARK: - Constants
private struct Constants {
    static let measurementsNumber: Int = 11
    static let maxRotasNumber: Int = 16
    static let exitNotificationTime: TimeInterval = 300.0
    static let validTimeToLeaveRange = 0.001...12600.0
    static let initialMinimalPressure: Double = 50.0
    static let defaultNumberOfRotas: Int = 2
    static let maxNumberOfRotas: Int = 15
    static let maxFiremansPerRota: Int = 3
}

// MARK: - UserDefaults Keys
private struct UserDefaultsKeys {
    static let rotasInputs = "rotasInputs"
    static let numberOfFiremans = "numberOfFiremans"
    static let minimalPressure = "minimalPressure"
    static let endButtonActive = "endButtonActive"
    static let numberOfRotas = "numberOfRotas"
    static let startOrCalculateButtonActive = "startOrCalculateButtonActive"
    static let editData = "editData"
}

final class CoreViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var resetting = false
    @Published var rotas: [Rota] {
        didSet { saveRotasInputs() }
    }
    @Published var numberOfFiremans: [Int] {
        didSet { saveNumberOfFiremans() }
    }
    @Published var startOrCalculateButtonActive: [[Bool]] {
        didSet { saveStartOrCalculateButtonActive() }
    }
    @Published var endButtonActive: [Bool] {
        didSet { saveEndButtonActive() }
    }
    @Published var showAlert: Bool = false
    @Published var minimalPressure: [Double] {
        didSet { saveMinimalPressure() }
    }
    @Published var editData: [[Bool]] {
        didSet { saveEditData() }
    }
    
    // MARK: - Private Properties
    var numberOfRotas: Int = Constants.defaultNumberOfRotas {
        didSet { saveNumberOfRotas() }
    }
    
    // MARK: - Initialization
    init() {
        let initialRotas = Self.createInitialRotas()
        self.rotas = initialRotas
        self.startOrCalculateButtonActive = Self.createInitialButtonStates(for: Constants.defaultNumberOfRotas)
        self.endButtonActive = Array(repeating: true, count: Constants.defaultNumberOfRotas + 1)
        self.numberOfFiremans = Array(repeating: 1, count: Constants.defaultNumberOfRotas + 1)
        self.minimalPressure = Array(repeating: Constants.initialMinimalPressure, count: Constants.maxRotasNumber)
        self.editData = Self.createInitialEditData(for: Constants.defaultNumberOfRotas)
        
        loadPersistedData()
        print(rotas)
    }
    
    // MARK: - Public Methods
    func addRota() {
        guard numberOfRotas < Constants.maxNumberOfRotas else { return }
        
        numberOfRotas += 1
        rotas.append(Rota(number: numberOfRotas))
        startOrCalculateButtonActive.append(Array(repeating: true, count: Constants.measurementsNumber + 2))
        editData.append(Array(repeating: false, count: Constants.measurementsNumber))
        endButtonActive.append(true)
        numberOfFiremans.append(1)
        minimalPressure.append(Constants.initialMinimalPressure)
    }
    
    func addFireman(forRota rotaIndex: Int) {
        guard rotaIndex < numberOfFiremans.count,
              numberOfFiremans[rotaIndex] < Constants.maxFiremansPerRota else { return }
        numberOfFiremans[rotaIndex] += 1
    }
    
    func endAction(forRota rotaIndex: Int) {
        guard rotaIndex < endButtonActive.count && rotaIndex < rotas.count else { return }
        
        endButtonActive[rotaIndex] = false
        let currentTime = Date()
        rotas[rotaIndex].exitTime = currentTime
        rotas[rotaIndex].remainingTimeAtEnd = calculateRemainingTimeAtEnd(for: rotaIndex, currentTime: currentTime)
        rotas[rotaIndex].totalDuration = calculateTotalDuration(for: rotaIndex, currentTime: currentTime)
        
        NotificationManager.instance.cancelExitNotification(forRota: rotaIndex)
        NotificationManager.instance.cancelFirstMeasurementNotification(forRota: rotaIndex)
    }
    
    func reset() {
        resetting = true
        numberOfRotas = Constants.defaultNumberOfRotas
        rotas = Self.createInitialRotas()
        startOrCalculateButtonActive = Self.createInitialButtonStates(for: Constants.defaultNumberOfRotas)
        endButtonActive = Array(repeating: true, count: Constants.defaultNumberOfRotas + 1)
        numberOfFiremans = Array(repeating: 1, count: Constants.defaultNumberOfRotas + 1)
        minimalPressure = Array(repeating: Constants.initialMinimalPressure, count: Constants.maxRotasNumber)
        editData = Self.createInitialEditData(for: Constants.defaultNumberOfRotas)
        
        NotificationManager.instance.cancelAllNotifications()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetting = false
        }
    }
    
    func startActionOrCalculateExitTime(forRota rotaIndex: Int, forMeasurement measurementIndex: Int) {
        guard validatePressures(forRota: rotaIndex, forMeasurement: measurementIndex) else {
            showError()
            return
        }
        
        if measurementIndex == 0 {
            handleFirstMeasurement(forRota: rotaIndex, forMeasurement: measurementIndex)
        } else {
            let rota = rotas[rotaIndex]
            _ = handleSubsequentMeasurements(forRota: rotaIndex, forMeasurement: measurementIndex, rota: rota, time: Date())
        }
    }
    
    func recalculateExitTime(forRota rotaIndex: Int, forMeasurement measurementIndex: Int, previousTime: Date) -> Bool {
        guard validatePressures(forRota: rotaIndex, forMeasurement: measurementIndex) else {
            showError()
            return false
        }
        
        let rota = rotas[rotaIndex]
        return handleSubsequentMeasurements(forRota: rotaIndex, forMeasurement: measurementIndex, rota: rota, time: previousTime, isRecalculating: true)
    }
    
    func timeToLeaveTitle(forRota rotaIndex: Int) -> String {
        guard rotaIndex < minimalPressure.count else { return "" }
        return minimalPressure[rotaIndex] == 0.0 ? "Do 0 BAR(!): " : "Do gwizdka: "
    }
}

// MARK: - Private Helper Methods
private extension CoreViewModel {
    
    static func createInitialRotas() -> [Rota] {
        return [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
    }
    
    static func createInitialButtonStates(for numberOfRotas: Int) -> [[Bool]] {
        return Array(repeating: Array(repeating: true, count: Constants.measurementsNumber + 2), count: numberOfRotas + 1)
    }
    
    static func createInitialEditData(for numberOfRotas: Int) -> [[Bool]] {
        return Array(repeating: Array(repeating: false, count: Constants.measurementsNumber), count: numberOfRotas + 1)
    }
    
    func loadPersistedData() {
        getNumberOfRotas()
        getNumberOfFiremans()
        getStartOrCalculateButtonActive()
        getEndButtonActive()
        getRotasInputs()
        getMinimalPressure()
        getEditData()
    }
    
    func calculateRemainingTimeAtEnd(for rotaIndex: Int, currentTime: Date) -> TimeInterval {
        return (rotas[rotaIndex].exitDate?.timeIntervalSince1970 ?? 0) - currentTime.timeIntervalSince1970
    }
    
    func calculateTotalDuration(for rotaIndex: Int, currentTime: Date) -> TimeInterval {
        return currentTime.timeIntervalSince1970 - (rotas[rotaIndex].time?[0].timeIntervalSince1970 ?? 0)
    }
    
    func handleFirstMeasurement(forRota rotaIndex: Int, forMeasurement measurementIndex: Int) {
        rotas[rotaIndex].time = Array(repeating: Date(), count: Constants.measurementsNumber + 2)
        startOrCalculateButtonActive[rotaIndex][measurementIndex] = false
        hideKeyboard()
        NotificationManager.instance.scheduleFirstMeasurementNotification(forRota: rotaIndex)
    }
    
    func handleSubsequentMeasurements(forRota rotaIndex: Int, forMeasurement measurementIndex: Int, rota: Rota, time: Date, isRecalculating: Bool = false) -> Bool {
        rotas[rotaIndex].time?[measurementIndex] = time
        
        if !isRecalculating {
            startOrCalculateButtonActive[rotaIndex][measurementIndex] = false
        }
        
        NotificationManager.instance.cancelExitNotification(forRota: rotaIndex)
        hideKeyboard()
        
        let calculations = performTimeCalculations(forRota: rotaIndex, forMeasurement: measurementIndex, rota: rota)
        let minimumTimeToLeave = calculations.timesToLeave.min() ?? 0
        
        if Constants.validTimeToLeaveRange.contains(minimumTimeToLeave) {
            handleValidTimeToLeave(minimumTimeToLeave, forRota: rotaIndex)
            return true
        } else {
            showError()
            if !isRecalculating {
                startOrCalculateButtonActive[rotaIndex][measurementIndex] = true
            }
            return false
        }
    }
    
    func performTimeCalculations(forRota rotaIndex: Int, forMeasurement measurementIndex: Int, rota: Rota) -> (timeInterval: TimeInterval, timeInterval2: TimeInterval, timesToLeave: [Double]) {
        let timeInterval = calculateTimeInterval(forRota: rotaIndex, forMeasurement: measurementIndex)
        let timeInterval2 = calculateTimeInterval2(forRota: rotaIndex, forMeasurement: measurementIndex)
        let timesToLeave = calculateTimesToLeave(rota: rota, forRota: rotaIndex, forMeasurement: measurementIndex, timeInterval: timeInterval, timeInterval2: timeInterval2)
        
        return (timeInterval, timeInterval2, timesToLeave)
    }
    
    func calculateTimeInterval(forRota rotaIndex: Int, forMeasurement measurementIndex: Int) -> TimeInterval {
        guard let currentTime = rotas[rotaIndex].time?[measurementIndex],
              let previousTime = rotas[rotaIndex].time?[measurementIndex - 1] else { return 0 }
        return currentTime.timeIntervalSince(previousTime)
    }
    
    func calculateTimeInterval2(forRota rotaIndex: Int, forMeasurement measurementIndex: Int) -> TimeInterval {
        guard let measurementTime = rotas[rotaIndex].time?[measurementIndex] else { return 0 }
        return Date().timeIntervalSince(measurementTime)
    }
    
    func calculateTimesToLeave(rota: Rota, forRota rotaIndex: Int, forMeasurement measurementIndex: Int, timeInterval: TimeInterval, timeInterval2: TimeInterval) -> [Double] {
        var timesToLeave = [Double]()
        
        for index in 0..<(numberOfFiremans[rotaIndex] + 1) {
            let calculation = calculateIndividualTimeToLeave(
                rota: rota,
                firemanIndex: index,
                rotaIndex: rotaIndex,
                measurementIndex: measurementIndex,
                timeInterval: timeInterval,
                timeInterval2: timeInterval2
            )
            timesToLeave.append(calculation)
        }
        
        return timesToLeave
    }
    
    func calculateIndividualTimeToLeave(rota: Rota, firemanIndex: Int, rotaIndex: Int, measurementIndex: Int, timeInterval: TimeInterval, timeInterval2: TimeInterval) -> Double {
        let initialPressure = rota.doublePressures(forFireman: firemanIndex, measurementIndex - 1) - minimalPressure[rotaIndex]
        let pressureUsed = rota.doublePressures(forFireman: firemanIndex, measurementIndex - 1) - rota.doublePressures(forFireman: firemanIndex, measurementIndex)
        
        guard pressureUsed > 0 else { return 0 }
        
        let entireTimeOnAction = initialPressure / pressureUsed * timeInterval
        return entireTimeOnAction - timeInterval - timeInterval2
    }
    
    func handleValidTimeToLeave(_ timeToLeave: Double, forRota rotaIndex: Int) {
        rotas[rotaIndex].timeToLeave = timeToLeave
        rotas[rotaIndex].exitDate = Date().addingTimeInterval(timeToLeave)
        
        if timeToLeave > Constants.exitNotificationTime {
            let leaveNotificationTime = timeToLeave - Constants.exitNotificationTime
            NotificationManager.instance.scheduleExitNotification(
                time: leaveNotificationTime,
                forRota: rotaIndex,
                minimalPressure: minimalPressure[rotaIndex]
            )
        }
    }
    
    func validatePressures(forRota rotaIndex: Int, forMeasurement measurementIndex: Int) -> Bool {
        guard rotaIndex < rotas.count else { return false }
        
        let rota = rotas[rotaIndex]
        let pressures = [rota.f1Pressures, rota.f2Pressures, rota.f3Pressures, rota.f4Pressures]
        let requiredPressures = pressures.prefix(numberOfFiremans[rotaIndex] + 1)
        
        return !requiredPressures.contains { $0[measurementIndex].isEmpty }
    }
    
    func showError() {
        showAlert = true
        HapticManager.notifiaction(type: .error)
    }
}

// MARK: - Persistence Methods
private extension CoreViewModel {
    
    func saveNumberOfRotas() {
        UserDefaultsManager.shared.save(numberOfRotas, forKey: UserDefaultsKeys.numberOfRotas)
    }
    
    func saveRotasInputs() {
        UserDefaultsManager.shared.save(rotas, forKey: UserDefaultsKeys.rotasInputs)
    }
    
    func saveNumberOfFiremans() {
        UserDefaultsManager.shared.save(numberOfFiremans, forKey: UserDefaultsKeys.numberOfFiremans)
    }
    
    func saveMinimalPressure() {
        UserDefaultsManager.shared.save(minimalPressure, forKey: UserDefaultsKeys.minimalPressure)
    }
    
    func saveEndButtonActive() {
        UserDefaultsManager.shared.save(endButtonActive, forKey: UserDefaultsKeys.endButtonActive)
    }
    
    func saveStartOrCalculateButtonActive() {
        UserDefaultsManager.shared.save(startOrCalculateButtonActive, forKey: UserDefaultsKeys.startOrCalculateButtonActive)
    }
    
    func saveEditData() {
        UserDefaultsManager.shared.save(editData, forKey: UserDefaultsKeys.editData)
    }
    
    func getNumberOfRotas() {
        if let storedNumberOfRotas = UserDefaultsManager.shared.retrieve(Int.self, forKey: UserDefaultsKeys.numberOfRotas) {
            self.numberOfRotas = storedNumberOfRotas
        }
    }
    
    func getRotasInputs() {
        if let storedRotas = UserDefaultsManager.shared.retrieve([Rota].self, forKey: UserDefaultsKeys.rotasInputs) {
            self.rotas = storedRotas
        }
    }
    
    func getNumberOfFiremans() {
        if let storedNumberOfFiremans = UserDefaultsManager.shared.retrieve([Int].self, forKey: UserDefaultsKeys.numberOfFiremans) {
            self.numberOfFiremans = storedNumberOfFiremans
        }
    }
    
    func getMinimalPressure() {
        if let storedMinimalPressure = UserDefaultsManager.shared.retrieve([Double].self, forKey: UserDefaultsKeys.minimalPressure) {
            self.minimalPressure = storedMinimalPressure
        }
    }
    
    func getEndButtonActive() {
        if let storedEndButtonActive = UserDefaultsManager.shared.retrieve([Bool].self, forKey: UserDefaultsKeys.endButtonActive) {
            self.endButtonActive = storedEndButtonActive
        }
    }
    
    func getStartOrCalculateButtonActive() {
        if let storedStartOrCalculateButtonActive = UserDefaultsManager.shared.retrieve([[Bool]].self, forKey: UserDefaultsKeys.startOrCalculateButtonActive) {
            self.startOrCalculateButtonActive = storedStartOrCalculateButtonActive
        }
    }
    
    func getEditData() {
        if let storedEditData = UserDefaultsManager.shared.retrieve([[Bool]].self, forKey: UserDefaultsKeys.editData) {
            self.editData = storedEditData
        }
    }
}
