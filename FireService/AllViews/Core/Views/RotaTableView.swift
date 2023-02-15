//
//  RotaTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI

struct RotaTableView: View {
    
    let number: Int
    
    enum FocusField {
        case name, entryPressure, firstCheckPressure, secondCheckPressure
    }
    
    @Binding var name1: [String]
    @Binding var entryPressure1: [String]
    @Binding var firstCheckPressure1: [String]
    @Binding var secondCheckPressure1: [String]
    
    @FocusState private var fieldInFocus: FocusField?
    
    var body: some View {
        HStack {
            Text("1")
            TextField("name1", text: $name1[number])
                    .focused($fieldInFocus, equals: .name)
            Text("BAR")
            TextField("entryPressure1", text: $entryPressure1[number])
                .focused($fieldInFocus, equals: .entryPressure)
                .numbersOnly($entryPressure1[number])
            TextField("firstCheckPressure1", text: $firstCheckPressure1[number])
                .focused($fieldInFocus, equals: .firstCheckPressure)
                .numbersOnly($firstCheckPressure1[number])
            TextField("secondCheckPressure1", text: $secondCheckPressure1[number])
                .focused($fieldInFocus, equals: .secondCheckPressure)
                .numbersOnly($secondCheckPressure1[number])
            
        }
        .textFieldStyle(.roundedBorder)
        .frame(height: 70)
        .frame(maxWidth: 500)
        .background(Color.gray.brightness(0.4))
        .cornerRadius(10)
        .padding()
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    fieldInFocus = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }

            }
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}

struct RotaTableView_Previews: PreviewProvider {
    static var previews: some View {
        RotaTableView(number: 0, name1: .constant(["mati"]), entryPressure1: .constant(["100"]), firstCheckPressure1: .constant(["90"]), secondCheckPressure1: .constant(["80"]))
    }
}

