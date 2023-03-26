//
//  RotaTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI
    
    struct RotaTableView: View {
        
        let number: Int
        @EnvironmentObject private var vm: CoreViewModel
        @Binding var showAlert: Bool
        @State private var startButtonActive: Bool = true
        @State private var check1ButtonActive: Bool = true
        @State private var check2ButtonActive: Bool = true
        
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
            RotaTableView(number: 0, showAlert: .constant(false))
                .environmentObject(CoreViewModel())
        }
    }
    
    extension RotaTableView {
        
        private var namesColumn: some View {
            VStack {
                Text("ROTA \(number+1)")
                    .bold()
                    .underline()
//                Spacer()
                TextField("name1", text: $vm.rotas[number].f1Name)
                //                             .focused($fieldInFocus, equals: .name)
                TextField("name2", text: $vm.rotas[number].f2Name)
                //                    .focused($fieldInFocus, equals: .name)
//                Spacer()
                Text(timerInterval: (vm.rotas[number].time0 ?? Date())...Date(), countsDown: false)
                    .foregroundColor(.red)
//                Spacer()
            }
            .frame(minWidth: 80)
        }
        
        private var entryColumn: some View {
            VStack {
                Text("WEJŚCIE")
                TextField("BAR", text: $vm.rotas[number].f1Pressure0)
                //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($vm.rotas[number].f1Pressure0)
                TextField("BAR", text: $vm.rotas[number].f2Pressure0)
                //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($vm.rotas[number].f2Pressure0)
//                Spacer()
                if startButtonActive == false {
                    Text(vm.rotas[number].time0?.getFormattedDateToHHmm() ?? "error")
                        .foregroundColor(.secondary)
//                    DatePicker("time0", selection: $vm.rotas[number].time0, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//                        .focused($fieldInFocus, equals: .time0)
                } else {
                    Button {
                        
                        vm.startAction(forRota: number)
                        
                        if vm.rotas[number].f1Pressure0 == "" || vm.rotas[number].f2Pressure0 == ""  {
                            
                            showAlert = true
                        } else {
                            vm.rotas[number].time0 = Date()
                            startButtonActive = false
                            hideKeyboard()
                        }
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
                TextField("BAR", text: $vm.rotas[number].f1Pressure1)
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($vm.rotas[number].f1Pressure1)
                TextField("BAR", text: $vm.rotas[number].f2Pressure1)
                //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($vm.rotas[number].f2Pressure1)
                if check1ButtonActive == false {
                    Text(vm.rotas[number].time1?.getFormattedDateToHHmm() ?? "error")
                        .foregroundColor(.secondary)
                    //                DatePicker("time1", selection: $vm.rotas[number].time1, displayedComponents: .hourAndMinute)
                    //                    .labelsHidden()
                                    //                .focused($fieldInFocus, equals: .time1)
                } else {
                    Button {
                        vm.rotas[number].time1 = Date()
                        vm.calculateExitTime(forRota: number)
                        
                        if !(0.001...3600).contains(vm.rotas[number].exitTime ?? 0) {
                            showAlert = true
                        } else {
                            check1ButtonActive = false
                            
                            hideKeyboard()
                        }
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
                TextField("BAR", text: $vm.rotas[number].f1Pressure2)
                //                .focused($fieldInFocus, equals: .pressure2)
                    .numbersOnly($vm.rotas[number].f1Pressure2)
                TextField("BAR", text: $vm.rotas[number].f2Pressure2)
                //                .focused($fieldInFocus, equals: .pressure2)
                    .numbersOnly($vm.rotas[number].f2Pressure2)
                if check2ButtonActive == false {
                    Text(vm.rotas[number].time2?.getFormattedDateToHHmm() ?? "error")
                        .foregroundColor(.secondary)
                    //                DatePicker("time1", selection: $vm.rotas[number].time1, displayedComponents: .hourAndMinute)
                    //                    .labelsHidden()
                                    //                .focused($fieldInFocus, equals: .time1)
                } else {
                    Button {
                        
                        vm.rotas[number].time2 = Date()
                        vm.calculateExitTime(forRota: number)
                        
                        if !(0.001...3600).contains(vm.rotas[number].exitTime ?? 0) || vm.rotas[number].f1Pressure2 == "" || vm.rotas[number].f2Pressure2 == "" {
                            showAlert = true
                        } else {
                            check2ButtonActive = false
                            
                            hideKeyboard()
                        }
                    } label: {
                        Text("Oblicz")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
