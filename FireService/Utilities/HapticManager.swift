//
//  HapticManager.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 08/04/2023.
//

import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notifiaction(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
