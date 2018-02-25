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

typealias UsersListCompletion = (_ members: [SlackMember]?,  _ errorMessage: String?) -> Void

class SlackUserListRequestService {
    var cacheResponse :CachedURLResponse? = nil
    
    func getUsersList(completion : @escaping UsersListCompletion) {
        guard var urlComponents = URLComponents(string:API.usersListURLString) else {
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "token", value: API.authAPIToken)]
        var urlRequest = URLRequest(url: urlComponents.url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //Get cache response using request object
        cacheResponse = URLCache.shared.cachedResponse(for:urlRequest)
        
        if cacheResponse == nil {
            let config = URLSessionConfiguration.default
            // 500 MB - size of cache
            config.urlCache = URLCache.shared
            config.urlCache = URLCache(memoryCapacity: 500 * 1024 * 1024, diskCapacity: 500 * 1024 * 1024, diskPath: "urlCache")
            
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
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
                }
                catch let parseError as NSError {
                    print("JSON Error \(parseError.localizedDescription)")
                }
                
                let cacheResponse = CachedURLResponse(response: response!, data: data!)
                self.cacheResponse = cacheResponse
                URLCache.shared.storeCachedResponse(self.cacheResponse!, for: urlRequest)
            })
            task.resume()
        } else {
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: (cacheResponse?.data)!, options: []) as? [String: Any]
                guard let slackUserList = SlackUserList(json: jsonResult) else {
                    return
                }
                
                if let members = slackUserList.members {
                    completion(members,  nil)
                }
            }
            catch let parseError as NSError {
                print("Caching Error while parsing JSON  \(parseError.localizedDescription)")
            }
        }
    }
}
