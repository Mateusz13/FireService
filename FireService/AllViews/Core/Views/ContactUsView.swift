//
//  ContactUsView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 14/02/2025.
//

import SwiftUI

struct ContactUsView: View {
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack {
                ContactUsView
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            XMarkButton()
                        }
                    }
            }
        } else {
            ContactUsView
        }
    }
    
    private var ContactUsView: some View {
        VStack {
            Text("Masz pytania?")
            Text("Masz propozycję jak ulepszyć aplikację?")
            Text("Napisz do nas!")
                .bold()
                .padding(.top)
            Text("powietrzedlaratownikow@gmail.com")
                .padding()
        }
    }
}

#Preview {
    ContactUsView()
}
