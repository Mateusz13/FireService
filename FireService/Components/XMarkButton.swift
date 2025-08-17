//
//  XMarkButton.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 14/02/2025.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    XMarkButton()
}
