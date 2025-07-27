//
//  User.swift
//  AIGirlFriend
//
//  Created by Rakhi on 27/07/23.
//

import Foundation
import FirebaseFirestore

struct User{
    
    var name: String?
    var deviceId: String?
    var timestamp: Timestamp?
    var isSubscribed: Bool?
    
    init(name: String? = nil, deviceId: String? = nil, timestamp: Timestamp? = nil, isSubscribed: Bool?) {
        self.name = name
        self.deviceId = deviceId
        self.timestamp = timestamp
        self.isSubscribed = isSubscribed
        
    }
    
    init(dict: [String: Any]? = nil){
        name = dict?["name"] as? String
        deviceId = dict?["deviceId"] as? String
        timestamp = dict?["timestamp"] as? Timestamp
        isSubscribed = dict?["isSubscribed"] as? Bool
    }
    
}
