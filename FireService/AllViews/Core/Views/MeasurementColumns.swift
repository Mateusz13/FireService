//
//  MeasurementColumns.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 02/04/2023.
//

import SwiftUI

struct MeasurementColumns: View {
    
    let rotaNumber: Int
    let measurement: Int
    @EnvironmentObject private var vm: CoreViewModel
    
    var body: some View {
        VStack {
            Text("POMIAR \(measurement)")
            TextField("BAR", text: $vm.rotas[rotaNumber].f1Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($vm.rotas[rotaNumber].f1Pressures[measurement])
                .disabled(!vm.startOrCalculateButtonActive[rotaNumber][measurement])
                .disabled(vm.startOrCalculateButtonActive[rotaNumber][measurement-1])
            TextField("BAR", text: $vm.rotas[rotaNumber].f2Pressures[measurement])
            //                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($vm.rotas[rotaNumber].f2Pressures[measurement])
                .disabled(!vm.startOrCalculateButtonActive[rotaNumber][measurement])
                .disabled(vm.startOrCalculateButtonActive[rotaNumber][measurement-1])
            if vm.startOrCalculateButtonActive[rotaNumber][measurement] == false {
                Text(vm.rotas[rotaNumber].time?[measurement].getFormattedDateToHHmm() ?? "error")
                    .frame(height: 33)
                    .foregroundColor(.secondary)
            } else {
                Button {
                    vm.startActionOrCalculateExitTime(forRota: rotaNumber, forMeasurement: measurement)
                } label: {
                    Text("Oblicz")
                }
//                .frame(height: 33)
                .buttonStyle(.borderedProminent)
                
            }
        }
    }
}

struct measurementColumns_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementColumns(rotaNumber: 0, measurement: 1)
            .environmentObject(CoreViewModel())
    }
}
