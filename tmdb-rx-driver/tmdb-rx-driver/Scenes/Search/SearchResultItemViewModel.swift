//
//  SearchResultItemViewModel.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 20.09.2020.
//

import Foundation

enum SearchResultItemType: Int {
    case movies, people
}

struct SearchResultItem {
    let id: Int
    let title: String
    let subtitle: String
    let imageUrl: String?
    let type: SearchResultItemType
}

extension SearchResultItem {
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.subtitle = movie.overview
        self.imageUrl = movie.posterUrl.flatMap { "http://image.tmdb.org/t/p/w185/"  + $0 }
        self.type = .movies
    }
    
    init(person: Person) {
        self.id = person.id
        self.title = person.name
        self.subtitle = person.knownForTitles?.first ?? " "
        self.imageUrl = person.profileUrl.flatMap { "http://image.tmdb.org/t/p/w185/"  + $0 }
        self.type = .people
    }
}
