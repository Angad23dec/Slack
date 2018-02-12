//
//  SlackUserListService.swift
//  SlackUsers
//
//  Created by Angad Manchanda on 2/10/18.
//  Copyright © 2018 Angad Manchanda. All rights reserved.
//

import UIKit

class SlackUserList: NSObject  {
    
    let responseOK : Bool
    var members : [SlackMember]?
    
    init?(json: Any?) {
        guard let jsonObject = json as? [String: Any] else {
            assertionFailure("Invalid json response")
            return nil
        }
        
        responseOK = jsonObject["ok"] as! Bool
        if let jsonMembers = jsonObject["members"] as? [[String: Any]] {
            members = SlackUserList.getMembers(jsonMembers)
        }
        super.init()
    }
}

//MARK: init helper methods
private extension SlackUserList {
    class func getMembers(_ jsonMembers: [Any]) -> [SlackMember] {
        var members = [SlackMember]()
        for jsonMember in jsonMembers {
            guard let member = SlackMember(json: jsonMember) else {
                continue
            }
            members.append(member)
        }

        return members
    }
}

