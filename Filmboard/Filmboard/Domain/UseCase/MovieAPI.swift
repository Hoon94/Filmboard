//
//  MovieAPI.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import Foundation

// MARK: - APIService

extension APIService {
    static private let APIKey = Bundle.main.APIKey
    
    static func configureUrlString(category: MovieListCategory, language: Language, page: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(category.key)?api_key=\(APIKey)&language=\(language.key)&page=\(page)"
    }
    
    static func configureUrlString(posterPath: String?) -> String? {
        guard let posterPath = posterPath else { return nil }
        
        return "https://image.tmdb.org/t/p/original/\(posterPath)"
    }
    
    static func configureUrlString(keyword: String, language: Language, page: Int) -> String {
        return "https://api.themoviedb.org/3/search/movie?query=\(keyword)&api_key=\(APIKey)&language=\(language.key)&page=\(page)"
    }
    
    static func configureUrlString(id: Int, language: Language) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)?api_key=\(APIKey)&language=\(language)"
    }
}

// MARK: - MovieListCategory

enum MovieListCategory {
    case popular, upcomming, topRated, nowPlaying
    
    var key: String {
        switch self {
        case .popular: return "popular"
        case .upcomming: return "upcomming"
        case .topRated: return "top_rated"
        case .nowPlaying: return "now_playing"
        }
    }
    
    var title: String {
        switch self {
        case .popular: return "Popular"
        case .upcomming: return "Upcomming"
        case .topRated: return "Top Rated"
        case .nowPlaying: return "Now Playing"
        }
    }
}

// MARK: - Language

enum Language {
    case korean, english
    
    var key: String {
        switch self {
        case .korean: return "ko-KR"
        case .english: return "en-US"
        }
    }
}
