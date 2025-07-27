//
//  StringExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 19/07/23.
//

import Foundation

extension String{
    
    var trim: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
