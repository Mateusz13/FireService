//
//  BarNameRowView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI

struct BarNameRowView: View {
    
    let number: Int
    
//    enum FocusField {
//        case name, pressure0, pressure1, pressure2
//    }
    
    @Binding var name: [String]
    @Binding var pressure0: [String]
    @Binding var pressure1: [String]
    @Binding var pressure2: [String]
    
//    @FocusState var fieldInFocus: FocusField?
    
    var body: some View {
        HStack {
//            Text("1")
            TextField("name", text: $name[number])
//                    .focused($fieldInFocus, equals: .name)
            Text("BAR")
                .foregroundColor(Color.blue)
            TextField("p0", text: $pressure0[number])
//                .focused($fieldInFocus, equals: .pressure0)
                .numbersOnly($pressure0[number])
            TextField("p1", text: $pressure1[number])
//                .focused($fieldInFocus, equals: .pressure1)
                .numbersOnly($pressure1[number])
            TextField("p2", text: $pressure2[number])
//                .focused($fieldInFocus, equals: .pressure2)
                .numbersOnly($pressure2[number])
            
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
        BarNameRowView(number: 0, name: .constant(["mati"]), pressure0: .constant(["100"]), pressure1: .constant(["90"]), pressure2: .constant(["80"]))
    }
}

