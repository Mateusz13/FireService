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
            TimeRowView(number: vm.rota1)
                
            BarNameRowView(number: vm.rota1)

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
