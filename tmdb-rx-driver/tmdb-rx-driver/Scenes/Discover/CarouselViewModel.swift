//
//  CarouselViewModel.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 27.09.2020.
//

import Foundation

struct CarouselViewModel {
    enum DataType {
        case movie
        case person
        case show
    }
    
    let type: DataType
    let title: String
    let subtitle: String
    let items: [CarouselItemViewModel]
}

extension CarouselViewModel {
    init?(movies: [Movie]?) {
        guard let movies = movies else { return nil }
        self.type = .movie
        self.title = "Popular movies"
        self.subtitle = "Most popular in the world"
        self.items = movies.map { CarouselItemViewModel(movie: $0) }
    }
    
    init?(people: [Person]?) {
        guard let people = people else { return nil }
        self.type = .person
        self.title = "Trending people"
        self.subtitle = "Find out which celebrities are trending today"
        self.items = people.map { CarouselItemViewModel(person: $0) }
        
    }
    
    init?(shows: [Show]?) {
        guard let shows = shows else { return nil }
        self.type = .show
        self.title = "TV shows"
        self.subtitle = "Latest updates on popular TV shows"
        self.items = shows.map { CarouselItemViewModel(show: $0) }
    }
}

struct CarouselItemViewModel {
    let title: String
    let subtitle: String
    let imageUrl: String?
}

extension CarouselItemViewModel {
    init(movie: Movie) {
        self.title = movie.title
        self.subtitle = movie.releaseDate
        self.imageUrl = movie.posterUrl.flatMap { "http://image.tmdb.org/t/p/w185/" + $0 }
    }
    
    init(person: Person) {
        self.title = person.name
        self.subtitle = person.knownForTitles?.first ?? " "
        self.imageUrl = person.profileUrl.flatMap { "http://image.tmdb.org/t/p/w185/" + $0 }
    }
    
    init(show: Show) {
        self.title = show.name
        self.subtitle = show.releaseDate
        self.imageUrl = "http://image.tmdb.org/t/p/w185/" + show.posterUrl
    }
}
