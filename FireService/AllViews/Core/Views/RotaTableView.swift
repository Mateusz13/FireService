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
                Spacer()
                TextField("name1", text: $vm.rotas[number].f1Name)
                //                             .focused($fieldInFocus, equals: .name)
                TextField("name2", text: $vm.rotas[number].f2Name)
                //                    .focused($fieldInFocus, equals: .name)
                Spacer()
                Text(timerInterval: (vm.rotas[number].time00 ?? Date())...Date(), countsDown: false)
                    .foregroundColor(.red)
                Spacer()
                
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
                Button {
                    vm.startAction(forRota: number)
                } label: {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.green)
                //            DatePicker("time0", selection: $vm.rotas[number].time0, displayedComponents: .hourAndMinute)
                //                .labelsHidden()
                //                .focused($fieldInFocus, equals: .time0)
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
                Button {
                    vm.rotas[number].time1 = Date()
                    vm.calculateExitTime(forRota: number)
                    hideKeyboard()
                    if !(0.001...3600).contains(vm.rotas[number].exitTime ?? 0) {
                        showAlert.toggle()
                    }
                } label: {
                    Text("Oblicz")
                }
                .buttonStyle(.borderedProminent)
//                DatePicker("time1", selection: $vm.rotas[number].time1, displayedComponents: .hourAndMinute)
//                    .labelsHidden()
                //                .focused($fieldInFocus, equals: .time1)
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
                Button {
                    vm.rotas[number].time2 = Date()
                    vm.calculateExitTime(forRota: number)
                    hideKeyboard()
                    if !(0.001...3600).contains(vm.rotas[number].exitTime ?? 0) {
                        showAlert.toggle()
                    }
                } label: {
                    Text("Oblicz")
                }
                .buttonStyle(.borderedProminent)
//                DatePicker("time2", selection: $vm.rotas[number].time2, displayedComponents: .hourAndMinute)
//                    .labelsHidden()
                //                .focused($fieldInFocus, equals: .time2)
            }
        }
    }
