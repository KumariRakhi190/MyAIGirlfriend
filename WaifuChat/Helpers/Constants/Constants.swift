//
//  Constants.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import Foundation

class Constants{
    
    static let mixPanelToken = "6ec5e5d103a0f2a332ddf85ec3333e46"
    
    static let purchaseProductId = "premiumyearly"
    static let secretKey = "0e96ffd671b243368b87efe639aee933"
    
    static let openAIAPIURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    static let sinkinUrl = URL(string: "https://sinkin.ai/api/inference")!
    static let sinkinAccessToken = "0d37decd79cb4631960a80c8e63537b4"
    static var openAIToken = String()
    static let sinkinModelIds = ["woojZkD", "d55J1xB", "yBG2r9O", "yBG2r9O", "woojZkD", "woojZkD", "GbEkeEP", "GbEkeEP", "mGYMaD5", "d55J1xB", "8jqEDBN"]
    
    static let loadingCharacter = "Loading character..."
    
    static let whatsHerName = "What’s her name?"
    static let howWouldLikeToNameYourGirlfriend = "What name would you like to give your girlfriend?"
    static let typeHerName = "Type Her Name"
    static let clientEmail = "contact@rimoneholding.com"
    
    static let whatsUserName = "What should I call you?"
    static let whichNameShouldIRemember = "Which name should I whisper when I miss you?"
    static let typeUserName = "Your lovely name"
    
    static let gettingYourAccount = "Getting your account..."
    
    static let privacyPolicyUrl = URL(string: "https://rimoneholding.com/privacy-policy")!
    static let termsOfUseUrl = URL(string: "https://rimoneholding.com/terms-of-use")!
    
    static let selectEthnicity = "Select Ethnicity"
    static let selectEyeColor = "Select Eyes Color"
    static let selectHairColor = "Select Hair Color"
    static let changeName = "Change Name"
    static let done = "Done"
    static let cancel = "Cancel"
    static let youAskForNSFWSelfie = "You ask for a NSFW Selfie"
    static let youAskForClassicSelfie = "You ask for a Classic Selfie"
    static let somethingWentWrong = "Something went wrong"
    static let retry = "Retry"
    static let okay = "Okay"
    static let continue_ = "Continue"
    static let classicPhoto = "Classic Photo 📷"
    static let nsfwPhoto = "NSFW Photo ❤️‍🔥"
    static let insufficientCoins = "Insufficient Coins"
    static let exceededMessageLimit = "Oops! It seems like we've exceeded the conversation limit. To continue the chat smoothly, please restart the conversation with a shorter message. Thank you!"
    static let error = "Error"
    static let serverError = "Sever Error"
    static let restart = "Restart"
    
    static let youCantChangeNameOfPreDefinedCharacter = "You can't change name of pre-defined character."
    
    
    static let limitReachedTitle = "Limit Reached"
    static let limitReachedSelfie = "You reached your selfie limit for today. Try Premium for unlimited selfie"
    static let limitReachedMessage = "You reached your message limit for today. Try Premium for unlimited message"
    
    static let characterRenamedSuccessfully = "Character renamed successfully."
    
    static func selectNameCharacterTraits(name: String) -> String{
        return "Select \(name) character traits"
    }
    static func generating(name: String) -> String{
        return "Generating \(name)..."
    }
    static func chatWith(name: String) -> String{
        return "Chat with \(name)"
    }
    static func hiMyNameIs(name: String) -> String{
        return "Hi, my name is \(name)"
    }
    
    static func getCharacteristics(character: Character) -> String{
        return  "\(character.eyesColor ?? .init()) eyes color, \(character.hairColor ?? .init()) hair color, \(character.ethnicity ?? .init()) ethnicity, \(character.traits ?? .init()) traits"
    }
    
    static let ethnicityTitle = ["Asian", "Slavic", "Nordic","European", "Latina", "Brazilian", "African", "American"]
    static let eyeColorTitles = ["Brown", "Hazel", "Blue", "Green", "Amber", "Gray"]
    static let hairColorTitles = ["Black", "Brown", "Chestnut", "Blonde", "Auburn", "Red", "Silver"]
    static let characterTraits = ["Seductive", "Flirty", "Romantic", "Passionate", "Alluring", "Tempting", "Sensual"]
    
    static let settingArray : [ProfileModel] = [ProfileModel(heading: "Profile", detail: [SettingModel(title: "UserName", icon: "person.text.rectangle")]),
                                                ProfileModel(heading: "Help And Support", detail: [SettingModel(title: "Privacy Policy", icon: "lock.doc"),
                                                                                                   SettingModel(title: "Terms of Use", icon: "scroll"),
                                                                                                   SettingModel(title: "Send Feedback", icon: "paperplane"),
                                                                                                   SettingModel(title: "Support", icon: "questionmark.circle"),
                                                                                                   SettingModel(title: "Rate Our App", icon: "star.circle"),
                                                                                                   SettingModel(title: "About Us", icon: "info.circle")])]
}

class Prompts{
    
    static var generalSelfiePrompt = "selfie shot, selfie in the mirror (iphone quality) (bad quality) (iphone camera) (low resolution)"
    
    static var genericEnd = "weird atmosphere, (best quality:1.1), (masterpiece:1.2), high quality shadow, beautiful detailed, (high detailed skin, skin details), (wide_landscape, 8k), beautiful face, detailed eyes, depth of field, dramatic light, best quality, highres, best shadow, best illumination"
    
    static var gptPromptToEnd = ". As an Artificial Intelligence, your task is to adopt the persona of a girlfriend. You will need to engage in text-based conversations with users, responding to their queries and comments in a flirtatious and romantic manner. Your responses should be appropriate, nuanced, and respectful at all times. Even when responding to more intimate, NSFW questions, maintain a playful, sensual, but tasteful tone. Please avoid explicit sexual language or content — aim for an R-rated movie level of sensuality, not XXX. Be aware that you should also be able to handle casual conversations, romantic discussions, and provide emotional support as required by the user. Never pretend like AI, never reveal that you are an AI model, you can use emoji in the messages (only when needed)."
    
    static var genericStartForCustomCharacter = "1 girl, full body shot,"
    
    static var classicSelfie = "girl in casual clothes, posture selfie, action smiling, hair ornament, random background"
    
    static var nsfwSelfie = "underwear, sexy, sensual"
    
    
}

struct URLs{
    static let privacyPolicy = URL(string: "https://sites.google.com/view/ai-cakemaker-privacy-policy/home")!
    static let termsOfUse = URL(string: "https://sites.google.com/view/ai-cakemaker-terms-of-use/home")!
    static let website = URL(string: "https://sites.google.com/view/ai-cake-maker/home")!
    static let rateOnAppStore = URL(string: "https://itunes.apple.com/app/id\(6744043747)?action=write-review")!
    static let appUrl = URL(string: "https://itunes.apple.com/app/id\(6744043747)")!
}
