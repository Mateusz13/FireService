//
//  NotificationManager.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 04/04/2023.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
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
        UNUserNotificationCenter.current().delegate = self
    }
    
    func scheduleFirstMeasurementNotification(forRota: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = "Upłyneło 5 minut od wejścia!"
        content.body = "Czas na pierwszy pomiar Roty \(forRota == 2 ? "RIT" : "\(forRota+1)")"
        content.sound = .default
        //content.badge = 1
        //NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        // time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300.0, repeats: false)
        
        // calendar
        //        var dateComponents = DateComponents()
        //        dateComponents.hour = 8
        //        dateComponents.minute = 0
        //        dateComponents.weekday = 2
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
        let request = UNNotificationRequest(
            identifier: "FirstM\(forRota)",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleExitNotification(time: TimeInterval, forRota: Int, minimalPressure: Double) {
        
        let content = UNMutableNotificationContent()
        content.title = minimalPressure == 50.0 ? "Pozostało 5 minut do gwizdka!" : "Pozostało 5 minut do 0 BAR!!!"
        content.body = "Dla Roty \(forRota == 2 ? "RIT" : "\(forRota+1)")"
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
    
    func cancelFirstMeasurementNotification(forRota: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["FirstM\(forRota)"])
    }
    
    func cancelExitNotification(forRota: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(forRota)])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Specify that the notification should be shown also when the app is in the foreground
        completionHandler([.banner, .sound])
    }
}
