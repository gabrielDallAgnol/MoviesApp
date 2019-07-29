//
//  Networking.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation

typealias StructJSON = [String: Any]

class Networking {
    
    private let apiKey = "c5850ed73901b8d268d0898a8a9d8bff"
    
    private let baseUrl = URL(string: "https://api.themoviedb.org/3")!
    
    func MovieRequest(service: MovieAPI, page: Int = 1) -> URLRequest {
        switch service {
        case .Upcoming:
            return makeRequest(resource: Request(url: baseUrl,
                                                 path: "/movie/upcoming",
                                                 parameters: ["api_key" : apiKey,
                                                              "language" : "en-US",
                                                              "page": String(page)])
                )!
        }
    }
    
    func GenreRequest(service: GenreAPI) -> URLRequest {
        switch service {
        case .Movie:
            return makeRequest(resource: Request(url: baseUrl,
                                                 path: "/genre/movie/list",
                                                 parameters: ["api_key" : apiKey,
                                                              "language" : "en-US"])
                )!
        }
    }
    
    func SearchRequest(service: SearchAPI, query: String = "") -> URLRequest {
        switch service {
        case .Movies:
            return makeRequest(resource: Request(url: baseUrl,
                                                 path: "/search/movie",
                                                 parameters: ["api_key" : apiKey,
                                                              "language" : "en-US",
                                                              "query": query])
                )!
        }
    }
    
    private func makeRequest(resource: Request) -> URLRequest? {
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

extension Networking {
    enum MovieAPI {
        case Upcoming
    }
    enum GenreAPI {
        case Movie
    }
    enum SearchAPI {
        case Movies
    }
}
