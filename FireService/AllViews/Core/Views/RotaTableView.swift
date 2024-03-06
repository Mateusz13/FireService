//
//  RotaTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI

struct RotaTableView: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    //    @StateObject var timersVM: TimersRowViewModel
    @State private var addFiremanConfirmationAlert: Bool = false
    @State private var removeTheReserveConfirmationAlert: Bool = false
    @Binding var rota: Rota
    @Binding var startOrCalculateButtonActive: [Bool]
    @Binding var numberOfFiremans: Int
    @Binding var endButtonActive: Bool
    @Binding var editData: [Bool]
    @State private var editDataAlert: Bool = false
    
    var body: some View {
        VStack {
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
            .padding(3)
            .background(rota.number == 2 ? Color(hue: 0.01, saturation: 0.63, brightness: 0.94, opacity: 1.00) : Color(white: 0.80, opacity: 1.00))
            .cornerRadius(10)
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            TimersRowView(timersVM: TimersRowViewModel(coreVM: vm), rota: $rota, endButtonActive: $endButtonActive, startOrCalculateButtonActive: $startOrCalculateButtonActive)
        }
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
            TextField("name2", text: $rota.f2Name)
            if numberOfFiremans > 1 {
                TextField("name3", text: $rota.f3Name)
            }
            if numberOfFiremans > 2 {
                TextField("name4", text: $rota.f4Name)
            }
            if startOrCalculateButtonActive[0] && numberOfFiremans != 3 {
                Button {
                    addFiremanConfirmationAlert = true
                } label: {
                    Label("", systemImage: "plus.circle.fill")
                        .font(.title)
                }
                .foregroundColor(.green)
                .frame(minHeight: 34)
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
                .frame(minHeight: 34)
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
                .numbersOnly($rota.f1Pressures[0])
                .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            TextField("BAR", text: $rota.f2Pressures[0])
                .numbersOnly($rota.f2Pressures[0])
                .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            if numberOfFiremans > 1 {
                TextField("BAR", text: $rota.f3Pressures[0])
                    .numbersOnly($rota.f3Pressures[0])
                    .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            }
            if numberOfFiremans > 2 {
                TextField("BAR", text: $rota.f4Pressures[0])
                    .numbersOnly($rota.f4Pressures[0])
                    .disabled(!startOrCalculateButtonActive[0] && !editData[0])
            }
            if !startOrCalculateButtonActive[0] && !editData[0] {
                Text(rota.time?[0].getFormattedDateToHHmm() ?? "error")
                    .frame(minHeight: 33)
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
                    //                    timersVM.handleFirstMeasurement(forRota: rota.number, forMeasurement: 0)
                } label: {
                    Text("Start")
                }
                .disabled(!endButtonActive)
                .buttonStyle(.borderedProminent)
                .foregroundColor(.green)
            }
        }
    }
}
