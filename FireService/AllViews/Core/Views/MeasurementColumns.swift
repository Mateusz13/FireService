//
//  MeasurementColumns.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 02/04/2023.
//

import SwiftUI

struct MeasurementColumns: View {
    
    let measurement: Int
    @EnvironmentObject private var vm: CoreViewModel
    //    @ObservedObject var timersVM: TimersRowViewModel
    @Binding var rota: Rota
    @Binding var startOrCalculateButtonActive: [Bool]
    @Binding var numberOfFiremans: Int
    @Binding var endButtonActive: Bool
    @Binding var editData: [Bool]
    @State private var editDataAlert: Bool = false
    
    var body: some View {
        VStack {
            Button {
                editDataAlert = true
            } label: {
                Text("POMIAR \(measurement)")
                    .alert("Edytować pomiar \(measurement)?", isPresented: $editDataAlert) {
                        Button("Tak", role: .destructive) { editData[measurement] = true }
                        Button("Nie", role: .cancel) { }
                    }
            }
            .disabled(startOrCalculateButtonActive[measurement])
            .disabled(!startOrCalculateButtonActive[measurement+2])
            .disabled(!endButtonActive)
            TextField("BAR", text: $rota.f1Pressures[measurement])
                .numbersOnly($rota.f1Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                .disabled(startOrCalculateButtonActive[measurement-1])
            TextField("BAR", text: $rota.f2Pressures[measurement])
                .numbersOnly($rota.f2Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                .disabled(startOrCalculateButtonActive[measurement-1])
            if numberOfFiremans > 1 {
                TextField("BAR", text: $rota.f3Pressures[measurement])
                    .numbersOnly($rota.f3Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if numberOfFiremans > 2 {
                TextField("BAR", text: $rota.f4Pressures[measurement])
                    .numbersOnly($rota.f4Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if startOrCalculateButtonActive[measurement] {
                Button {
                    vm.startActionOrCalculateExitTime(forRota: rota.number, forMeasurement: measurement)
                    //                    timersVM.updateDurationAndRemainingTime(forRota: rota.number)
                } label: {
                    Text("Oblicz")
                }
                .disabled(!endButtonActive)
                .buttonStyle(.borderedProminent)
            } else if editData[measurement] || editData[measurement-1] {
                Button {
                    vm.recalculateExitTime(forRota: rota.number, forMeasurement: measurement, previousTime: rota.time?[measurement] ?? Date())
                    editData[measurement] = false
                    if !startOrCalculateButtonActive[measurement+1] {
                        editData[measurement+1] = true
                    }
                } label: {
                    Text("Oblicz")
                }
                .disabled(!endButtonActive)
                .buttonStyle(.borderedProminent)
                .foregroundColor(.red)
            } else {
                Text(rota.time?[measurement].getFormattedDateToHHmm() ?? "error")
                    .frame(minHeight: 33)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct measurementColumns_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementColumns(measurement: 1, rota: .constant(Rota(number: 0)), startOrCalculateButtonActive: .constant(Array(repeating: true, count: 11)), numberOfFiremans: .constant(1), endButtonActive: .constant(true), editData: .constant(Array(repeating: false, count: 11)))
            .environmentObject(CoreViewModel())
    }
}
