//
//  Date.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 25/03/2023.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func getFormattedDateToHHmm() -> String {
        return getFormattedDate(format: "HH:mm")
    }
    
    func getFormattedDateToHHmmSS() -> String {
        return getFormattedDate(format: "HH:mm:ss")
    }
}


