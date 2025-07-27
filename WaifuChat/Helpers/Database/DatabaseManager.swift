//
//  DatabaseManager.swift
//  AIGirlFriend
//
//  Created by Rakhi on 25/07/23.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    private let database = Firestore.firestore()
    
    private init(){}
    
    func getCharacters(completion: @escaping(_ characters: [Character]?) ->()){
        database.collection("AIGirlfriendCharacters").order(by: "id").getDocuments { query, error in
            stopAnimating()
            if let error{
                debugPrint(error.localizedDescription)
            }
            completion(query?.documents.map({Character(dict: $0.data())}))
        }
    }
    
    func getUser(documentId: String, completion: @escaping(_ user: User?) -> Void){
        if let userDocumentId = iCloudStorage.shared.userDocumentId{
            database.collection("AIGirlfriendUsers").document(userDocumentId).getDocument { document, error in
                stopAnimating()
                if let error{
                    debugPrint(error.localizedDescription)
                }
                if let userDict = document?.data(){
                    completion(User(dict: userDict))
                }
                else{
                    completion(nil)
                }
            }
        }
        else{
            completion(nil)
        }
        
    }
    
    func addUser(user: User) {
        var ref: DocumentReference?
        ref = database.collection("AIGirlfriendUsers").addDocument(data: [
            "name": user.name ?? .init(),
            "deviceId": user.deviceId ?? .init(),
            "timestamp": FieldValue.serverTimestamp(),
            "isSubscribed": user.isSubscribed ?? false
        ]) { error in
            if let error {
                print("Error adding user: \(error)")
            } else {
                print("User added successfully")
                self.reloadUser { error in }
            }
        }
        iCloudStorage.shared.userDocumentId = ref?.documentID
    }
    
    func reloadUser(completion: @escaping(_ error: Error?) -> Void){
        if let userDocumentId = iCloudStorage.shared.userDocumentId{
            database.collection("AIGirlfriendUsers").document(userDocumentId).getDocument { document, error in
                if let error{
                    debugPrint(error.localizedDescription)
                    completion(error)
                }
                else if let userDict = document?.data(){
                    iCloudStorage.shared.currentUser = User(dict: userDict)
                }
                else if let document, document.exists == false{
                    DispatchQueue.main.async {
                        PublicAccess.shared.logoutUserAndDeleteData()
                    }
                }
                completion(nil)
            }
        }else{
            completion(nil)
            DispatchQueue.main.async {
                PublicAccess.shared.logoutUserAndDeleteData()
            }
        }
    }
    
    func changeName(newName: String, completion: @escaping(_ error: Error?)-> Void){
        let params: [String: Any] =
        [
            "name": newName
        ]
        if let userDocumentId = iCloudStorage.shared.userDocumentId{
            database.collection("AIGirlfriendUsers").document(userDocumentId).updateData(params) { error in
                self.reloadUser { error in
                    completion(error)
                }
            }
        }
        else{
            completion(nil)
        }
    }
    
    func fetchTokens(){
        database.collection("Tokens").getDocuments { query, error in
            if let error{
                debugPrint(error.localizedDescription)
            }
            if let dict = query?.documents.first?.data(){
                if let openAIToken = dict["OpenAIToken"] as? String{
                    Constants.openAIToken = openAIToken
                }
            }
        }
    }
    
    func updateSubscriptionStatus(isSubscribed: Bool, completion: @escaping(_ error: Error?)-> Void){
        let params: [String: Any] =
        [
            "isSubscribed": isSubscribed
        ]
        if let userDocumentId = iCloudStorage.shared.userDocumentId{
            database.collection("AIGirlfriendUsers").document(userDocumentId).updateData(params) { error in
                self.reloadUser { error in
                    completion(error)
                }
            }
        }
        else{
            completion(nil)
        }
    }
    
    func reloadPromptsFromDatabase(){
        database.collection("AIGirlfriendPrompts").getDocuments { query, error in
            if let error{
                debugPrint(error.localizedDescription)
            }
            if let dict = query?.documents.first?.data(){
                if let gptPromptToEnd = dict["gptPromptToEnd"] as? String{
                    Prompts.gptPromptToEnd = gptPromptToEnd
                }
                if let genericEnd = dict["genericEnd"] as? String{
                    Prompts.genericEnd = genericEnd
                }
                if let genericStartForCustomCharacter = dict["genericStartForCustomCharacter"] as? String{
                    Prompts.genericStartForCustomCharacter = genericStartForCustomCharacter
                }
                if let nsfwSelfie = dict["nsfwSelfie"] as? String{
                    Prompts.nsfwSelfie = nsfwSelfie
                }
                if let classicSelfie = dict["classicSelfie"] as? String{
                    Prompts.classicSelfie = classicSelfie
                }
                if let generalSelfiePrompt = dict["generalSelfiePrompt"] as? String{
                    Prompts.generalSelfiePrompt = generalSelfiePrompt
                }
            }
            
        }
    }
    
    //MARK: METHODS TO STORE DATA ON FIREBASE
    ///*** Please don't remove the commented code, it's the backup for storing static data on firebase in case of database-loss on firebase:- Geetam
    
//    func addPredefinedCharacters(){
//        var characters = [Character]()
//
//        characters.append(.init(id: 1,
//                                name: "Kari",
//                                characteristics: "woman, blond hair, long hair, grey eyes, russian type, white skin",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl1.jpeg?alt=media")!,
//                                modelId: "d55J1xB"))
//
//        characters.append(.init(id: 2,
//                                name: "Lily",
//                                characteristics: "woman, white hair, short hair, ponytail hair, grey eyes, asian type, white skin",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl2.jpeg?alt=media")!,
//                                modelId: "yBG2r9O"))
//
//        characters.append(.init(id: 3,
//                                name: "Lin",
//                                characteristics: "woman, black hair, long hair,black eyes, asian type, white skin",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl3.jpeg?alt=media")!,
//                                modelId: "yBG2r9O"))
//
//        characters.append(.init(id: 4,
//                                name: "Jackie",
//                                characteristics: "woman, brown hair, long hair, grey blue eyes, european type,",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl4.jpeg?alt=media")!,
//                                modelId: "woojZkD"))
//
//        characters.append(.init(id: 5,
//                                name: "Chloe",
//                                characteristics: "woman, blond hair, long hair, blue eyes, european type,",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl5.jpeg?alt=media")!,
//                                modelId: "woojZkD"))
//
//        characters.append(.init(id: 6,
//                                name: "Ida",
//                                characteristics: "woman, brown hair, short hair, green eyes, european type, freckles,",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl6.jpeg?alt=media")!,
//                                modelId: "GbEkeEP"))
//
//        characters.append(.init(id: 7,
//                                name: "Luna",
//                                characteristics: "woman, brown hair, ponytail, grey blue eyes, european type, skinny, ",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl7.jpeg?alt=media")!,
//                                modelId: "GbEkeEP"))
//
//        characters.append(.init(id: 8,
//                                name: "Mia",
//                                characteristics: "woman, Dark blond hair, short hair, grey dark eyes, eurasian type",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl8.png?alt=media")!,
//                                modelId: "mGYMaD5"))
//
//        characters.append(.init(id: 9,
//                                name: "Jojo",
//                                characteristics: "woman, brown hair, short hair, green eyes, european type, freckles,",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl9.jpeg?alt=media")!,
//                                modelId: "d55J1xB"))
//
//        characters.append(.init(id: 10,
//                                name: "Zuri",
//                                characteristics: "woman, blue and dark hair, short hair, brown eyes, indian type, indian hornament,",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl10.png?alt=media")!,
//                                modelId: "8jqEDBN"))
//
//        characters.append(.init(id: 11,
//                                name: "Jess",
//                                characteristics: "woman, brown hair, long hair, green eyes, european type,",
//                                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/AIGirlFriend-1395b.appspot.com/o/AIGirlfriendCharacters%2FGirl11.png?alt=media")!,
//                                modelId: "woojZkD"))
//
//
//        for character in characters {
//            let params: [String: Any] =
//            [
//                "id": character.id!,
//                "name": character.name!,
//                "characteristics": character.characteristics!,
//                "imageUrl": character.imageUrl!.absoluteString,
//                "modelId": character.modelId!
//
//            ]
//            database.collection("AIGirlfriendCharacters").addDocument(data: params, completion: nil)
//        }
//    }

}
