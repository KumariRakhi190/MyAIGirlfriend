//
//  iCloudStorage.swift
//  AIGirlFriend
//
//  Created by Rakhi on 26/07/23.
//

import Foundation

final class iCloudStorage{
    
    private var ldName = "ldName"
    private var ldUserDocumentId = "ldUserDocumentId"
    
    private var keyStore = NSUbiquitousKeyValueStore()
    
    static let shared = iCloudStorage()
    
    var currentUser: User?
    
    var name: String?{
        get{
            keyStore.string(forKey: ldName)
        }
        set{
            keyStore.set(newValue, forKey: ldName)
        }
    }
    
    var userDocumentId: String?{
        get{
            keyStore.string(forKey: ldUserDocumentId)
        }
        set{
            keyStore.set(newValue, forKey: ldUserDocumentId)
            keyStore.synchronize()
        }
    }
    
    private init(){}
    
}

