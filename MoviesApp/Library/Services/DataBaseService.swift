//
//  DataBaseService.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import UIKit
import RealmSwift

class DBService {
    
    static let shared = DBService()
    
    private var database:Realm
    
    private init() {
        database = try! Realm()
    }
    
    // MARK: - Movies DB
    func addMovies(for movies: [Movie]) {
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.sync {
                try! self.database.write {
                    for movie in movies {
                        self.database.add(movie, update: .all)
                    }
                }
            }
        })
    }
    
    func updateMovies(for movies: [Movie]) {
        try! database.write {
            for movie in movies {
                self.database.add(movie, update: .all)
            }
        }
    }
    
    // MARK: - Genrer DB
    func addGenres(for genres: [Genre]) {
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.sync {
                try! self.database.write {
                    
                    for genre in genres {
                        self.database.add(genre, update: .all)
                    }
                }
            }
        })
    }
    
    // MARK: - Delete DB Data
    func deleteAllFromDatabase() {
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.sync {
                try! self.database.write {
                    
                    self.database.deleteAll()
                }
            }
        })
    }
    
    
    // MARK: - DB Data Retrieval
    func getMovies() -> [Movie] {
        let results = database.objects(Movie.self).sorted(byKeyPath: "voteAverage", ascending: false)
        return Array(results)
    }
    
    func getMovie(by primaryKey: Int) -> Movie {
        let movie: Movie = database.object(ofType: Movie.self, forPrimaryKey: primaryKey)!
        return movie
    }
    
    func getGenre(by primaryKey: Int) -> Genre {
        let genre: Genre = database.object(ofType: Genre.self, forPrimaryKey: primaryKey)!
        return genre
    }
    
    func sort( byCase: SortBy) -> [Movie] {
        switch byCase {
        case .CloseRelease:
            return  Array(database.objects(Movie.self).sorted(byKeyPath: "releaseDate", ascending: false))
        case .DistantRelease:
            return  Array(database.objects(Movie.self).sorted(byKeyPath: "releaseDate", ascending: true))
        case .LessPopular:
            return  Array(database.objects(Movie.self).sorted(byKeyPath: "popularity", ascending: true))
        case .MostPopular:
            return  Array(database.objects(Movie.self).sorted(byKeyPath: "popularity", ascending: false))
        case .LessVoted:
            return  Array(database.objects(Movie.self).sorted(byKeyPath: "voteCount", ascending: true))
        case .MostVoted:
            return  Array(database.objects(Movie.self).sorted(byKeyPath: "voteCount", ascending: false))
        }
    }
    static var SortOptions : [String] {
        return["Most Voted","Less Voted","Most Popular","Less Popular","Close Release","Distant Release"]
    }
    
    func databaseSearch( string: String) -> [Movie] {
        let searchstring = string.lowercased()
        var articles = [Movie]()
        
        for article in self.getMovies() {
            let stringdescription = article.description.lowercased()
            if stringdescription.contains(searchstring){
                articles.append(article)
            }
        }
        return articles
    }
    
    enum SortBy : String, CaseIterable{
        case MostVoted = "Most Voted"
        case LessVoted = "Less Voted"
        case MostPopular = "Most Popular"
        case LessPopular = "Less Popular"
        case CloseRelease = "Close Release"
        case DistantRelease = "Distant Release"
    }
    
}

