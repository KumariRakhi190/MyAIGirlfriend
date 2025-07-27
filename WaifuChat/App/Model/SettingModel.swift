//
//  SettingModel.swift
//  WaifuChat
//
//  Created by Rakhi Kumari on 26/07/25.
//

import Foundation

struct SettingModel {
    let title: String
    let icon: String
}

struct ProfileModel {
    let heading: String
    let detail: [SettingModel]
}
