//
//  Profile.swift
//  SlackUsers
//
//  Created by Angad Manchanda on 2/10/18.
//  Copyright © 2018 Angad Manchanda. All rights reserved.
//

import Foundation

struct SlackProfile {
    
    var title: String?
    var phone: String?
    var skype: String?
    var realName: String?
    var realNameNormalized: String?
    var displayName: String?
    var displayNameNormalized: String?
    var statusText: String?
    var statusEmoji: String?
    var avatarHash: String?
    var email: String?
    var image24: String?
    var image32: String?
    var image48: String?
    var image72: String?
    var image192: String?
    var image512: String?
    
    init?(json: Any?) {
        guard let jsonObject = json as? [String: Any] else {
            return nil
        }
        
        title = jsonObject["title"] as? String
        phone = jsonObject["phone"] as? String
        skype = jsonObject["skype"] as? String
        realName = jsonObject["real_name"] as? String
        
        realNameNormalized = jsonObject["real_name_normalized"] as? String
        displayName = jsonObject["display_name"] as? String
        displayNameNormalized = jsonObject["display_name_normalized"] as? String
        statusText = jsonObject["status_text"] as? String
        statusEmoji = jsonObject["status_emoji"] as? String
        avatarHash = jsonObject["avatar_hash"] as? String
        
        email = jsonObject["email"] as? String
        image24 = jsonObject["image_24"] as? String
        image32 = jsonObject["image_32"] as? String
        image48 = jsonObject["image_48"] as? String
        image72 = jsonObject["image_72"] as? String
        image192 = jsonObject["image_192"] as? String
        image512 = jsonObject["image_512"] as? String
    }
}

