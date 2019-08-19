//
//  MoviedbAPI.swift
//  ReSwiftNanoChallenge
//
//  Created by Raul Rodrigues on 8/14/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//


//v3key = 02767cc381f5b106fdd67e276322c5c9
//v4key = eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMjc2N2NjMzgxZjViMTA2ZmRkNjdlMjc2MzIyYzVjOSIsInN1YiI6IjVkNTQ0MmIyNGIwYzYzNTAxNDdhN2UyMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2EXxK6NsCyyTv9KN3VIRkST6OtzP5eVPyarSJHEf9FM

//  let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import UIKit

private let apiKey = "02767cc381f5b106fdd67e276322c5c9"

class Network {
    
    static func nowPlaying(callback: @escaping ([Result]?, Error?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1")
        
        if let connect = url {
            let task = URLSession.shared.dataTask(with: connect) { (data, response, error) in
                if let error = error {
                    callback(nil, error)
                }
                    
                let decoder = JSONDecoder()
                let res = try? decoder.decode(NowPlaying.self, from: data!)
                callback(res?.results, nil)
            }
            task.resume()
        }
    }
    
    static func popular(callback: @escaping ([Result]?, Error?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1")
        
        if let connect = url {
            let task = URLSession.shared.dataTask(with: connect) { (data, response, error) in
                
                if let error = error {
                    callback(nil, error)
                }
                    
                else if let data = data {
                    let decoder = JSONDecoder()
                    let res = try? decoder.decode(Popular.self, from: data)
                    callback(res?.results, nil)
                }
            }
            task.resume()
        }
    }
    
    static func movieDetails(id: Int, callback: @escaping (Details?, Error?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=en-US")
        
        
        if let connect = url {
            
            let task = URLSession.shared.dataTask(with: connect) { (data, response, error) in

                if let error = error {
                    callback(nil, error)
                }
                
                else if let data = data {
                    let decoder = JSONDecoder()
                    let res = try? decoder.decode(Details.self, from: data)
                    callback(res, nil)
                }
            }
            task.resume()
        }
    }
    
    static func moviePoster(imagePath: String, callback: @escaping (Data?, String?) -> Void) {
        let urlBase = "https://image.tmdb.org/t/p/w500"
        let finalUrl = urlBase + imagePath
        
        if let url = URL(string: finalUrl) {
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url) {
                    callback(data, imagePath)
                } else {
                    callback(nil, nil)
                }
            }
        } else {
            callback(nil, nil)
        }
    }
}

// MARK: - NowPlaying
struct NowPlaying: Codable {
    let results: [Result]?
    let page, totalResults: Int?
    let dates: Dates?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalResults = "total_results"
        case dates
        case totalPages = "total_pages"
    }
}

// MARK: - Popular
struct Popular: Codable {
    let page, totalResults, totalPages: Int?
    let results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Details
struct Details: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Result
struct Result: Codable {
    let voteCount, id: Int?
    let video: Bool?
    let voteAverage: Double?
    let title: String?
    let popularity: Double?
    let posterPath: String?
    let originalLanguage: String?
    let originalTitle: String?
    let genreIDS: [Int]?
    let backdropPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let iso639_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case name
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
