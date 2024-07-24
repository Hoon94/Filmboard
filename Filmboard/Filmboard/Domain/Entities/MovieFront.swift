//
//  MovieFront.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import Foundation

struct MovieFront {
    
    // MARK: - Properties
    
    let id: Int
    let title: String
    let posterPath: String?
    
    let genre: String
    let releaseDate: String
    let ratingScore: Double
    let ratingCount: Int
    
    // MARK: - Static
    
    static func convertFromMovieInfo(movie: MovieListResult) -> MovieFront {
        let genreValue = movie.genreIDS.count > 0 ? genreCode[movie.genreIDS[0]] ?? "" : ""
        
        return MovieFront(id: movie.id, title: movie.title, posterPath: movie.posterPath, genre: genreValue, releaseDate: movie.releaseDate, ratingScore: movie.voteAverage, ratingCount: movie.voteCount)
    }
}


