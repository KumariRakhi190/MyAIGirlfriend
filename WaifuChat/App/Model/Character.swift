//
//  Character.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import Foundation

class Character: Codable{
    
    var id: Double?
    var name: String?
    var characteristics: String?
    var imageUrl: URL?
    var modelId: String?
    
    var ethnicity: String?
    var eyesColor: String?
    var hairColor: String?
    var traits: String?
    var lastMessage: String?
    
    init(id: Double?, name: String?, characteristics: String?, imageUrl: URL?, modelId: String?){
        self.id = id
        self.name = name
        self.characteristics = characteristics
        self.imageUrl = imageUrl
        self.modelId = modelId
    }
    
    init(dict: [String: Any]? = nil){
        id = dict?["id"] as? Double
        name = dict?["name"] as? String
        imageUrl = URL(string: (dict?["imageUrl"] as? String) ?? .init())
        characteristics = dict?["characteristics"] as? String
        modelId = dict?["modelId"] as? String
    }
    
    func getProfilePicUrl() -> URL?{
        if imageUrl?.isFileURL == true{
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageUrl?.lastPathComponent ?? .init())
        }
        else{
            return imageUrl
        }
    }
    
}

