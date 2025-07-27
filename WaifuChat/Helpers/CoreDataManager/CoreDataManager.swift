//
//  CoreDataManager.swift
//  AIGirlFriend
//
//  Created by Rakhi on 31/07/23.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(){}
    
    func saveMessage(characterId: Double, message: Message) {
        let entity = NSEntityDescription.entity(forEntityName: "Messages", in: context)!
        let newMessage = NSManagedObject(entity: entity, insertInto: context)
        do {
            let jsonData = try JSONEncoder().encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)
            newMessage.setValue(jsonString, forKey: "message")
            newMessage.setValue(message.timestamp, forKey: "timestamp")
            newMessage.setValue(characterId, forKey: "characterId")
            try context.save()
        } catch {
            print("Failed to save message: \(error)")
        }
    }
    
    func getMessages(characterId: Double) -> [Message] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        fetchRequest.predicate = NSPredicate(format: "characterId == %@", NSNumber(value: characterId))
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let result = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            let messages = result?.compactMap { object -> Message? in
                guard let json = object.value(forKey: "message") as? String else { return nil }
                do {
                    let jsonData = Data(json.utf8)
                    let message = try JSONDecoder().decode(Message.self, from: jsonData)
                    return message
                } catch {
                    print("Failed to decode message: \(error)")
                    return nil
                }
            } ?? []
            
            return messages
        } catch {
            print("Failed to fetch messages: \(error)")
            return []
        }
    }
    
    func clearMessagesFor(characterId: Double) {
        
        let messages = getMessages(characterId: characterId)
        for message in messages.filter({$0.imageUrl != nil}) {
            if let imageUrl = message.getMessageImageUrl(){
                deleteImage(at: imageUrl)
            }
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        fetchRequest.predicate = NSPredicate(format: "characterId == %@", NSNumber(value: characterId))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            addLastMessageToCharacter(withId: characterId, message: .init())
        } catch {
            print("Failed to clear messages: \(error)")
        }
    }
    
    func deleteAllMessages(){
        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                    print("File deleted at path: \(fileURL.absoluteString)")
                }
            } catch {
                print("Error while clearing files: \(error)")
            }
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to clear all messages: \(error)")
        }
    }
    
    func deleteImage(at url: URL) {
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(url.lastPathComponent) else {return}
        do {
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
                print("Image deleted")
            }
        } catch {
            print("Failed to delete image at \(url): \(error)")
        }
    }
    
    
    func getCharacters() -> [Character]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
        let sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let result = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            let characters = result?.compactMap { object -> Character? in
                guard let json = object.value(forKey: "character") as? String else { return nil }
                
                do {
                    let jsonData = Data(json.utf8)
                    let character = try JSONDecoder().decode(Character.self, from: jsonData)
                    return character
                } catch {
                    print("Failed to decode character: \(error)")
                    return nil
                }
            } ?? []
            
            return characters
        } catch {
            print("Failed to fetch characters: \(error)")
            return []
        }
        
    }
    
    func removeCharacters(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to remove characters: \(error)")
        }
    }
    
    func getCharacter(characterId: Double) -> Character?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: characterId))
        do {
            let result = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let characterJson = ((result?.first)?.value(forKey: "character") as? String)?.data(using: .utf8){
                do {
                    let character = try JSONDecoder().decode(Character.self, from: characterJson)
                    return character
                } catch {
                    print("Failed to decode character: \(error)")
                    return nil
                }
            }
            
        } catch {
            print("Failed to fetch character: \(error)")
            return nil
        }
        return nil
    }
    
    func addCharacter(character: Character){
        let entity = NSEntityDescription.entity(forEntityName: "Characters", in: context)!
        let newCharacter = NSManagedObject(entity: entity, insertInto: context)
        do {
            let jsonData = try JSONEncoder().encode(character)
            let jsonString = String(data: jsonData, encoding: .utf8)
            newCharacter.setValue(jsonString, forKey: "character")
            newCharacter.setValue(character.id, forKey: "id")
            newCharacter.setValue(PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), forKey: "modifiedAt")
            try context.save()
        } catch {
            print("Failed to add character: \(error)")
        }
    }
    
    func renameCharacter(withId id: Double, to newName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let character = fetchResults?.first {
                let characterData = character.value(forKey: "character") as! String
                if let decodedCharacter = try? JSONDecoder().decode(Character.self, from: characterData.data(using: .utf8)!) {
                    decodedCharacter.name = newName
                    let jsonData = try JSONEncoder().encode(decodedCharacter)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    character.setValue(jsonString, forKey: "character")
                    try context.save()
                    print("Character renamed successfully!")
                } else {
                    print("Failed to decode character data.")
                }
            } else {
                print("Character with ID \(id) not found.")
            }
        } catch {
            print("Error while renaming character: \(error)")
        }
    }
    
    func addLastMessageToCharacter(withId id: Double, message: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let character = fetchResults?.first {
                let characterData = character.value(forKey: "character") as! String
                if let decodedCharacter = try? JSONDecoder().decode(Character.self, from: characterData.data(using: .utf8)!) {
                    decodedCharacter.lastMessage = message
                    let jsonData = try JSONEncoder().encode(decodedCharacter)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    character.setValue(jsonString, forKey: "character")
                    character.setValue(PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), forKey: "modifiedAt")
                    try context.save()
                    print("Message added successfully!")
                } else {
                    print("Failed to decode character data.")
                }
            } else {
                print("Character with ID \(id) not found.")
            }
        } catch {
            print("Error while adding last message: \(error)")
        }
    }
    
    func updateMessageImageUrl(messageTimestamp: Double, newUrl: URL){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        fetchRequest.predicate = NSPredicate(format: "timestamp == %@", NSNumber(value: messageTimestamp))
        fetchRequest.fetchLimit = 1
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let message = fetchResults?.first {
                let messageData = message.value(forKey: "message") as! String
                if var decodedMessage = try? JSONDecoder().decode(Message.self, from: messageData.data(using: .utf8)!) {
                    decodedMessage.imageUrl = newUrl
                    let jsonData = try JSONEncoder().encode(decodedMessage)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    message.setValue(jsonString, forKey: "message")
                    try context.save()
                    print("Message modified successfully!")
                } else {
                    print("Failed to decode message data.")
                }
            } else {
                print("Message with timestamp \(messageTimestamp) not found.")
            }
        } catch {
            print("Error while modifying message: \(error)")
        }
    }
    
}
