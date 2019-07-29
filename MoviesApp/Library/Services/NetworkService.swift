//
//  NetworkService.swift
//  MoviesApp
//
//  Created by Palmsoft  on 28/07/19.
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation
import SwiftyJSON

final class NetworkService: Networking {
    
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    @discardableResult func fetch(resource: RequestResource, completion: @escaping (Data?) -> Void) -> URLSessionTask? {
        guard let request = makeRequest(resource: resource) else {
            completion(nil)
            return nil
        }
        
        let task = session.dataTask(with: request, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            completion(data)
        })
        
        task.resume()
        return task
    }
    
    private func makeRequest(resource: RequestResource) -> URLRequest? {
        let url = resource.path.map({ resource.url.appendingPathComponent($0) }) ?? resource.url
        guard var component = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            assertionFailure()
            return nil
        }
        
        component.queryItems = resource.parameters.map({
            return URLQueryItem(name: $0, value: $1)
        })
        
        guard let resolvedUrl = component.url else {
            assertionFailure()
            return nil
        }
        
        var request = URLRequest(url: resolvedUrl)
        request.httpMethod = resource.httpMethod
        return request
    }
}
