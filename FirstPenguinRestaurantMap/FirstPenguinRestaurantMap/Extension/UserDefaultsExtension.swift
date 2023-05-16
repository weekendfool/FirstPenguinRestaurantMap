//
//  UserDefaultsExtension.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/17.
//

import Foundation

// userDefaultの拡張

extension UserDefaults {
    

    func setResutaurantData<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else {
            print("can not Encode to JSON")
            return
        }
        set (data, forKey: key)
    }
    
    func getResutaurantData<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }
        
        return try? JSONDecoder().decode(type, from: data)
    }
}
