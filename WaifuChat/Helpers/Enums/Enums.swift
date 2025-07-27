//
//  Enums.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import Foundation

enum NameControllerFor{
    case me
    case her
}

enum selectionControllerFor{
    case ethnicity
    case eyesColor
    case hairColor
    case traits
    
    var next: Self?{
        switch self {
            case .ethnicity:
                return .eyesColor
            case .eyesColor:
                return .hairColor
            case .hairColor:
                return .traits
            case .traits:
                return nil
        }
    }
}

enum CornerOptions {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case all
    case none
}

enum MessageRoleType: Codable{
    case me
    case other
    case system
}

enum TaBarItem{
    case chat
    case discover
    case create
    case profile
}

enum MessageType: Codable{
    case image
    case text
}

enum PhotoGenerationType: Codable{
    case classic
    case nsfw
}
