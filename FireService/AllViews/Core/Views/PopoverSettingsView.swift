//
//  PopoverSettingsView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 14/02/2025.
//

import SwiftUI

struct PopoverSettingsView: View {
    
    @State private var showContactSheet: Bool = false
    
    var body: some View {
        if #available(iOS 16.4, *) {
            AllSettingsButtons
            .padding()
            .presentationCompactAdaptation((.popover))
            .sheet(isPresented: $showContactSheet) {
                ContactUsView()
                    .presentationDetents([.medium])
            }
        } else {
            AllSettingsButtons
            .padding()
            .sheet(isPresented: $showContactSheet) {
                ContactUsView()
            }
        }
    }
    
    private var AllSettingsButtons: some View {
        VStack(alignment: .leading) {
            Button {
                showContactSheet = true
            } label: {
                SettingsRowView(imageName: "envelope.fill", title: "Skontaktuj się z nami", tintColor: .gray, textColor: Color.black)
                    .font(.largeTitle)
            }
            Button {
                if let url = URL(string: "https://doc-hosting.flycricket.io/topword-polityka-prywatnosci/34fd1805-714c-45b6-a3ba-8d86f28a4087/privacy") {
                    UIApplication.shared.open(url)
                }
            } label: {
                SettingsRowView(imageName: "globe", title: "Polityka Prywatności", tintColor: .gray, textColor: .blue)
            }
            Button {
                if let url = URL(string: "https://doc-hosting.flycricket.io/topword-warunki-uzytkowania/ed9c3df8-3dca-416c-ae52-100a69121e24/terms") {
                    UIApplication.shared.open(url)
                }
            } label: {
                SettingsRowView(imageName: "globe", title: "Warunki użytkowania", tintColor: .gray, textColor: .blue)
            }
        }
    }
}

#Preview {
    PopoverSettingsView()
}
