//
//  UpcomingStruct.swift
//  MoviesApp
//
//  Created by Palmsoft  on 28/07/19.
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

struct UpcomingStruct: Mappable {
    
    
    var results: [Movie]?
    var page: Int?
    var totalPages: Int!
    var totalResults: Int?
    var dates: date?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
    results          <- map["results"]
    page             <- map["page"]
    totalPages       <- map["total_pages"]
    totalResults     <- map["total_results"]
    dates            <- map["dates"]
    }
    
    
}

struct date: Mappable {
    
    var maximum: String?
    var minimum: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
    maximum             <- map["maximum"]
    minimum             <- map["minimum"]
    }
    
}
