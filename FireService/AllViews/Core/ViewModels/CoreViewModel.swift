//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


class CoreViewModel: ObservableObject {
    
    @Published var allRotas: [MainTableModel] = []
    
    @Published var name: [String] = ["", "", ""]
    @Published var entryPressure: [String] = ["", "", ""]
    @Published var firstCheckPressure: [String] = ["", "", ""]
    @Published var secondCheckPressure: [String] = ["", "", ""]
    
    @Published var entryTime: [String] = ["", "", ""]
    @Published var firstCheckTime: [String] = ["", "", ""]
    @Published var secondCheckTime: [String] = ["", "", ""]
    
}

