//
//  UserDefaultsManager.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 04/09/2023.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    func save<T: Encodable>(_ value: T, forKey key: String) {
        if let encodedData = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    func retrieve<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
