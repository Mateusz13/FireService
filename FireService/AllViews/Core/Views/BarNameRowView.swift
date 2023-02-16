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
//        case name, entryPressure, firstCheckPressure, secondCheckPressure
//    }
    
    @Binding var name: [String]
    @Binding var entryPressure: [String]
    @Binding var firstCheckPressure: [String]
    @Binding var secondCheckPressure: [String]
    
//    @FocusState var fieldInFocus: FocusField?
    
    var body: some View {
        HStack {
//            Text("1")
            TextField("name", text: $name[number])
//                    .focused($fieldInFocus, equals: .name)
            Text("BAR")
                .foregroundColor(Color.blue)
            TextField("entryPressure", text: $entryPressure[number])
//                .focused($fieldInFocus, equals: .entryPressure)
                .numbersOnly($entryPressure[number])
            TextField("firstCheckPressure", text: $firstCheckPressure[number])
//                .focused($fieldInFocus, equals: .firstCheckPressure)
                .numbersOnly($firstCheckPressure[number])
            TextField("secondCheckPressure", text: $secondCheckPressure[number])
//                .focused($fieldInFocus, equals: .secondCheckPressure)
                .numbersOnly($secondCheckPressure[number])
            
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
        BarNameRowView(number: 0, name: .constant(["mati"]), entryPressure: .constant(["100"]), firstCheckPressure: .constant(["90"]), secondCheckPressure: .constant(["80"]))
    }
}

