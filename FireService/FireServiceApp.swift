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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

//    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
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
        }
//        .onChange(of: scenePhase) { newScenePhase in
//            if newScenePhase == .inactive {
//                NotificationManager.instance.cancelAllNotifications()
//            }
//        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
//        NotificationManager.instance.cancelAllNotifications()
    
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
