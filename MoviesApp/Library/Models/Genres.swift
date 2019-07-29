//
//  Genres.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation
import ObjectMapper

class Genres: Mappable {
    
    var genres: [Genre]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        genres          <- map["genres"]
    }
}
