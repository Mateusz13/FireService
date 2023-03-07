//
//  FireServiceApp.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 10/02/2023.
//

import SwiftUI

@main
struct FireServiceApp: App {
    
    @StateObject private var vm = CoreViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
                    .environmentObject(vm)
            }
        }
    }
}
