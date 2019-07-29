//
//  MovieService.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

final class MovieService {
    
    static let shared = MovieService()
    
    private let networking = Networking()
    
    func getMovies() {
        AF.request(networking.MovieRequest(service: .Upcoming, page: 1)).responseJSON { response in
            
            switch response.result {
            case let .success(value):
                if  let valueJson = value as? StructJSON,
                    let upcomingResult = Mapper<UpcomingStruct>().map(JSON: valueJson){
                    
                    for page in 1...upcomingResult.totalPages {
                                AF.request(self.networking.MovieRequest(service: .Upcoming, page: page)).responseJSON { response in
                                    print(DBService.shared.getMovies().count)
                                    switch response.result {
                                    case let .success(value):
                                        if  let valueJson = value as? StructJSON,
                                            let upcomingResult = Mapper<UpcomingStruct>().map(JSON: valueJson),
                                            let movies = upcomingResult.results{
                                            
                                            DBService.shared.addMovies(for: movies)
                                            
                                        } else {
                                            print("Request With Problem")
                                        }
                                    case let .failure(error):
                                        print(error)
                                    }
                                }
                    }
                } else {
                    print("Request With Problem")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getGenres() {
        AF.request(networking.GenreRequest(service: .Movie)).responseJSON { response in
            
            switch response.result {
            case let .success(value):
                if  let valueJson = value as? StructJSON,
                    let genreResult = Mapper<Genres>().map(JSON: valueJson),
                    let genres = genreResult.genres{
                            DBService.shared.addGenres(for: genres)
                } else {
                    print("Request With Problem")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func searchMovies(search: String) {
        AF.request(networking.SearchRequest(service: .Movies, query: search)).responseJSON { response in
            
            switch response.result {
            case let .success(value):
                print(value)
            case let .failure(error):
                print(error)
            }
        }
    }
}
