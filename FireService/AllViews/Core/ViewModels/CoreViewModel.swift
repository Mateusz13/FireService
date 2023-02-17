//
//  CoreViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2023.
//

import Foundation
import Combine


class CoreViewModel: ObservableObject {
    
    
    @Published var allRotas: [Fireman] = []
    
    @Published var name: [String] = ["", "", ""]
    @Published var pressure0: [String] = ["", "", ""]
    @Published var pressure1: [String] = ["", "", ""]
    @Published var pressure2: [String] = ["", "", ""]
    
    @Published var time0: [String] = ["", "", ""]
    @Published var time1: [String] = ["", "", ""]
    @Published var time2: [String] = ["", "", ""]
    
    
    
}

