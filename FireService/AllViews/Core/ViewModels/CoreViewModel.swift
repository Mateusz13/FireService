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
    
    @Published var name1: [String] = ["", "", ""]
    @Published var entryPressure1: [String] = ["", "", ""]
    @Published var firstCheckPressure1: [String] = ["", "", ""]
    @Published var secondCheckPressure1: [String] = ["", "", ""]
    
}

