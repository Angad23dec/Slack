//
//  ImageRequestService.swift
//  SlackUsers
//
//  Created by Angad Manchanda on 2/23/18.
//  Copyright © 2018 Angad Manchanda. All rights reserved.
//

import UIKit

typealias ImageCompletion = (_ image: UIImage?, _ errorMessage: String?) -> Void

class ImageRequestService {
    
    private let slackUserListRequestService = SlackUserListRequestService()
    
    func getImage(_ urlString: String?, completion: @escaping ImageCompletion) {
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if slackUserListRequestService.cacheResponse == nil {
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if error != nil {
                    OperationQueue.main.addOperation({
                        completion(nil, error!.localizedDescription)
                    })
                    return
                }
                
                if let image = UIImage(data: data!) {
                    OperationQueue.main.addOperation({
                        completion(image, nil)
                    })
                }
            })
            task.resume()
        }
    }
}


