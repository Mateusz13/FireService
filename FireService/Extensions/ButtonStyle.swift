//
//  ButtonStyle.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2025.
//

import SwiftUI

struct prominentButton: ViewModifier {
    
    let foregroundColor: Color
    let backgroundColor: Color
    let overlayColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(height: 40)
            .frame(maxWidth: 400)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .background(.thickMaterial)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(overlayColor, lineWidth: 1)
            )
    }
}

extension View {
    func customButtonStyle(foregroundColor: Color, backgroundColor: Color, overlayColor: Color) -> some View {
        modifier(prominentButton(foregroundColor: foregroundColor, backgroundColor: backgroundColor, overlayColor: overlayColor))
    }
}
