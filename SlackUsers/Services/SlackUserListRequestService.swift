//
//  SlackUserListRequestService.swift
//  SlackUsers
//
//  Created by Angad Manchanda on 2/11/18.
//  Copyright © 2018 Angad Manchanda. All rights reserved.
//

import UIKit

struct API {
    static let authAPIToken = "xoxp-4698769766-4698769768-266771053075-66c3498cd17d3c736b94fdd14307ef20"
    static let usersListURLString = "https://slack.com/api/users.list/"
}

typealias UsersListCompletion = (_ members: [SlackMember]?, _ errorMessage: String?) -> Void

class SlackUserListRequestService {
    
    func getUsersList(completion : @escaping UsersListCompletion) {
        guard var urlComponents = URLComponents(string:API.usersListURLString) else {
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "token", value: API.authAPIToken)]
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                OperationQueue.main.addOperation({
                    completion(nil, error!.localizedDescription)
                })
                return
            }
            
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
                    return
                }
                guard let slackUserList = SlackUserList(json: jsonResult) else {
                    OperationQueue.main.addOperation({
                        completion(nil, error!.localizedDescription)
                    })
                    return
                }
                if let members = slackUserList.members {
                    OperationQueue.main.addOperation({
                        completion(members, nil)
                    })
                }
            } catch let parseError as NSError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        }).resume()
    }
}
