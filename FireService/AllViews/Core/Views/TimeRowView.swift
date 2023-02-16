//
//  TimeRowView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 15/02/2023.
//

import SwiftUI

struct TimeRowView: View {
    
    enum FocusField {
        case entryTime, firstCheckTime, secondCheckTime
    }
    
    let number: Int
    
    @Binding var entryTime: [String]
    @Binding var firstCheckTime: [String]
    @Binding var secondCheckTime: [String]
    
    @FocusState var fieldInFocus: FocusField?
    
    var body: some View {
        
        HStack {
//            Text("1")
            Text("ROTA\(number+1)")
                .foregroundColor(Color.red)
            Text("GG:MM")
                .foregroundColor(Color.blue)
            TextField("entryTime", text: $entryTime[number])
                .focused($fieldInFocus, equals: .entryTime)
                .numbersOnly($entryTime[number], includeDecimal: true)
            TextField("firstCheckTime", text: $firstCheckTime[number])
                .focused($fieldInFocus, equals: .firstCheckTime)
                .numbersOnly($firstCheckTime[number], includeDecimal: true)
            TextField("secondCheckTime", text: $secondCheckTime[number])
                .focused($fieldInFocus, equals: .secondCheckTime)
                .numbersOnly($secondCheckTime[number], includeDecimal: true)
        }
        .textFieldStyle(.roundedBorder)
        .frame(height: 70)
        .frame(maxWidth: 500)
        .background(Color.gray.brightness(0.4))
        .cornerRadius(10)
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

struct TimeRowView_Previews: PreviewProvider {
    static var previews: some View {
        TimeRowView(number: 0, entryTime: .constant(["11:45"]), firstCheckTime: .constant(["11:50"]), secondCheckTime: .constant(["11:55"]))
    }
}
