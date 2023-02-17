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
            TimeRowView(number: 0, time0: $vm.time0, time1: $vm.time1, time2: $vm.time2)
                
            BarNameRowView(number: 0, name: $vm.name, pressure0: $vm.pressure0, pressure1: $vm.pressure1, pressure2: $vm.pressure2)
            BarNameRowView(number: 1, name: $vm.name, pressure0: $vm.pressure0, pressure1: $vm.pressure1, pressure2: $vm.pressure2)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                   hideKeyboard()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }

            }
        }
    }
}

struct RotaView_Previews: PreviewProvider {
    static var previews: some View {
        RotaView()
            .environmentObject(CoreViewModel())
    }
}
