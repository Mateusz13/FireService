//
//  TimeRowView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 15/02/2023.
//

import SwiftUI

struct TimeRowView: View {
    
//    enum FocusField {
//        case time0, time1, time2
//    }
    @EnvironmentObject private var vm: CoreViewModel
    let number: Int
    
//    @FocusState var fieldInFocus: FocusField?
    
    var body: some View {
        
        HStack {
//            Text("1")
            Text("ROTA\(number+1)")
                .foregroundColor(Color.red)
            Text("GG:MM")
                .foregroundColor(Color.blue)
            TextField("time0", text: $vm.rotas[number].time0)
//                .focused($fieldInFocus, equals: .time0)
                .numbersOnly($vm.rotas[number].time0, includeDecimal: true)
            TextField("time1", text: $vm.rotas[number].time1)
//                .focused($fieldInFocus, equals: .time1)
                .numbersOnly($vm.rotas[number].time0, includeDecimal: true)
            TextField("time2", text: $vm.rotas[number].time2)
//                .focused($fieldInFocus, equals: .time2)
                .numbersOnly($vm.rotas[number].time2, includeDecimal: true)
        }
        .textFieldStyle(.roundedBorder)
        .frame(height: 70)
        .frame(maxWidth: 500)
        .background(Color.gray.brightness(0.4))
        .cornerRadius(10)
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}

struct TimeRowView_Previews: PreviewProvider {
    static var previews: some View {
        TimeRowView(number: 0)
            .environmentObject(CoreViewModel())
    }
}
