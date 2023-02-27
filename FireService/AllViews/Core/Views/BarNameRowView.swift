//
//  BarNameRowView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI

struct BarNameRowView: View {
    
    let number: Int
    @EnvironmentObject private var vm: CoreViewModel
    
//    enum FocusField {
//        case name, pressure0, pressure1, pressure2
//    }
    
//    @FocusState var fieldInFocus: FocusField?
    
    var body: some View {
        VStack {
            HStack {
    //            Text("1")
                TextField("name", text: $vm.rotas[number].f1Name)
    //                    .focused($fieldInFocus, equals: .name)
                Text("BAR")
                    .foregroundColor(Color.blue)
                TextField("p0", text: $vm.rotas[number].f1Pressure0)
    //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($vm.rotas[number].f1Pressure0)
                TextField("p1", text: $vm.rotas[number].f1Pressure1)
    //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($vm.rotas[number].f1Pressure1)
                TextField("p2", text: $vm.rotas[number].f1Pressure2)
    //                .focused($fieldInFocus, equals: .pressure2)
                    .numbersOnly($vm.rotas[number].f1Pressure2)
            }
            HStack {
    //            Text("1")
                TextField("name", text: $vm.rotas[number].f2Name)
    //                    .focused($fieldInFocus, equals: .name)
                Text("BAR")
                    .foregroundColor(Color.blue)
                TextField("p0", text: $vm.rotas[number].f2Pressure0)
    //                .focused($fieldInFocus, equals: .pressure0)
                    .numbersOnly($vm.rotas[number].f2Pressure0)
                TextField("p1", text: $vm.rotas[number].f2Pressure1)
    //                .focused($fieldInFocus, equals: .pressure1)
                    .numbersOnly($vm.rotas[number].f2Pressure1)
                TextField("p2", text: $vm.rotas[number].f2Pressure2)
    //                .focused($fieldInFocus, equals: .pressure2)
                    .numbersOnly($vm.rotas[number].f2Pressure2)
            }
        }
        .textFieldStyle(.roundedBorder)
        .frame(height: 70)
        .frame(maxWidth: 500)
        .background(Color.gray.brightness(0.4))
        .cornerRadius(10)
//        .padding()
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}

struct BarNameRowView_Previews: PreviewProvider {
    static var previews: some View {
        BarNameRowView(number: 0)
            .environmentObject(CoreViewModel())
    }
}

