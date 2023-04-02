//
//  MainView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            allRotas
            Spacer()
        }
        .navigationTitle("MSZP")
        .navigationBarTitleDisplayMode(.inline)
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
        .alert(isPresented: $vm.showAlert) {
            getAlert()
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
                RotaTableView(rotaNumber: rota.number)
                
                
//                if let exitTime = rota.exitTime {
//                    if (-1...3600).contains(exitTime) { // we will get alert anyway
                Text("Pozostały czas: \(rota.exitTime?.asString(style: .abbreviated) ?? "")")
                            .foregroundColor(.red)
                        
                        // let endDate = Date().addingTimeInterval(exitTime)
                        // Text(timerInterval: Date()...endDate, countsDown: true)
                        //   .foregroundColor(.red)
                        
//                    }
//                }
            }
        }
    }
    
    private func getAlert() -> Alert {
        
        //        return Alert(
        //            title: Text(alertTitle),
        //            message: Text(alertMessage),
        //            dismissButton: .default(Text("OK")))
        return Alert(
            title: Text("Błąd"),
            message: Text("Wprowadź prawidłowe dane"),
            dismissButton: .default(Text("OK")))
    }
}
