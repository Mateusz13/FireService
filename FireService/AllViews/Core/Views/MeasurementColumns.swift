//
//  MeasurementColumns.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 02/04/2023.
//

import SwiftUI

struct MeasurementColumns: View {
    
//  let rotaNumber: Int
    let measurement: Int
    
    @EnvironmentObject private var vm: CoreViewModel
    
    @Binding var rota: Rota
    @Binding var startOrCalculateButtonActive: [Bool]
    @Binding var numberOfFiremens: Int
    @Binding var endButtonActive: Bool
    @Binding var editData: [Bool]
    
    @State private var editDataAlert: Bool = false
    
    
    var body: some View {
        VStack {
                Button {
                    editDataAlert = true
                } label: {
                    Text("POMIAR \(measurement)")
    //                    .foregroundColor(.black)
                        .alert("Edytować dane?", isPresented: $editDataAlert) {
                            Button("Tak", role: .destructive) { editData[measurement] = true }
                            Button("Nie", role: .cancel) { }
                        }
                }
                .disabled(startOrCalculateButtonActive[measurement])
//                .disabled(measurement < 9 ? !startOrCalculateButtonActive[measurement+2] : false)
                .disabled(!startOrCalculateButtonActive[measurement+2])
                .disabled(!endButtonActive)
            TextField("BAR", text: $rota.f1Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($rota.f1Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                .disabled(startOrCalculateButtonActive[measurement-1])
            TextField("BAR", text: $rota.f2Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($rota.f2Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                .disabled(startOrCalculateButtonActive[measurement-1])
            if numberOfFiremens > 1 {
                TextField("BAR", text: $rota.f3Pressures[measurement])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($rota.f3Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if numberOfFiremens > 2 {
                TextField("BAR", text: $rota.f4Pressures[measurement])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($rota.f4Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement] && !editData[measurement])
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if startOrCalculateButtonActive[measurement] {
                Button {
                    vm.startActionOrCalculateExitTime(forRota: rota.number, forMeasurement: measurement)
//                    editData2 = false
                } label: {
                    Text("Oblicz")
                }
                .disabled(!endButtonActive)
                //                .frame(height: 33)
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
                //                .frame(height: 33)
                .buttonStyle(.borderedProminent)
                .foregroundColor(.red)
            } else {
                Text(rota.time?[measurement].getFormattedDateToHHmm() ?? "error")
                    .frame(height: 33)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct measurementColumns_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementColumns(measurement: 1, rota: .constant(Rota(number: 0)), startOrCalculateButtonActive: .constant(Array(repeating: true, count: 11)), numberOfFiremens: .constant(1), endButtonActive: .constant(true), editData: .constant(Array(repeating: false, count: 11)))
            .environmentObject(CoreViewModel())
    }
}
