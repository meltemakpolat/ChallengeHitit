//
//  NetworkModels.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit

class NetworkModels: NSObject {

    // MARK: *** Films
    struct Films: Codable {
        let search: [Search]?
        let totalResults: String?
        let response: String?
        
        enum CodingKeys: String, CodingKey {
            case search = "Search"
            case totalResults = "totalResults"
            case response = "Response"
        }
        
        struct Search: Codable {
            let title: String?
            let year: String?
            let imdbId: String?
            let type: String?
            let poster: String?
            
            enum CodingKeys: String, CodingKey {
                case title = "Title"
                case year = "Year"
                case imdbId = "imdbID"
                case type = "Type"
                case poster = "Poster"
            }
        }
    }
    
    
    // MARK: *** FilmDetail
    struct FilmDetail: Codable {
        let title: String?
        let year: String?
        let rated: String?
        let released: String?
        let runtime: String?
        let genre: String?
        let director: String?
        let writer: String?
        let actors: String?
        let plot: String?
        let language: String?
        let country: String?
        let awards: String?
        let poster: String?
        let metascore: String?
        let imdbRating: String?
        let imdbVotes: String?
        let imdbId: String?
        let type: String?
        let response: String?
        
        enum CodingKeys: String, CodingKey {
            case title = "Title"
            case year = "Year"
            case rated = "Rated"
            case released = "Released"
            case runtime = "Runtime"
            case genre = "Genre"
            case director = "Director"
            case writer = "Writer"
            case actors = "Actors"
            case plot = "Plot"
            case language = "Language"
            case country = "Country"
            case awards = "Awards"
            case poster = "Poster"
            case metascore = "Metascore"
            case imdbRating = "imdbRating"
            case imdbVotes = "imdbVotes"
            case imdbId = "imdbID"
            case type = "Type"
            case response = "Response"
        }
    }
    
    
    
}

