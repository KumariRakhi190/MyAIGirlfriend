//
//  APIManager.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    func postFormData(url: URL, formData: [String: Any], completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        debugPrint(formData)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = createFormDataBody(formData: formData, boundary: boundary)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            debugPrint("response:\n" + (String(data: data ?? .init(), encoding: .utf8) ?? .init()))
            completion(data, error)
        }
        task.resume()
    }
    
    private func createFormDataBody(formData: [String: Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            if let data = value as? Data {
                let mimetype = "application/octet-stream"
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            } else {
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    func sendMessage(characterId: Double, message: Message, completion: @escaping(_ error: GPTError?, _ message: Message?) -> ()){
        
        var messageHistoryToSend: [Message] = CoreDataManager.shared.getMessages(characterId: characterId).filter({$0.messageType == .text})
        
        let lastTenMessages = messageHistoryToSend.suffix(10)
        
        messageHistoryToSend.removeAll(where: {$0.isSilent == false})
        
        messageHistoryToSend.append(contentsOf: lastTenMessages)
        
        messageHistoryToSend.append(message)
        
        CoreDataManager.shared.saveMessage(characterId: characterId, message: message)
        
        let parameterModel = GPTParameterModel(messages: messageHistoryToSend.compactMap({ message in
            GPTMessage(content: message.message, role: message.messageRoleType == .me ? .user : message.messageRoleType == .system ? .system : .assistant)
        }))
        
        let postData = try! JSONEncoder().encode(parameterModel)
        debugPrint(parameterModel)
        
        var request = URLRequest(url: Constants.openAIAPIURL,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.openAIToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.init(message: "Server error", code: nil), nil)
                return
            }
            debugPrint(String(data: data, encoding: .utf8) as Any)
            guard let decodedModel = try? JSONDecoder().decode(GPTResponseModel.self, from: data) else {
                completion(.init(message: "Model failed", code: nil), nil)
                return }
            if decodedModel.error?.code == .contextLengthExceeded || decodedModel.error?.code == .rateLimitExceeded{
                completion(decodedModel.error, nil)
            }
            else if let message = decodedModel.choices?.first?.message{
                let message = Message(characterId: characterId, message: message.content, messageType: .text, messageRoleType: message.role == .assistant ? .other : .me, imageUrl: nil, photoGenerationType: nil, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init())
                CoreDataManager.shared.saveMessage(characterId: characterId, message: message)
                CoreDataManager.shared.addLastMessageToCharacter(withId: characterId, message: message.message ?? .init())
                completion(nil, message)
            }
            else{
                completion(.init(message: "Server error", code: nil), nil)
            }
        }
        task.resume()
    }
    
    
}
