//
//  MovieCell.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieTags: UILabel!
    @IBOutlet var movieRelease: UILabel!
    
    var movie: Movie! {
        didSet {
            setupImageView()
            setupTexts()
        }
    }
}

private extension MovieCell {
    
    func setupTexts() {
        movieTitle.text = movie.title
        
        if let releaseDate = movie.releaseDate {
             movieRelease.text = "Release in: \(releaseDate)"
        }
       
        movieTags.text = movie.genres.compactMap({"#\($0.name.replacingOccurrences(of: " ", with: "")) "}).joined()
        if movieTags.text == nil {
            movieTags.text = "UnKnowed"
            
        }
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
        {
            result in
            switch result {
            case .success(let value):
                self.setNeedsLayout()
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}


