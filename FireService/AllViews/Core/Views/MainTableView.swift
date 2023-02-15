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
            RotaTableView(number: 0, name: $vm.name, entryPressure: $vm.entryPressure, firstCheckPressure: $vm.firstCheckPressure, secondCheckPressure: $vm.secondCheckPressure)
            RotaTableView(number: 1, name: $vm.name, entryPressure: $vm.entryPressure, firstCheckPressure: $vm.firstCheckPressure, secondCheckPressure: $vm.secondCheckPressure)
        }
    }
}

struct MainTableView_Previews: PreviewProvider {
    static var previews: some View {
        MainTableView()
            .environmentObject(CoreViewModel())
    }
}
