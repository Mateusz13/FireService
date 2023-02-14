//
//  RotaTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI

struct RotaTableView: View {
    
    enum FocusField {
        case name, entryPressure, firstCheckPressure, secondCheckPressure
    }
    
    @State private var name1: String = ""
    @State private var entryPressure1: String = ""
    @State private var firstCheckPressure1: String = ""
    @State private var secondCheckPressure1: String = ""
    
    @FocusState private var fieldInFocus: FocusField?
    
    var body: some View {
        HStack {
            Text("1")
            TextField("name1", text: $name1)
                .focused($fieldInFocus, equals: .name)
            Text("BAR")
            TextField("entryPressure1", text: $entryPressure1)
                .focused($fieldInFocus, equals: .entryPressure)
                .numbersOnly($entryPressure1)
            TextField("firstCheckPressure1", text: $firstCheckPressure1)
                .focused($fieldInFocus, equals: .firstCheckPressure)
                .numbersOnly($firstCheckPressure1)
            TextField("secondCheckPressure1", text: $secondCheckPressure1)
                .focused($fieldInFocus, equals: .secondCheckPressure)
                .numbersOnly($secondCheckPressure1)
            
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
        RotaTableView()
    }
}

