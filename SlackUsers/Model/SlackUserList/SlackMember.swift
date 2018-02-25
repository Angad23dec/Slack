//
//  SlackMembers.swift
//  SlackUsers
//
//  Created by Angad Manchanda on 2/10/18.
//  Copyright © 2018 Angad Manchanda. All rights reserved.
//

import UIKit

struct SlackMember {
    let memberID: String?
    let teamID: String?
    let name: String?
    let deleted: Bool?
    let color: String?
    let realName: String?
    let tz: String?
    let tzLabel: String?
    let tzoffset: Int?
    let profile: SlackProfile?
    let isAdmin: Bool?
    let isOwner: Bool?
    let isPrimaryOwner: Bool?
    let isRestricted: Bool?
    let isUltraRestricted: Bool?
    let isBot: Bool?
    let updated: Int?
    let isAppUser: Bool?
    let has2Fa: Bool?

    init?(json: Any?) {
        guard let jsonObject = json as? [String: Any] else {
            return nil
        }

        memberID = jsonObject["id"] as? String
        teamID = jsonObject["team_id"] as? String
        name = jsonObject["name"] as? String
        deleted = jsonObject["deleted"] as? Bool
        color = jsonObject["color"] as? String
        realName = jsonObject["real_name"] as? String
        tz = jsonObject["tz"] as? String
        tzLabel = jsonObject["tz_label"] as? String
        tzoffset = jsonObject["tz_offset"] as? Int
        profile = SlackProfile(json: jsonObject["profile"])
        isAdmin = jsonObject["is_admin"] as? Bool
        isOwner = jsonObject["is_owner"] as? Bool
        isPrimaryOwner = jsonObject["is_primary_owner"] as? Bool
        isRestricted = jsonObject["is_restricted"] as? Bool
        isUltraRestricted = jsonObject["is_ultra_restricted"] as? Bool
        isBot = jsonObject["is_bot"] as? Bool
        updated = jsonObject["updated"] as? Int
        isAppUser = jsonObject["is_app_user"] as? Bool
        has2Fa = jsonObject["has_2fa"] as? Bool
    }
}

