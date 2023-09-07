//
//  Timer.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 06/09/2023.
//

//import Foundation
//import Combine
//
//class RotaTimerManager {
//
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    var cancellables = Set<AnyCancellable>()
//
//    // Explicitly declare currentRota as a variable
//    private var currentRota: Rota?
//    private var endButtonActive: Bool = false
//
//    func setupDurationAndRemainingTimeBinding(for rota: Rota, endButtonActive: Bool) -> AnyCancellable {
//        self.currentRota = rota
//        self.endButtonActive = endButtonActive
//
//        return timer.sink { [weak self] _ in
//            guard let self = self, var currentRota = self.currentRota else { return }
//
//            if !self.endButtonActive {
//                // If end button is not active, calculate and update duration and remaining time
//                if let startTime = currentRota.startTime {
//                    let elapsedTime = Date().timeIntervalSince(startTime)
//                    let remainingTime = (currentRota.duration ?? 0) - elapsedTime
//
//                    // Update rota object's properties or post notifications, etc.
//                    currentRota.exitDate = Date().addingTimeInterval(remainingTime)
//
//
//
//                    // Assign back the modified rota to the manager's rota
//                    self.currentRota = currentRota
//                    // Here, you can also send events, update UI elements or other properties if needed.
//                }
//            } else {
//                // Handle logic when endButton is active
//                // Maybe finalize the rota details, stop timers, etc.
////                self.finalizeRota()
//            }
//        }
//    }
//
////    private func finalizeRota() {
////        // Logic to finalize the rota when end button is active
////        // Example:
////        currentRota?.endTime = Date()
////        // Here, you can also send events, post notifications, update UI elements, etc.
////    }
//
//    // Add a deinitializer to ensure all cancellables are cancelled when the manager is deallocated.
//    deinit {
//        cancellables.forEach { $0.cancel() }
//    }
//}
//
