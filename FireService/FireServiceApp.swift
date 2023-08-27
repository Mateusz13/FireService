//
//  FireServiceApp.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 10/02/2023.
//

import SwiftUI

@main
struct FireServiceApp: App {
    
//    let vm = CoreViewModel() ??
    @StateObject private var vm = CoreViewModel()
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        MainView()
                            .environmentObject(vm)
                    }
                } else {
                    NavigationView {
                        MainView()
                            .environmentObject(vm)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
