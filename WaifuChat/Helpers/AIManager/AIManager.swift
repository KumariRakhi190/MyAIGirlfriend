//
//  AIManager.swift
//  AIGirlFriend
//
//  Created by Rakhi on 26/07/23.
//

import Foundation

final class AIManager{
    
    static let shared = AIManager()
    
    private init(){}
    
    func generateCharacter(character: Character?, photoGenerationType: PhotoGenerationType? = nil, completion: @escaping(_ imageUrl: URL?) ->()){
        
        var params: [String: Any] =
        [
            "access_token": Constants.sinkinAccessToken,
            "num_images": 1,
            "model_id": character?.modelId ?? Constants.sinkinModelIds.randomElement()!,
            "image_strength": 0.95
        ]
        
        //        if let imageUrl = character?.getProfilePicUrl(), let data = try? Data(contentsOf: imageUrl){
        //            params["init_image_file"] = data
        //        }
        
        var prompt = String()
        
        if let eyesColor = character?.eyesColor, let hairColor = character?.hairColor, let ethnicity = character?.ethnicity, let traits = character?.traits{
            prompt =  "\(photoGenerationType != nil ? "\(Prompts.generalSelfiePrompt), " : "")\(Prompts.genericStartForCustomCharacter), \(ethnicity) ethnicity, \(eyesColor) eyes color, \(hairColor) hair color, \(traits) traits, \(photoGenerationType == .nsfw ? Prompts.nsfwSelfie : Prompts.classicSelfie)), \(Prompts.genericEnd)"
        }
        else if let characteristics = character?.characteristics{
            prompt = "\(photoGenerationType != nil ? "\(Prompts.generalSelfiePrompt), " : "")\(characteristics), \(characteristics), \(photoGenerationType == .nsfw ? Prompts.nsfwSelfie : Prompts.classicSelfie), \(Prompts.genericEnd), \(Prompts.genericEnd)"
            
        }
        
        params["prompt"] = prompt
        
        APIManager.shared.postFormData(url: Constants.sinkinUrl, formData: params) { data, error in
            if let data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let imageUrlString = (jsonObject["images"] as? [String])?.first,
               let url = URL(string: imageUrlString){
                ImageDownloader().downloadImage(from: url) { imageUrl, error in
                    completion(imageUrl)
                }
            }
            else{
                completion(nil)
            }
        }
        
    }
}
