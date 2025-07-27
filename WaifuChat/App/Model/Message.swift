//
//  Message.swift
//  AIGirlFriend
//
//  Created by Rakhi on 28/07/23.
//

import Foundation

struct Message: Codable{
    
    var characterId: Double?
    var message: String?
    var messageType: MessageType?
    var messageRoleType: MessageRoleType?
    var imageUrl: URL?
    var photoGenerationType: PhotoGenerationType?
    var timestamp: Double
    var isSilent: Bool = false
    
    func getMessageImageUrl() -> URL?{
        if imageUrl?.isFileURL == true{
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageUrl?.lastPathComponent ?? .init())
        }
        else{
            return imageUrl
        }
    }
    
}
