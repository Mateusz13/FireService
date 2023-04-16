//
//  RotaTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI 

struct RotaTableView: View {

    let rotaNumber: Int
    @EnvironmentObject private var vm: CoreViewModel
    
    //        enum FocusField {
    //            case name, pressure0, pressure1, pressure2
    //        }
    //
    //        @FocusState var fieldInFocus: FocusField?
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                namesColumn
                entryColumn
                ForEach(1...10, id: \.self) { measurement in
                    MeasurementColumns(rotaNumber: rotaNumber, measurement: measurement)
                }
            }
        }
        .textFieldStyle(.roundedBorder)
        .frame(height: 150)
        //.frame(maxWidth: 500)
        //.padding(.horizontal, 3)
        // .padding(.vertical, 3)
        .padding(3)
        .background(rotaNumber == 2 ? Color(hue: 0.01, saturation: 0.63, brightness: 0.94, opacity: 1.00) : Color(white: 0.80, opacity: 1.00))
        .cornerRadius(10)
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        //        Spacer()
    }
}

struct RotaTableView_Previews: PreviewProvider {
    static var previews: some View {
        RotaTableView(rotaNumber: 0)
            .environmentObject(CoreViewModel())
    }
}

extension RotaTableView {
    
    private var namesColumn: some View {
        
        VStack {
            if rotaNumber < 3 {
                Text("ROTA \(rotaNumber == 2 ? "RIT" : String(rotaNumber+1))")
                    .bold()
                    .underline()
            } else {
                Text("ROTA \(rotaNumber)")
                    .bold()
                    .underline()
            }
            
            
            TextField("name1", text: $vm.rotas[rotaNumber].f1Name)
            // .focused($fieldInFocus, equals: .name)
            TextField("name2", text: $vm.rotas[rotaNumber].f2Name)
            // .focused($fieldInFocus, equals: .name)
            if (0...7200).contains(vm.rotas[rotaNumber].duration ?? 0) {
                Text(vm.rotas[rotaNumber].duration?.asString(style: .abbreviated) ?? "0:00")
                    .frame(height: 33)
                    .foregroundColor(rotaNumber == 2 ? .yellow : .red)
                    .padding(.horizontal, 3)
                    .background((300...330).contains(vm.rotas[rotaNumber].duration ?? 0) ? .green : .clear)
    
            } else {
                Text("error")
                    .frame(height: 33)
            }
        }
        .frame(minWidth: 80)
    }
    
   
    private var entryColumn: some View {
        VStack {
            Text("WEJŚCIE")
            TextField("BAR", text: $vm.rotas[rotaNumber].f1Pressures[0])
            //                .focused($fieldInFocus, equals: .pressure0)
                .numbersOnly($vm.rotas[rotaNumber].f1Pressures[0])
                .disabled(!vm.startOrCalculateButtonActive[rotaNumber][0])
            TextField("BAR", text: $vm.rotas[rotaNumber].f2Pressures[0])
            //                .focused($fieldInFocus, equals: .pressure0)
                .numbersOnly($vm.rotas[rotaNumber].f2Pressures[0])
                .disabled(!vm.startOrCalculateButtonActive[rotaNumber][0])
            if vm.startOrCalculateButtonActive[rotaNumber][0] == false {
                Text(vm.rotas[rotaNumber].time?[0].getFormattedDateToHHmm() ?? "error")
                    .frame(height: 33)
                    .foregroundColor(.secondary)
            } else {
                Button {
                    vm.startActionOrCalculateExitTime(forRota: rotaNumber, forMeasurement: 0)
                } label: {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.green)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    private var check1Column: some View {
//        VStack {
//            Text("POMIAR 1")
//            TextField("BAR", text: $vm.rotas[rotaNumber].f1Pressures[1])
//            //                .focused($fieldInFocus, equals: .pressure1)
//                .numbersOnly($vm.rotas[rotaNumber].f1Pressures[1])
//            TextField("BAR", text: $vm.rotas[rotaNumber].f2Pressures[1])
//            //                .focused($fieldInFocus, equals: .pressure1)
//                .numbersOnly($vm.rotas[rotaNumber].f2Pressures[1])
//            if vm.startOrCalculateButtonActive[rotaNumber][1] == false {
//                Text(vm.rotas[rotaNumber].time?[1].getFormattedDateToHHmm() ?? "error")
//                    .foregroundColor(.secondary)
//            } else {
//                Button {
//                    vm.startActionOrCalculateExitTime(forRota: rotaNumber, forMeasurement: 1)
//                } label: {
//                    Text("Oblicz")
//                }
//                .buttonStyle(.borderedProminent)
//            }
//        }
//    }
    
//    private var check2Column: some View {
//
//        VStack {
//            Text("POMIAR 2")
//            TextField("BAR", text: $vm.rotas[rotaNumber].f1Pressures[2])
//            //                .focused($fieldInFocus, equals: .pressure2)
//                .numbersOnly($vm.rotas[rotaNumber].f1Pressures[2])
//            TextField("BAR", text: $vm.rotas[rotaNumber].f2Pressures[2])
//            //                .focused($fieldInFocus, equals: .pressure2)
//                .numbersOnly($vm.rotas[rotaNumber].f2Pressures[2])
//            if vm.startOrCalculateButtonActive[rotaNumber][2] == false {
//                Text(vm.rotas[rotaNumber].time?[2].getFormattedDateToHHmm() ?? "error")
//                    .foregroundColor(.secondary)
//            } else {
//                Button {
//                    vm.startActionOrCalculateExitTime(forRota: rotaNumber, forMeasurement: 2)
//
//                } label: {
//                    Text("Oblicz")
//                }
//                .buttonStyle(.borderedProminent)
//            }
//        }
//    }
}



//IOS 16:
//            Text(timerInterval: (vm.rotas[rotaNumber].time?[0] ?? Date())...Date(), countsDown: false)

