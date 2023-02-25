//
//  MainTableView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import SwiftUI

struct MainTableView: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    
    var body: some View {
        
        VStack {
            tableHeader
            RotaView()
            Button {
                vm.calculateExitTime()
            } label: {
                Text("calculate")
            }
            Text("exit in: \(vm.exitTime1 ?? 0.00)")
            Spacer()
        }
    }
}

struct MainTableView_Previews: PreviewProvider {
    static var previews: some View {
        MainTableView()
            .environmentObject(CoreViewModel())
    }
}

extension MainTableView {
    
    private var tableHeader: some View {
        HStack {
            Spacer()
            Text("CZAS")
            Text("WEJŚCIE")
            Text("Kontrola 1")
            Text("Kontrola 2")
        }
        .foregroundColor(Color.blue)
        .padding()
    }
}
