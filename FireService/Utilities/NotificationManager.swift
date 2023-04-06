//
//  NotificationManager.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 04/04/2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager() // Singleton
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("Permission granted")
            }
        }
    }
    
    func scheduleMeasurement1Notification() {
        
        
        let content = UNMutableNotificationContent()
        content.title = "Upłyneło 5 minut od wejścia!"
//        content.subtitle = "Czas na pierwszy pomiar"
        content.body = "Czas na pierwszy pomiar"
        content.sound = .default
        //content.badge = 1
        //NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
                
        // time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7.0, repeats: false)
 
        // calendar
//        var dateComponents = DateComponents()
//        dateComponents.hour = 8
//        dateComponents.minute = 0
//        dateComponents.weekday = 2
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)

    }
    
    func scheduleExitNotification(time: TimeInterval, forRota: Int) {
        
        
        let content = UNMutableNotificationContent()
        content.title = "Pozostało 5 minut do wyjścia!"
//        content.body = ""
        content.sound = .default
                
        // time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
 
        // calendar
//        var dateComponents = DateComponents()
//        dateComponents.hour = 8
//        dateComponents.minute = 0
//        dateComponents.weekday = 2
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        
        let request = UNNotificationRequest(
            identifier: String(forRota),
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)

    }
    
    func cancelExitNotification(forRota: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(forRota)])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

