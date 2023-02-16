//
//  HideKeyboard.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
