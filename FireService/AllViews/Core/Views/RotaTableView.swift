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
//        @Binding var showAlert: Bool
//        @State private var startButtonActive: Bool = true
//        @State private var calculateButtonActive: Bool = true
//        @State private var check2ButtonActive: Bool = true
        
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
                    check1Column
                    check2Column
                }
            }
            .textFieldStyle(.roundedBorder)
            .frame(height: 150)
            //.frame(maxWidth: 500)
            //        .padding(.horizontal, 3)
            //        .padding(.vertical, 3)
            .padding(3)
            .background(Color.gray.brightness(0.4))
            .cornerRadius(10)
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            Spacer()
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
                Text("ROTA \(rotaNumber+1)")
                    .bold()
                    .underline()
//                Spacer()
                TextField("name1", text: $vm.rotas[rotaNumber].f1Name)
                //                             .focused($fieldInFocus, equals: .name)
                TextField("name2", text: $vm.rotas[rotaNumber].f2Name)
                //                    .focused($fieldInFocus, equals: .name)
//                Spacer()
                Text(timerInterval: (vm.rotas[rotaNumber].time?[0] ?? Date())...Date(), countsDown: false)
                    .foregroundColor(.red)
//                Spacer()
            }
            .frame(minWidth: 80)
        }
        
        private var entryColumn: some View {
            VStack {
                Text("WEJŚCIE")
                TextField("BAR", text: $vm.rotas[rotaNumber].f1Pressures[0])
                //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($vm.rotas[rotaNumber].f1Pressures[0])
                TextField("BAR", text: $vm.rotas[rotaNumber].f2Pressures[0])
                //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($vm.rotas[rotaNumber].f2Pressures[0])
//                Spacer()
                if vm.startButtonActive[rotaNumber] == false {
                    Text(vm.rotas[rotaNumber].time?[0].getFormattedDateToHHmm() ?? "error")
                        .foregroundColor(.secondary)
//                    DatePicker("time0", selection: $vm.rotas[rotaNumber].time0, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//                        .focused($fieldInFocus, equals: .time0)
                } else {
                    Button {
//                        vm.rotas[rotaNumber].time?[0] = Date()
//                        tak było we wcześniejszym commicie:
//                        vm.rotas[number].time0 = Date()
                        vm.startAction(forRota: rotaNumber)
                        
                    } label: {
                        Text("Start")
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.green)
                }
//                Spacer()
            }
        }
        
        private var check1Column: some View {
            VStack {
                Text("POMIAR 1")
                TextField("BAR", text: $vm.rotas[rotaNumber].f1Pressures[1])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($vm.rotas[rotaNumber].f1Pressures[1])
                TextField("BAR", text: $vm.rotas[rotaNumber].f2Pressures[1])
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($vm.rotas[rotaNumber].f2Pressures[1])
                if vm.calculateButtonActive[rotaNumber][0] == false {
                    Text(vm.rotas[rotaNumber].time?[1].getFormattedDateToHHmm() ?? "error")
                        .foregroundColor(.secondary)
                    //                DatePicker("time1", selection: $vm.rotas[rotaNumber].time1, displayedComponents: .hourAndMinute)
                    //                    .labelsHidden()
                                    //                .focused($fieldInFocus, equals: .time1)
                } else {
                    Button {
//                        vm.rotas[rotaNumber].time?[1] = Date()
//                        vm.calculateExitTime(forRota: rotaNumber)
                        vm.calculateExitTimeX(forRota: rotaNumber, forMeasurement: 1)
                        
//                        if !(0.001...3600).contains(vm.rotas[rotaNumber].exitTime ?? 0) {
//                            showAlert = true
//                        } else {
//                            calculateButtonActive = false
                            
//                            hideKeyboard()
//                        }
                    } label: {
                        Text("Oblicz")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        
        private var check2Column: some View {
            
            VStack {
                Text("POMIAR 2")
                TextField("BAR", text: $vm.rotas[rotaNumber].f1Pressures[2])
                //                .focused($fieldInFocus, equals: .pressure2)
                    .numbersOnly($vm.rotas[rotaNumber].f1Pressures[2])
                TextField("BAR", text: $vm.rotas[rotaNumber].f2Pressures[2])
                //                .focused($fieldInFocus, equals: .pressure2)
                    .numbersOnly($vm.rotas[rotaNumber].f2Pressures[2])
                if vm.calculateButtonActive[rotaNumber][1] == false {
                    Text(vm.rotas[rotaNumber].time?[2].getFormattedDateToHHmm() ?? "error")
                        .foregroundColor(.secondary)
                    //                DatePicker("time1", selection: $vm.rotas[rotaNumber].time1, displayedComponents: .hourAndMinute)
                    //                    .labelsHidden()
                                    //                .focused($fieldInFocus, equals: .time1)
                } else {
                    Button {
                        vm.calculateExitTimeX(forRota: rotaNumber, forMeasurement: 2)
//                        vm.rotas[rotaNumber].time?[2] = Date()
//                        vm.calculateExitTime(forRota: rotaNumber)
                        
//                        if !(0.001...3600).contains(vm.rotas[rotaNumber].exitTime ?? 0) || vm.rotas[rotaNumber].f1Pressures[2] == "" || vm.rotas[rotaNumber].f2Pressures[2] == "" {
//                            showAlert = true
//                        } else {
//                            check2ButtonActive = false
                            
//                            hideKeyboard()
//                        }
                    } label: {
                        Text("Oblicz")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
