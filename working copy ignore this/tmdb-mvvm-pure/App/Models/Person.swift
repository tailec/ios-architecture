//
//  Person.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 30/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

struct KnownFor: Decodable {
    let title: String?
}

struct Person: Decodable {
    let id: Int
    let name: String
    let profileUrl: String?
    let knownForTitles: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, profileUrl = "profile_path", knownFor = "known_for"
    }
    
    enum KnownForKeys: String, CodingKey {
        case knownForTitle = "title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        profileUrl = try? container.decode(String.self, forKey: .profileUrl)
        var known = try container.nestedUnkeyedContainer(forKey: .knownFor)
        var titles: [String]? = []
        while !known.isAtEnd {
            if let knownForDecodable = try? known.decode(KnownFor.self),
                let title = knownForDecodable.title {
                titles?.append(title)
            } else {
                titles = nil
            }
        }
        knownForTitles = titles
    }
}
