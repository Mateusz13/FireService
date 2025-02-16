//
//  MainView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI
import UIKit

struct MainView: View {
    @EnvironmentObject private var vm: CoreViewModel
    @State private var currentTime = ""
    @State private var endConfirmationAlert: Bool = false
    @State private var number: Int = 0
    @State private var showTermsAlert: Bool = false
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                allRotas
                AddResetRow()
                Spacer()
            }
            if showTermsAlert {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                TermsView(showTermsAlert: $showTermsAlert, hasAcceptedTerms: $hasAcceptedTerms)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ClockView()
                    Spacer()
                    Text("POWIETRZE DLA RATOWNIKÓW")
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
            // modifier ensures that the screen will not automatically dim or turn off
            UIApplication.shared.isIdleTimerDisabled = true
            if !hasAcceptedTerms {
                showTermsAlert = true
            }
        }
        .onDisappear {
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
                RotaTableView(rota: $vm.rotas[rota.number],
                              startOrCalculateButtonActive: $vm.startOrCalculateButtonActive[rota.number],
                              numberOfFiremans: $vm.numberOfFiremans[rota.number],
                              endButtonActive: $vm.endButtonActive[rota.number],
                              editData: $vm.editData[rota.number])
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
