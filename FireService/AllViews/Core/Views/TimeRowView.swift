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
    
    let number: Int
    
    @Binding var time0: [String]
    @Binding var time1: [String]
    @Binding var time2: [String]
    
//    @FocusState var fieldInFocus: FocusField?
    
    var body: some View {
        
        HStack {
//            Text("1")
            Text("ROTA\(number+1)")
                .foregroundColor(Color.red)
            Text("GG:MM")
                .foregroundColor(Color.blue)
            TextField("time0", text: $time0[number])
//                .focused($fieldInFocus, equals: .time0)
                .numbersOnly($time0[number], includeDecimal: true)
            TextField("time1", text: $time1[number])
//                .focused($fieldInFocus, equals: .time1)
                .numbersOnly($time1[number], includeDecimal: true)
            TextField("time2", text: $time2[number])
//                .focused($fieldInFocus, equals: .time2)
                .numbersOnly($time2[number], includeDecimal: true)
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
        TimeRowView(number: 0, time0: .constant(["11:45"]), time1: .constant(["11:50"]), time2: .constant(["11:55"]))
    }
}
