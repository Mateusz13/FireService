//
//  RotaTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI

// MARK: - Constants
private struct RotaTableConstants {
    static let measurementRange = 1...10
    static let padding: CGFloat = 3
    static let cornerRadius: CGFloat = 10
    static let minColumnWidth: CGFloat = 80
    static let minButtonHeight: CGFloat = 34
    static let minTimeDisplayHeight: CGFloat = 33
    static let maxFiremans = 3
    
    // Colors
    static let ritBackgroundColor = Color(hue: 0.01, saturation: 0.63, brightness: 0.94, opacity: 1.00)
    static let defaultBackgroundColor = Color(white: 0.80, opacity: 1.00)
    
    // Text Content
    struct Text {
        static let addFiremanTitle = "Dodać strażaka?"
        static let addFiremanConfirm = "Tak"
        static let addFiremanCancel = "Nie"
        static let removeReserveTitle = "Usunąć rezerwę 50 BAR?!"
        static let removeReserveConfirm = "Tak"
        static let removeReserveCancel = "Nie"
        static let editEntryTitle = "Edytować dane dla wejścia?"
        static let editEntryConfirm = "Tak"
        static let editEntryCancel = "Nie"
        static let entryLabel = "WEJŚCIE"
        static let editButtonLabel = "Edytuj"
        static let startButtonLabel = "Start"
        static let barPlaceholder = "BAR"
        static let errorText = "error"
        
        static func rotaTitle(for number: Int) -> String {
            if number < 3 {
                return "ROTA \(number == 2 ? "RIT" : String(number + 1))"
            } else {
                return "ROTA \(number)"
            }
        }
        
        static func addFiremanMessage(for rotaNumber: Int) -> String {
            if rotaNumber == 2 {
                return "Dodać kolejnego strażaka do Roty RIT?"
            } else if rotaNumber < 2 {
                return "Dodać kolejnego strażaka do Roty \(rotaNumber + 1)?"
            } else {
                return "Dodać kolejnego strażaka do Roty \(rotaNumber)?"
            }
        }
        
        static func nameFieldPlaceholder(for index: Int) -> String {
            return "name\(index + 1)"
        }
    }
}

struct RotaTableView: View {
    
    // MARK: - Environment & State
    @EnvironmentObject private var vm: CoreViewModel
    @State private var addFiremanConfirmationAlert: Bool = false
    @State private var removeTheReserveConfirmationAlert: Bool = false
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
            rotaScrollView
            timersRow
        }
    }
}

// MARK: - View Components
private extension RotaTableView {
    
    var rotaScrollView: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                namesColumn
                entryColumn
                measurementColumns
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding(RotaTableConstants.padding)
        .background(backgroundColorForRota)
        .cornerRadius(RotaTableConstants.cornerRadius)
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
    
    var measurementColumns: some View {
        ForEach(RotaTableConstants.measurementRange, id: \.self) { measurement in
            MeasurementColumns(
                measurement: measurement,
                rota: $rota,
                startOrCalculateButtonActive: $startOrCalculateButtonActive,
                numberOfFiremans: $numberOfFiremans,
                endButtonActive: $endButtonActive,
                editData: $editData
            )
        }
    }
    
    var timersRow: some View {
        TimersRowView(
            timersVM: TimersRowViewModel(coreVM: vm),
            rota: $rota,
            endButtonActive: $endButtonActive,
            startOrCalculateButtonActive: $startOrCalculateButtonActive
        )
    }
    
    var backgroundColorForRota: Color {
        rota.number == 2 ? RotaTableConstants.ritBackgroundColor : RotaTableConstants.defaultBackgroundColor
    }
}

// MARK: - Names Column
private extension RotaTableView {
    
    var namesColumn: some View {
        VStack {
            rotaTitleView
            firemanNameFields
            actionButton
        }
        .frame(minWidth: RotaTableConstants.minColumnWidth)
    }
    
    var rotaTitleView: some View {
        Text(RotaTableConstants.Text.rotaTitle(for: rota.number))
            .bold()
            .underline()
    }
    
    var firemanNameFields: some View {
        VStack {
            TextField(RotaTableConstants.Text.nameFieldPlaceholder(for: 0), text: $rota.f1Name)
            TextField(RotaTableConstants.Text.nameFieldPlaceholder(for: 1), text: $rota.f2Name)
            
            if numberOfFiremans > 1 {
                TextField(RotaTableConstants.Text.nameFieldPlaceholder(for: 2), text: $rota.f3Name)
            }
            
            if numberOfFiremans > 2 {
                TextField(RotaTableConstants.Text.nameFieldPlaceholder(for: 3), text: $rota.f4Name)
            }
        }
    }
    
    @ViewBuilder
    var actionButton: some View {
        if shouldShowAddFiremanButton {
            addFiremanButton
        } else {
            removeReserveButton
        }
    }
    
    var shouldShowAddFiremanButton: Bool {
        safeBoolArrayAccess(startOrCalculateButtonActive, index: 0) && numberOfFiremans != RotaTableConstants.maxFiremans
    }
    
    var addFiremanButton: some View {
        Button {
            addFiremanConfirmationAlert = true
        } label: {
            Label("", systemImage: "plus.circle.fill")
                .font(.title)
        }
        .foregroundColor(.green)
        .frame(minHeight: RotaTableConstants.minButtonHeight)
        .alert(RotaTableConstants.Text.addFiremanTitle, isPresented: $addFiremanConfirmationAlert) {
            Button(RotaTableConstants.Text.addFiremanConfirm) {
                handleAddFireman()
            }
            Button(RotaTableConstants.Text.addFiremanCancel, role: .cancel) { }
        } message: {
            Text(RotaTableConstants.Text.addFiremanMessage(for: rota.number))
        }
    }
    
    var removeReserveButton: some View {
        Button {
            removeTheReserveConfirmationAlert = true
        } label: {
            Label("", systemImage: "person.crop.circle.badge.exclamationmark")
                .font(.title)
        }
        .foregroundColor(reserveButtonColor)
        .frame(minHeight: RotaTableConstants.minButtonHeight)
        .disabled(!endButtonActive)
        .disabled(isReserveDisabled)
        .alert(RotaTableConstants.Text.removeReserveTitle, isPresented: $removeTheReserveConfirmationAlert) {
            Button(RotaTableConstants.Text.removeReserveConfirm, role: .destructive) {
                handleRemoveReserve()
            }
            Button(RotaTableConstants.Text.removeReserveCancel, role: .cancel) { }
        }
    }
    
    var reserveButtonColor: Color {
        isMinimalPressureAtDefault ? .green : .red
    }
    
    var isMinimalPressureAtDefault: Bool {
        safeDoubleArrayAccess(vm.minimalPressure, index: rota.number) == 50.0
    }
    
    var isReserveDisabled: Bool {
        safeDoubleArrayAccess(vm.minimalPressure, index: rota.number) == 0.0
    }
}

// MARK: - Entry Column
private extension RotaTableView {
    
    var entryColumn: some View {
        VStack {
            entryHeaderButton
            pressureFields
            entryActionButton
        }
    }
    
    var entryHeaderButton: some View {
        Button {
            editDataAlert = true
        } label: {
            Text(RotaTableConstants.Text.entryLabel)
        }
        .alert(RotaTableConstants.Text.editEntryTitle, isPresented: $editDataAlert) {
            Button(RotaTableConstants.Text.editEntryConfirm, role: .destructive) {
                handleEditEntry()
            }
            Button(RotaTableConstants.Text.editEntryCancel, role: .cancel) { }
        }
        .disabled(isEntryHeaderDisabled)
    }
    
    var isEntryHeaderDisabled: Bool {
        safeBoolArrayAccess(startOrCalculateButtonActive, index: 0) ||
        !safeBoolArrayAccess(startOrCalculateButtonActive, index: 2) ||
        !endButtonActive
    }
    
    var pressureFields: some View {
        VStack {
            TextField(RotaTableConstants.Text.barPlaceholder, text: $rota.f1Pressures[0])
                .numbersOnly($rota.f1Pressures[0])
                .disabled(isPressureFieldDisabled)
                
            TextField(RotaTableConstants.Text.barPlaceholder, text: $rota.f2Pressures[0])
                .numbersOnly($rota.f2Pressures[0])
                .disabled(isPressureFieldDisabled)
            
            if numberOfFiremans > 1 {
                TextField(RotaTableConstants.Text.barPlaceholder, text: $rota.f3Pressures[0])
                    .numbersOnly($rota.f3Pressures[0])
                    .disabled(isPressureFieldDisabled)
            }
            
            if numberOfFiremans > 2 {
                TextField(RotaTableConstants.Text.barPlaceholder, text: $rota.f4Pressures[0])
                    .numbersOnly($rota.f4Pressures[0])
                    .disabled(isPressureFieldDisabled)
            }
        }
    }
    
    var isPressureFieldDisabled: Bool {
        let startNotActive = !safeBoolArrayAccess(startOrCalculateButtonActive, index: 0)
        let notEditing = !safeBoolArrayAccess(editData, index: 0)
        return startNotActive && notEditing
    }
    
    @ViewBuilder
    var entryActionButton: some View {
        if !safeBoolArrayAccess(startOrCalculateButtonActive, index: 0) && !safeBoolArrayAccess(editData, index: 0) {
            timeDisplayView
        } else if safeBoolArrayAccess(editData, index: 0) {
            editButton
        } else {
            startButton
        }
    }
    
    var timeDisplayView: some View {
        Text(rota.time?[0].getFormattedDateToHHmm() ?? RotaTableConstants.Text.errorText)
            .frame(minHeight: RotaTableConstants.minTimeDisplayHeight)
            .foregroundColor(.secondary)
    }
    
    var editButton: some View {
        Button {
            handleEditButtonAction()
        } label: {
            Text(RotaTableConstants.Text.editButtonLabel)
        }
        .disabled(!endButtonActive)
        .buttonStyle(.borderedProminent)
        .foregroundColor(.red)
    }
    
    var startButton: some View {
        Button {
            handleStartAction()
        } label: {
            Text(RotaTableConstants.Text.startButtonLabel)
        }
        .disabled(!endButtonActive)
        .buttonStyle(.borderedProminent)
        .foregroundColor(.green)
    }
}

// MARK: - Helper Methods
private extension RotaTableView {
    
    func safeArrayAccess<T>(_ array: [T], index: Int) -> T? {
        guard index >= 0 && index < array.count else { return nil }
        return array[index]
    }
    
    func safeBoolArrayAccess(_ array: [Bool], index: Int, defaultValue: Bool = false) -> Bool {
        guard index >= 0 && index < array.count else { return defaultValue }
        return array[index]
    }
    
    func safeDoubleArrayAccess(_ array: [Double], index: Int, defaultValue: Double = 0.0) -> Double {
        guard index >= 0 && index < array.count else { return defaultValue }
        return array[index]
    }
    
    func handleAddFireman() {
        if safeBoolArrayAccess(startOrCalculateButtonActive, index: 0) {
            withAnimation(.easeIn) {
                vm.addFireman(forRota: rota.number)
            }
        }
    }
    
    func handleRemoveReserve() {
        withAnimation(.easeIn) {
            guard rota.number < vm.minimalPressure.count else { return }
            vm.minimalPressure[rota.number] = 0.0
            
            if let lastFalseIndex = startOrCalculateButtonActive.lastIndex(of: false),
               lastFalseIndex > 0 && lastFalseIndex < editData.count {
                editData[lastFalseIndex] = true
            }
        }
    }
    
    func handleEditEntry() {
        if editData.count > 0 {
            editData[0] = true
        }
    }
    
    func handleEditButtonAction() {
        if editData.count > 0 {
            editData[0] = false
        }
        
        if startOrCalculateButtonActive.count > 1 && !safeBoolArrayAccess(startOrCalculateButtonActive, index: 1) && editData.count > 1 {
            editData[1] = true
        }
    }
    
    func handleStartAction() {
        vm.startActionOrCalculateExitTime(forRota: rota.number, forMeasurement: 0)
    }
}

// MARK: - Preview
struct RotaTableView_Previews: PreviewProvider {
    static var previews: some View {
        RotaTableView(
            rota: .constant(Rota(number: 0)),
            startOrCalculateButtonActive: .constant(Array(repeating: true, count: 13)),
            numberOfFiremans: .constant(1),
            endButtonActive: .constant(true),
            editData: .constant(Array(repeating: false, count: 11))
        )
        .environmentObject(CoreViewModel())
    }
}
