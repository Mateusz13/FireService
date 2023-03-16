//
//  Double.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 07/03/2023.
//

import Foundation

extension Double {
    
    /// Converts a Double into String with 2 decimal
    /// ```
    /// Convert 1.12345 to "1.23"
    /// ```
    func asStringWith2Decimal() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double/TimeInterval into String
    /// ```
    /// Convert 1.5000 to "1:30:00"
    /// ```
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        guard self.isFinite else {
            return "error"
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? "error"
      }
}
