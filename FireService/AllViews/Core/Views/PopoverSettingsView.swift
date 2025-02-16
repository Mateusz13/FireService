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
                if let url = URL(string: "https://drive.google.com/file/d/1L_tH51lGlY4lG9bE5LToaRRP81sArzTP/view?usp=share_link") {
                    UIApplication.shared.open(url)
                }
            } label: {
                SettingsRowView(imageName: "globe", title: "INSTRUKCJA APLIKACJI", tintColor: .gray, textColor: .blue)
            }
            Button {
                if let url = URL(string: "https://doc-hosting.flycricket.io/pdr-regulamin/df0c0984-7968-41d8-b8a1-bc664432ff34/terms") {
                    UIApplication.shared.open(url)
                }
            } label: {
                SettingsRowView(imageName: "globe", title: "REGULAMIN", tintColor: .gray, textColor: .blue)
            }
            Button {
                showContactSheet = true
            } label: {
                SettingsRowView(imageName: "envelope.fill", title: "Skontaktuj się z nami", tintColor: .gray, textColor: Color.black)
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    PopoverSettingsView()
}
