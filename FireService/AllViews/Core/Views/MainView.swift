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
        .alert(isPresented: $showAlert) {
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
                RotaTableView(number: rota.number)
                Button {
                    vm.calculateExitTime(forRota: rota.number)
                    hideKeyboard()
//                    print(vm.rotas[rota.number].exitTime)
                    if !(0.001...3600).contains(vm.rotas[rota.number].exitTime ?? 0) {
                        showAlert.toggle()
                    }
                } label: {
                    Text("Oblicz")
                }
                .buttonStyle(.borderedProminent)
                
                    if let exitTime = rota.exitTime {
                        if (-1...3600).contains(exitTime) {
                            Text("Pozostały czas: \(exitTime.asString(style: .abbreviated) )")
                                .foregroundColor(.red)
                        }
                    }
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
