//
//  TMDBApiResponses.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 30/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

struct PeopleResponse: Decodable {
    let results: [Person]
}

struct ShowsResponse: Decodable {
    let results: [Show]
}

struct MoviesResponse: Decodable {
    let results: [Movie]
}

struct LoginResponse: Decodable {
    let success: Bool
}

struct AuthTokenResponse: Decodable {
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
