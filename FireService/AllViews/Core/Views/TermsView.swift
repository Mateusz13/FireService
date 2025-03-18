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
                            UIApplication.shared.open(Link.regulationLink)
                    } label: {
                        Text("Regulamin")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    
                    Text("oraz")
                    
                    Button {
                            UIApplication.shared.open(Link.instructionLink)
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
                Button {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                } label: {
                    Text("Wyjdź")
                        .customButtonStyle(foregroundColor: .white, backgroundColor: .red, overlayColor: .red)
                }
                Button {
                    hasAcceptedTerms = true
                    showTermsAlert = false
                } label: {
                    Text("Potwierdzam")
                        .customButtonStyle(foregroundColor: .white, backgroundColor: .green, overlayColor: .green)
                }
            }
            .padding(.vertical)
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
