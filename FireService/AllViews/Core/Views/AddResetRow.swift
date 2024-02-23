//
//  AddResetRow.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 23/02/2024.
//

import SwiftUI

struct AddResetRow: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    @State private var cleanConfirmationAlert: Bool = false
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.easeIn) {
                    vm.addRota()
                }
            } label: {
                Label("", systemImage: "plus.app.fill")
                    .font(.largeTitle)
            }
            .disabled(vm.numberOfRotas == 15)
            .foregroundColor(vm.numberOfRotas == 15 ? .gray : .green)
            .padding()
            Button {
                cleanConfirmationAlert = true
            } label: {
                Text("Wyczyść")
            }
            .font(.body)
            .buttonStyle(.bordered)
            .background(.orange)
            .cornerRadius(10)
            .foregroundColor(.black)
            .alert("Zakończyć wszystkie akcje i wyczyścić dane?", isPresented: $cleanConfirmationAlert) {
                Button("Tak", role: .destructive) { vm.reset() }
                Button("Nie", role: .cancel) { }
            }
            Spacer()
        }
    }
}

#Preview {
    AddResetRow()
        .environmentObject(CoreViewModel())
}
