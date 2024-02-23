//
//  MainView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var vm: CoreViewModel
    @State private var currentTime = ""
    @State private var endConfirmationAlert: Bool = false
    @State private var number: Int = 0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            allRotas
            AddResetRow()
            Spacer()
        }
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
        .onTapGesture {
            hideKeyboard()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ClockView()
                    Spacer()
                    Text("POWIETRZE DLA ROT")
                        .bold()
                    Spacer()
                }
            }
        }
        .alert(isPresented: $vm.showAlert) {
            getAlert()
        }
        .onAppear {
            NotificationManager.instance.requestAuthorization()
            // Disabling the idle timer when this view appears (do I need this?)
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Enabling the idle timer back when this view disappears (do I need this?)
            UIApplication.shared.isIdleTimerDisabled = false
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
                RotaTableView(timersVM: TimersRowViewModel(coreVM: vm), rota: $vm.rotas[rota.number], startOrCalculateButtonActive: $vm.startOrCalculateButtonActive[rota.number], numberOfFiremans: $vm.numberOfFiremans[rota.number], endButtonActive: $vm.endButtonActive[rota.number], editData: $vm.editData[rota.number])
                //                .onChange(of: scenePhase) { newScenePhase in
                //                    if newScenePhase ==  .active {
                //                        vm.updateDurationAndRemainingTime(forRota: rota.number)
                //                    }
                //                }
                //                .onChange(of: scenePhase) { newScenePhase in
                //                    if newScenePhase ==  .background {
                //                        vm.timer.upstream.connect().cancel()
                //                    }
                //                }
                    .padding(.horizontal, 2)
            }
        }
    }
    
    
    private func getAlert() -> Alert {
        
        return Alert(
            title: Text("Błąd"),
            message: Text("Wprowadź prawidłowe dane"),
            dismissButton: .default(Text("OK")))
    }
}
