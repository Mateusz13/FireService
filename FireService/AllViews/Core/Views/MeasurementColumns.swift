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
    
    var body: some View {
        VStack {
            Text("POMIAR \(measurement)")
            TextField("BAR", text: $rota.f1Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($rota.f1Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement])
                .disabled(startOrCalculateButtonActive[measurement-1])
            TextField("BAR", text: $rota.f2Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($rota.f2Pressures[measurement])
                .disabled(!startOrCalculateButtonActive[measurement])
                .disabled(startOrCalculateButtonActive[measurement-1])
            if numberOfFiremens > 1 {
                TextField("BAR", text: $rota.f3Pressures[measurement])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($rota.f3Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement])
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if numberOfFiremens > 2 {
                TextField("BAR", text: $rota.f4Pressures[measurement])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($rota.f4Pressures[measurement])
                    .disabled(!startOrCalculateButtonActive[measurement])
                    .disabled(startOrCalculateButtonActive[measurement-1])
            }
            if startOrCalculateButtonActive[measurement] == false {
                Text(rota.time?[measurement].getFormattedDateToHHmm() ?? "error")
                    .frame(height: 33)
                    .foregroundColor(.secondary)
            } else {
                Button {
                    vm.startActionOrCalculateExitTime(forRota: rota.number, forMeasurement: measurement)
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

//struct measurementColumns_Previews: PreviewProvider {
//    static var previews: some View {
//        MeasurementColumns(rotaNumber: 0, measurement: 1)
//            .environmentObject(CoreViewModel())
//    }
//}
