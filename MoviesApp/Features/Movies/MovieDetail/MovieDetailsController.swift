//
//  MovieDetailsController.swift
//  MoviesApp
//
//  Created by Palmsoft  on 28/07/19.
//  Copyright © 2019 Gabriel. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsController: UIViewController {
    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieGenre: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieOverview: UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        movieReleaseDate.text = movie.releaseDate
        movieTitle.text = movie.title
        movieOverview.text = movie.overview
        
        movieGenre.text = movie.genres.compactMap({"#\($0.name.replacingOccurrences(of: " ", with: "")) "}).joined()
        if movieGenre.text == nil {
            movieGenre.text = "UnKnowed"
        }
        
         setupImageView()
    }
    
    func setupImageView() {
        var path = ""
        
        if movie.posterPath != nil {
            path = movie.posterPath!
        } else if movie.backdropPath != nil {
            path = movie.backdropPath!
        } else {
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w500/\(path)")
        let processor = DownsamplingImageProcessor(size: movieImage.frame.size)
        self.movieImage.kf.indicatorType = .activity
        self.movieImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Logo"),
            options: [
                .processor(processor),
                .transition(.fade(1)),
            ])
    }
}