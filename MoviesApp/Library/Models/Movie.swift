//
//  Movie.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Movie: Object, Mappable{
    
    @objc dynamic var id = 0
    @objc dynamic var title: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var originalTitle: String?
    @objc dynamic var originalLanguage: String?
    @objc dynamic var backdropPath: String?
    @objc dynamic var posterPath: String?
    @objc dynamic var overview: String?
    @objc dynamic var voteAverage = 0
    @objc dynamic var popularity = 0
    @objc dynamic var voteCount = 0
    @objc dynamic var video = false
    @objc dynamic var adult = false
    var genres = List<Genre>()
    
    var genreIds = [Int]() {
        didSet {
            for genrerId in genreIds { genres.append(DBService.shared.getGenre(by: genrerId))
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        voteCount                <- map["vote_count"]
        id                       <- map["id"]
        video                    <- map["video"]
        voteAverage              <- map["vote_average"]
        title                    <- map["title"]
        popularity               <- map["popularity"]
        posterPath               <- map["poster_path"]
        originalLanguage         <- map["original_language"]
        originalTitle            <- map["original_title"]
        genreIds                 <- map["genre_ids"]
        backdropPath             <- map["backdrop_path"]
        adult                    <- map["adult"]
        overview                 <- map["overview"]
        releaseDate              <- map["release_date"]
    }
}
