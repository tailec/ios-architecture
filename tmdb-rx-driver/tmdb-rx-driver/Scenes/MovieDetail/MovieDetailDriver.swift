//
//  MovieDetailDriver.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 28/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

struct MovieDetailData {
    let title: String
    let releaseDate: String
    let overview: String
    let genres: String
    let runtime: String
    let voteAverage: String
    let posterUrl: String?
    let voteCount: String
    let status: String
}

extension MovieDetailData {
    init(movie: Movie) {
        self.title = movie.title
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.genres = movie.genres
            .flatMap {
                $0.map { $0.name }
                    .prefix(2)
                    .joined(separator: ", ")
            } ?? ""
        self.runtime = movie.runtime
            .flatMap { "\($0 / 60)hr \($0 % 60)min" } ?? ""
        self.voteAverage = movie.voteAverage
            .flatMap { String($0) } ?? ""
        self.posterUrl = movie.posterUrl.flatMap { "http://image.tmdb.org/t/p/w780/" + $0 }
        self.voteCount = movie.voteCount
            .flatMap { String($0) } ?? ""
        self.status = movie.status ?? ""
    }
}

protocol MovieDetailDriving {
    var data: Driver<MovieDetailData> { get }
    var didClose: Driver<Void> { get }
    
    func close()
}

final class MovieDetailDriver: MovieDetailDriving {
    private let closeRelay = PublishRelay<Void>()
    
    private let id: Int
    private let api: TMDBApiProvider
    
    var data: Driver<MovieDetailData> {
        api.fetchMovieDetails(forMovieId: id)
            .unwrap()
            .compactMap(MovieDetailData.init)
            .asDriver()
    }
    
    var didClose: Driver<Void> { closeRelay.asDriver() }
    
    init(id: Int, api: TMDBApiProvider) {
        self.id = id
        self.api = api
    }
    
    func close() {
        closeRelay.accept(())
    }
}

extension MovieDetailDriver: StaticFactory {
    enum Factory {
        static func `default`(id: Int) -> MovieDetailDriving {
            MovieDetailDriver(id: id, api: TMDBApi.Factory.default)
        }
    }
}
