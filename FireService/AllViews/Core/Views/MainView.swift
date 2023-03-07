//
//  MainView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            allRotas
            Spacer()
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(CoreViewModel())
    }
}

extension MainView {
    
    private var allRotas: some View {
        ForEach(vm.rotas) { rota in
            VStack {
                RotaTableView(number: rota.number)
                Button {
                    vm.calculateExitTime(forRota: rota.number)
                } label: {
                    Text("oblicz")
                }
//                if let exitTime = rota.exitTime {
//                    Text("exit in: \(exitTime) min")
//                }
                Text("exit in: \(rota.exitTime ?? 0) min")
            }
        }
    }
}
