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
        
        ForEach(vm.rotas) { rota in
            VStack {
                TimeRowView(number: rota.number)
                BarNameRowView(number: rota.number)
                Button {
                    vm.calculateExitTime(forRota: rota.number)
                } label: {
                    Text("calculate")
                }
                
//                if let exitTime = rota.exitTime {
//                    Text("exit in: \(exitTime) min")
//                }
                Text("exit in: \(rota.exitTime ?? 0) min")
            }
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
