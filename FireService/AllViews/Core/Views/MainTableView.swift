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
            RotaTableView(number: 0, name1: $vm.name1, entryPressure1: $vm.entryPressure1, firstCheckPressure1: $vm.firstCheckPressure1, secondCheckPressure1: $vm.secondCheckPressure1)
            RotaTableView(number: 1, name1: $vm.name1, entryPressure1: $vm.entryPressure1, firstCheckPressure1: $vm.firstCheckPressure1, secondCheckPressure1: $vm.secondCheckPressure1)
        }
    }
}

struct MainTableView_Previews: PreviewProvider {
    static var previews: some View {
        MainTableView()
            .environmentObject(CoreViewModel())
    }
}
