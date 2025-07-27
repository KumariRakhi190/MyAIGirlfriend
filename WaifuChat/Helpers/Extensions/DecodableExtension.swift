//
//  DecodableExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 26/07/23.
//

import Foundation

extension Decodable{
    static func fromJSONData(jsonData: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: jsonData)
        } catch {
            print("Error converting JSON to struct: \(error)")
            return nil
        }
    }
}
