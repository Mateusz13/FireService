//
//  RotaView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI

struct RotaView: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    
    var body: some View {
        VStack {
            TimeRowView(number: 0, entryTime: $vm.entryTime, firstCheckTime: $vm.firstCheckTime, secondCheckTime: $vm.secondCheckTime)
            BarNameRowView(number: 0, name: $vm.name, entryPressure: $vm.entryPressure, firstCheckPressure: $vm.firstCheckPressure, secondCheckPressure: $vm.secondCheckPressure)
            BarNameRowView(number: 1, name: $vm.name, entryPressure: $vm.entryPressure, firstCheckPressure: $vm.firstCheckPressure, secondCheckPressure: $vm.secondCheckPressure)
        }
    }
}

struct RotaView_Previews: PreviewProvider {
    static var previews: some View {
        RotaView()
            .environmentObject(CoreViewModel())
    }
}
