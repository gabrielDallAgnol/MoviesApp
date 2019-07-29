//
//  Resquests.swift
//  MoviesApp
//
//  Created by Palmsoft  on 29/07/19.
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation

struct Request {
    
    let url: URL
    let path: String?
    let httpMethod: String
    let parameters: [String: String]
    
    init(url: URL, path: String? = nil, httpMethod: String = "GET", parameters: [String: String] = [:]) {
        self.url = url
        self.path = path
        self.httpMethod = httpMethod
        self.parameters = parameters
    }
}
