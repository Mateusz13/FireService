//
//  TermsView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2025.
//

import SwiftUI

struct TermsView: View {
    @Binding var showTermsAlert: Bool
    @Binding var hasAcceptedTerms: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Regulamin oraz Instrukcja Aplikacji")
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Potwierdzam, że przeczytałem i akceptuję:")
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    Button {
                        if let url = URL(string: "https://doc-hosting.flycricket.io/topword-warunki-uzytkowania/ed9c3df8-3dca-416c-ae52-100a69121e24/terms") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Regulamin")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    
                    Text("oraz")
                    
                    Button {
                        if let url = URL(string: "https://doc-hosting.flycricket.io/topword-polityka-prywatnosci/34fd1805-714c-45b6-a3ba-8d86f28a4087/privacy") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Instrukcję Aplikacji")
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
                .multilineTextAlignment(.center)
            }
            .padding(.vertical)
            
            HStack(spacing: 20) {
                Button("Wyjdź") {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                .font(.body)
                .buttonStyle(.bordered)
                .background(.red)
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.horizontal)
                
                Button("Potwierdzam") {
                    hasAcceptedTerms = true
                    showTermsAlert = false
                }
                .font(.body)
                .buttonStyle(.bordered)
                .background(.blue)
                .cornerRadius(10)
                .foregroundColor(.green)
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
}

#Preview {
    TermsView(showTermsAlert: .constant(true), hasAcceptedTerms: .constant(false))
}
