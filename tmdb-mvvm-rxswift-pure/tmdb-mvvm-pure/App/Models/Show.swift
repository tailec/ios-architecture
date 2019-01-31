//
//  Show.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 30/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

struct Show: Decodable {
    let id: Int
    let name: String
    let posterUrl: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, posterUrl = "poster_path", releaseDate = "first_air_date"
    }
}
