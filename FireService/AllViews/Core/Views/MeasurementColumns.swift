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
    
    @State private var editData: Bool = false
    
    var body: some View {
        VStack {
            Button {
                editData = true
            } label: {
                Text("POMIAR \(measurement)")
                    .foregroundColor(.black)
            }
            TextField("BAR", text: $rota.f1Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($rota.f1Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement] && !editData)
                .disabled(startOrCalculateButtonActive[measurement-1])
            TextField("BAR", text: $rota.f2Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($rota.f2Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement] && !editData)
                .disabled(startOrCalculateButtonActive[measurement-1])
            if numberOfFiremens > 1 {
                TextField("BAR", text: $rota.f3Pressures[measurement])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($rota.f3Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement] && !editData)
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if numberOfFiremens > 2 {
                TextField("BAR", text: $rota.f4Pressures[measurement])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($rota.f4Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement] && !editData)
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if !startOrCalculateButtonActive[measurement] && !editData {
                Text(rota.time?[measurement].getFormattedDateToHHmm() ?? "error")
                    .frame(height: 33)
                    .foregroundColor(.secondary)
            } else if editData {
                Button {
                    vm.startActionOrCalculateExitTime2(forRota: rota.number, forMeasurement: measurement, previousTime: rota.time?[measurement] ?? Date())
                    editData = false
                } label: {
                    Text("Oblicz")
                }
                .disabled(!endButtonActive)
                //                .frame(height: 33)
                .buttonStyle(.borderedProminent)
                
            } else {
                Button {
                    vm.startActionOrCalculateExitTime(forRota: rota.number, forMeasurement: measurement)
                    editData = false
                } label: {
                    Text("Oblicz")
                }
                .disabled(!endButtonActive)
                //                .frame(height: 33)
                .buttonStyle(.borderedProminent)
                
            }
        }
    }
}

struct measurementColumns_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementColumns(measurement: 1, rota: .constant(Rota(number: 0)), startOrCalculateButtonActive: .constant(Array(repeating: true, count: 11)), numberOfFiremens: .constant(1), endButtonActive: .constant(true))            .environmentObject(CoreViewModel())
    }
}
