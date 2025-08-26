//
//  MainView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI

// MARK: - Constants
private struct MainViewConstants {
    static let overlayOpacity: Double = 0.3
    static let horizontalPadding: CGFloat = 2
    static let appTitle = "POWIETRZE DLA RATOWNIKÓW"
    static let errorTitle = "Błąd"
    static let errorMessage = "Wprowadź prawidłowe dane"
    static let dismissButtonTitle = "OK"
}

struct MainView: View {
    
    // MARK: - Environment & State
    @EnvironmentObject private var vm: CoreViewModel
    @State private var showTermsAlert: Bool = false
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            mainContent
            termsOverlay
        }
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                toolbarContent
            }
        }
        .alert(isPresented: $vm.showAlert) {
            errorAlert
        }
        .onAppear {
            handleViewAppearance()
        }
        .onDisappear {
            handleViewDisappearance()
        }
    }
}

// MARK: - View Components
private extension MainView {
    
    var mainContent: some View {
        ScrollView(.vertical, showsIndicators: true) {
            allRotas
            AddResetRow()
            Spacer()
        }
    }
    
    @ViewBuilder
    var termsOverlay: some View {
        if showTermsAlert {
            Color.black
                .opacity(MainViewConstants.overlayOpacity)
                .edgesIgnoringSafeArea(.all)
            
            TermsView(
                showTermsAlert: $showTermsAlert,
                hasAcceptedTerms: $hasAcceptedTerms
            )
        }
    }
    
    var toolbarContent: some View {
        HStack {
            ClockView()
            Spacer()
            Text(MainViewConstants.appTitle)
                .bold()
            Spacer()
        }
    }
    
    var allRotas: some View {
        ForEach(vm.rotas) { rota in
            VStack {
                if isValidRotaIndex(rota.number) {
                    RotaTableView(
                        rota: $vm.rotas[rota.number],
                        startOrCalculateButtonActive: $vm.startOrCalculateButtonActive[rota.number],
                        numberOfFiremans: $vm.numberOfFiremans[rota.number],
                        endButtonActive: $vm.endButtonActive[rota.number],
                        editData: $vm.editData[rota.number]
                    )
                    .padding(.horizontal, MainViewConstants.horizontalPadding)
                } else {
                    Text("Błąd konfiguracji, zresetuj aplikację")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
    }
    
    var errorAlert: Alert {
        Alert(
            title: Text(MainViewConstants.errorTitle),
            message: Text(MainViewConstants.errorMessage),
            dismissButton: .default(Text(MainViewConstants.dismissButtonTitle))
        )
    }
}

// MARK: - Helper Methods
private extension MainView {
    
    func handleViewAppearance() {
        NotificationManager.instance.requestAuthorization()
        UIApplication.shared.isIdleTimerDisabled = true
        
        if !hasAcceptedTerms {
            showTermsAlert = true
        }
    }
    
    func handleViewDisappearance() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func isValidRotaIndex(_ index: Int) -> Bool {
        return index < vm.rotas.count &&
               index < vm.startOrCalculateButtonActive.count &&
               index < vm.numberOfFiremans.count &&
               index < vm.endButtonActive.count &&
               index < vm.editData.count
    }
}

// MARK: - Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
                .environmentObject(CoreViewModel())
        }
    }
}
