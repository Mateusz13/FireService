//
//  SettingsRowView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 14/02/2025.
//

import SwiftUI

struct SettingsRowView: View {
    
    let imageName: String
    let title: String
    let tintColor: Color
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .frame(minWidth: 30)
                .foregroundColor(tintColor)
            Text(title)
                .font(.body)
                .foregroundColor(textColor)
        }
        .padding(.vertical, 6)
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray), textColor: .black)
    }
}
