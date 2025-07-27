//
//  EncodableExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 26/07/23.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            print("Error converting struct to JSON data: \(error)")
            return nil
        }
    }
    
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("Error converting struct to dictionary: \(error)")
            return nil
        }
    }
}
