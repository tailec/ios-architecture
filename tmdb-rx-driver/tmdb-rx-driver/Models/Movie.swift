//
//  Movie.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 30/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let genres: [Genre]?
    let posterUrl: String?
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double?
    let voteCount: Int?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case genres
        case posterUrl = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case status
    }
}
