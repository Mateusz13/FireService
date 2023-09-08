//
//  RotaTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI 

struct RotaTableView: View {
    
    //    let rotaNumber: Int
    
    @EnvironmentObject private var vm: CoreViewModel
    @State private var addFiremanConfirmationAlert: Bool = false
    @State private var removeTheReserveConfirmationAlert: Bool = false
//    @EnvironmentObject private var timerVM: TimerViewModel
    @StateObject private var timerVM = TimerViewModel()
    
    @Binding var rota: Rota
    @Binding var startOrCalculateButtonActive: [Bool]
    @Binding var numberOfFiremans: Int
    @Binding var endButtonActive: Bool
    @Binding var editData: [Bool]
    //        enum FocusField {
    //            case name, pressure0, pressure1, pressure2
    //        }
    //        @FocusState var fieldInFocus: FocusField?
    @State private var editDataAlert: Bool = false
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                namesColumn
                entryColumn
                ForEach(1...10, id: \.self) { measurement in
                    MeasurementColumns(measurement: measurement, rota: $rota, startOrCalculateButtonActive: $startOrCalculateButtonActive, numberOfFiremans: $numberOfFiremans, endButtonActive: $endButtonActive, editData: $editData)
                }
            }
        }
        .textFieldStyle(.roundedBorder)
        //.frame(height: vm.numberOfFiremans[rotaNumber] == 2 ? 192 : 150)//150/192/234
        //.frame(maxWidth: 500)
        //.padding(.horizontal, 3)
        //.padding(.vertical, 3)
        .padding(3)
        .background(rota.number == 2 ? Color(hue: 0.01, saturation: 0.63, brightness: 0.94, opacity: 1.00) : Color(white: 0.80, opacity: 1.00))
        .cornerRadius(10)
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        //        Spacer()
    }
}

struct RotaTableView_Previews: PreviewProvider {
    static var previews: some View {
        RotaTableView(rota: .constant(Rota(number: 0)), startOrCalculateButtonActive: .constant(Array(repeating: true, count: 13)), numberOfFiremans: .constant(1), endButtonActive: .constant(true), editData: .constant(Array(repeating: false, count: 11)))
            .environmentObject(CoreViewModel())
    }
}

extension RotaTableView {
    
    private var namesColumn: some View {
        
        VStack {
            if rota.number < 3 {
                Text("ROTA \(rota.number == 2 ? "RIT" : String(rota.number+1))")
                    .bold()
                    .underline()
            } else {
                Text("ROTA \(rota.number)")
                    .bold()
                    .underline()
            }
            TextField("name1", text: $rota.f1Name)
            // .focused($fieldInFocus, equals: .name)
            TextField("name2", text: $rota.f2Name)
            // .focused($fieldInFocus, equals: .name)
            if numberOfFiremans > 1 {
                TextField("name3", text: $rota.f3Name)
                // .focused($fieldInFocus, equals: .name)
            }
            if numberOfFiremans > 2 {
                TextField("name4", text: $rota.f4Name)
                // .focused($fieldInFocus, equals: .name)
            }
            if startOrCalculateButtonActive[0] && numberOfFiremans != 3 {
                Button {
                    addFiremanConfirmationAlert = true
                } label: {
                    Label("", systemImage: "plus.circle.fill")
                        .font(.title)
                }
                .foregroundColor(.green)
                .frame(height: 34)
//                .disabled(numberOfFiremans == 3)
                .alert("Dodać strażaka?", isPresented: $addFiremanConfirmationAlert) {
                    Button("Tak") { if startOrCalculateButtonActive[0] {
                        withAnimation(.easeIn) {
                            vm.addFireman(forRota: rota.number)
                        }
                    }
                    }
                    Button("Nie", role: .cancel) { }
                } message: {
                    if rota.number == 2 {
                        Text("Dodać kolejnego strażaka do Roty RIT?")
                    } else if rota.number < 2 {
                        Text("Dodać kolejnego strażaka do Roty \(rota.number+1)?")
                    } else {
                        Text("Dodać kolejnego strażaka do Roty \(rota.number)?")
                    }
                }
            } else {
                Button {
                    removeTheReserveConfirmationAlert = true
                } label: {
                    Label("", systemImage: "person.crop.circle.badge.exclamationmark")
                        .font(.title)
                }
                .foregroundColor(vm.minimalPressure[rota.number] == 50.0 ? .green : .red)
                .frame(height: 34)
                .disabled(!endButtonActive)
                .disabled(vm.minimalPressure[rota.number] == 0.0)
                .alert("Usunąć rezerwę 50 BAR?!", isPresented: $removeTheReserveConfirmationAlert) {
                    Button("Tak", role: .destructive) {
                        withAnimation(.easeIn) {
                            vm.minimalPressure[rota.number] = 0.0
                            if let index = startOrCalculateButtonActive.lastIndex(of: false) { if index > 0 {
                                editData[index] = true
                            }
                            }
                        }
                    }
                    Button("Nie", role: .cancel) { }
                }
//                message: {
//                    Text("Usunąć rezerwę?")
//                }
            }
        }
        .frame(minWidth: 80)
    }
    
    
    private var entryColumn: some View {
        VStack {
            Button {
                editDataAlert = true
            } label: {
                Text("WEJŚCIE")
            }
            .alert("Edytować dane dla wejścia?", isPresented: $editDataAlert) {
                Button("Tak", role: .destructive) { editData[0] = true }
                Button("Nie", role: .cancel) { }
            }
            .disabled(startOrCalculateButtonActive[0])
            .disabled(!startOrCalculateButtonActive[2])
            .disabled(!endButtonActive)
            TextField("BAR", text: $rota.f1Pressures[0])
            //                .focused($fieldInFocus, equals: .pressure0)
                .numbersOnly($rota.f1Pressures[0])
                .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            TextField("BAR", text: $rota.f2Pressures[0])
            //                .focused($fieldInFocus, equals: .pressure0)
                .numbersOnly($rota.f2Pressures[0])
                .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            if numberOfFiremans > 1 {
                TextField("BAR", text: $rota.f3Pressures[0])
                //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($rota.f3Pressures[0])
                    .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            }
            if numberOfFiremans > 2 {
                TextField("BAR", text: $rota.f4Pressures[0])
                //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($rota.f4Pressures[0])
                    .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            }
            if !startOrCalculateButtonActive[0] && !editData[0] {
                Text(timerVM.timerRotas[rota.number].time?[0].getFormattedDateToHHmm() ?? "error")
                    .frame(height: 33)
                    .foregroundColor(.secondary)
            } else if editData[0] {
                Button {
                    editData[0] = false
                    if !startOrCalculateButtonActive[1] {
                        editData[1] = true
                    }
                } label: {
                    Text("Edytuj")
                }
                .disabled(!endButtonActive)
                .buttonStyle(.borderedProminent)
                .foregroundColor(.red)
            }
            else {
                Button {
                    vm.startActionOrCalculateExitTime(forRota: rota.number, forMeasurement: 0)
                    timerVM.handleFirstMeasurement(forRota: rota.number, forMeasurement: 0)
//                    editData2 = false
                } label: {
                    Text("Start")
                }
                .disabled(!endButtonActive)
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

