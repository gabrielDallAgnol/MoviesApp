//
//  Genger.swift
//  MoviesApp
//
//  Created by Palmsoft  on 28/07/19.
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Genre: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name                <- map["name"]
        id                  <- map["id"]
    }
}
