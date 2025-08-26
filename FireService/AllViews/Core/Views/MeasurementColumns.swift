//
//  MeasurementColumns.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 02/04/2023.
//

import SwiftUI

// MARK: - Constants
private struct MeasurementConstants {
    static let minButtonHeight: CGFloat = 33
    static let barPlaceholder = "BAR"
    static let calculateButtonText = "Oblicz"
    static let errorText = "error"
    
    struct Text {
        static func measurementTitle(for measurement: Int) -> String {
            return "POMIAR \(measurement)"
        }
        
        static func editConfirmationTitle(for measurement: Int) -> String {
            return "Edytować pomiar \(measurement)?"
        }
        
        static let confirmText = "Tak"
        static let cancelText = "Nie"
    }
}

struct MeasurementColumns: View {
    
    // MARK: - Properties
    let measurement: Int
    @EnvironmentObject private var vm: CoreViewModel
    @State private var editDataAlert: Bool = false
    
    // MARK: - Bindings
    @Binding var rota: Rota
    @Binding var startOrCalculateButtonActive: [Bool]
    @Binding var numberOfFiremans: Int
    @Binding var endButtonActive: Bool
    @Binding var editData: [Bool]
    
    // MARK: - Body
    var body: some View {
        VStack {
            measurementHeaderButton
            pressureFields
            actionButton
        }
    }
}

// MARK: - View Components
private extension MeasurementColumns {
    
    var measurementHeaderButton: some View {
        Button {
            editDataAlert = true
        } label: {
            Text(MeasurementConstants.Text.measurementTitle(for: measurement))
                .alert(
                    MeasurementConstants.Text.editConfirmationTitle(for: measurement),
                    isPresented: $editDataAlert
                ) {
                    Button(MeasurementConstants.Text.confirmText, role: .destructive) {
                        handleEditDataConfirmation()
                    }
                    Button(MeasurementConstants.Text.cancelText, role: .cancel) { }
                }
        }
        .disabled(isHeaderButtonDisabled)
    }
    
    var pressureFields: some View {
        VStack {
            if measurement < rota.f1Pressures.count {
                TextField(MeasurementConstants.barPlaceholder, text: $rota.f1Pressures[measurement])
                    .numbersOnly($rota.f1Pressures[measurement])
                    .disabled(isPressureFieldDisabled)
            }
            
            if measurement < rota.f2Pressures.count {
                TextField(MeasurementConstants.barPlaceholder, text: $rota.f2Pressures[measurement])
                    .numbersOnly($rota.f2Pressures[measurement])
                    .disabled(isPressureFieldDisabled)
            }
            
            if numberOfFiremans > 1 && measurement < rota.f3Pressures.count {
                TextField(MeasurementConstants.barPlaceholder, text: $rota.f3Pressures[measurement])
                    .numbersOnly($rota.f3Pressures[measurement])
                    .disabled(isPressureFieldDisabled)
            }
            
            if numberOfFiremans > 2 && measurement < rota.f4Pressures.count {
                TextField(MeasurementConstants.barPlaceholder, text: $rota.f4Pressures[measurement])
                    .numbersOnly($rota.f4Pressures[measurement])
                    .disabled(isPressureFieldDisabled)
            }
        }
    }
    
    @ViewBuilder
    var actionButton: some View {
        if safeBoolAccess(startOrCalculateButtonActive, index: measurement) {
            calculateButton
        } else if isInEditMode {
            recalculateButton
        } else {
            timeDisplayView
        }
    }
    
    var calculateButton: some View {
        Button {
            handleCalculateAction()
        } label: {
            Text(MeasurementConstants.calculateButtonText)
        }
        .disabled(!endButtonActive || !allFieldsFilled)
        .buttonStyle(.borderedProminent)
    }
    
    var recalculateButton: some View {
        Button {
            handleRecalculateAction()
        } label: {
            Text(MeasurementConstants.calculateButtonText)
        }
        .disabled(!endButtonActive || !allFieldsFilled)
        .buttonStyle(.borderedProminent)
        .foregroundColor(.red)
    }
    
    var timeDisplayView: some View {
        Text(formattedTime)
            .frame(minHeight: MeasurementConstants.minButtonHeight)
            .foregroundColor(.secondary)
    }
}

// MARK: - Computed Properties
private extension MeasurementColumns {
    
    var isHeaderButtonDisabled: Bool {
        safeBoolAccess(startOrCalculateButtonActive, index: measurement) ||
        !safeBoolAccess(startOrCalculateButtonActive, index: measurement + 2) ||
        !endButtonActive
    }
    
    var isPressureFieldDisabled: Bool {
        let canEdit = safeBoolAccess(startOrCalculateButtonActive, index: measurement) ||
                     safeBoolAccess(editData, index: measurement)
        let previousActive = safeBoolAccess(startOrCalculateButtonActive, index: measurement - 1)
        
        return !canEdit || previousActive
    }
    
    var isInEditMode: Bool {
        safeBoolAccess(editData, index: measurement) ||
        safeBoolAccess(editData, index: measurement - 1)
    }
    
    var allFieldsFilled: Bool {
        let f1Filled = measurement < rota.f1Pressures.count && !rota.f1Pressures[measurement].isEmpty
        let f2Filled = measurement < rota.f2Pressures.count && !rota.f2Pressures[measurement].isEmpty
        
        var allFilled = f1Filled && f2Filled
        
        if numberOfFiremans > 1 {
            let f3Filled = measurement < rota.f3Pressures.count && !rota.f3Pressures[measurement].isEmpty
            allFilled = allFilled && f3Filled
        }
        
        if numberOfFiremans > 2 {
            let f4Filled = measurement < rota.f4Pressures.count && !rota.f4Pressures[measurement].isEmpty
            allFilled = allFilled && f4Filled
        }
        
        return allFilled
    }
    
    var formattedTime: String {
        guard let time = rota.time, measurement < time.count else {
            return MeasurementConstants.errorText
        }
        return time[measurement].getFormattedDateToHHmm()
    }
}

// MARK: - Helper Methods
private extension MeasurementColumns {
    
    func safeBoolAccess(_ array: [Bool], index: Int, defaultValue: Bool = false) -> Bool {
        guard index >= 0 && index < array.count else { return defaultValue }
        return array[index]
    }
    
    func handleEditDataConfirmation() {
        guard measurement < editData.count else { return }
        editData[measurement] = true
    }
    
    func handleCalculateAction() {
        vm.startActionOrCalculateExitTime(forRota: rota.number, forMeasurement: measurement)
    }
    
    func handleRecalculateAction() {
        let previousTime = rota.time?[safe: measurement] ?? Date()
        let success = vm.recalculateExitTime(
            forRota: rota.number,
            forMeasurement: measurement,
            previousTime: previousTime
        )
        
        if success {
            handleSuccessfulRecalculation()
        }
    }
    
    func handleSuccessfulRecalculation() {
        guard measurement < editData.count else { return }
        editData[measurement] = false
        
        let nextMeasurement = measurement + 1
        if nextMeasurement < startOrCalculateButtonActive.count &&
           nextMeasurement < editData.count &&
           !startOrCalculateButtonActive[nextMeasurement] {
            editData[nextMeasurement] = true
        }
    }
}

// MARK: - Array Safe Access Extension
private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview
struct MeasurementColumns_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementColumns(
            measurement: 1,
            rota: .constant(Rota(number: 0)),
            startOrCalculateButtonActive: .constant(Array(repeating: true, count: 11)),
            numberOfFiremans: .constant(1),
            endButtonActive: .constant(true),
            editData: .constant(Array(repeating: false, count: 11))
        )
        .environmentObject(CoreViewModel())
    }
}
