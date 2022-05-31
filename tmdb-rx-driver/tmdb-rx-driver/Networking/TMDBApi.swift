//
//  TMDBApi.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TMDBApiMoviesProvider {
    func fetchPopularMovies() -> Observable<[Movie]?>
    func fetchMovieDetails(forMovieId id: Int) -> Observable<Movie?>
    func searchMovies(forQuery query: String) -> Observable<[Movie]?>
}

protocol TMDBApiPeopleProvider {
    func fetchPopularPeople() -> Observable<[Person]?>
    func searchPeople(forQuery query: String) -> Observable<[Person]?>
}

protocol TMDBApiShowsProvider {
    func fetchPopularShows() -> Observable<[Show]?>
}

protocol TMDBApiAuthProvider {
    func login(withUsername username: String, password: String) -> Observable<Bool>
}

protocol TMDBApiProvider: TMDBApiMoviesProvider, TMDBApiPeopleProvider, TMDBApiShowsProvider, TMDBApiAuthProvider { }

final class TMDBApi: TMDBApiProvider {
    private struct Constants {
        static let apiKey = "3f093e78fd47d26523d784196a33f00a"
    }
    
    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchPopularMovies() -> Observable<[Movie]?> {
        return httpClient.get(url: "https://api.themoviedb.org/3/discover/movie?api_key=\(Constants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false")
            .map { data -> [Movie]? in
                guard let data = data,
                    let response = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                        return nil
                }
                return response.results
        }
    }
    
    func fetchPopularPeople() -> Observable<[Person]?> {
        return httpClient.get(url: "https://api.themoviedb.org/3/person/popular?api_key=\(Constants.apiKey)&language=en-US&page=1")
            .map { data -> [Person]? in
                guard let data = data,
                    let response = try? JSONDecoder().decode(PeopleResponse.self, from: data) else {
                        return nil
                }
                return response.results
        }
    }
    
    func fetchPopularShows() -> Observable<[Show]?> {
        return httpClient.get(url: "https://api.themoviedb.org/3/discover/tv?api_key=\(Constants.apiKey)&language=en-US&sort_by=popularity.desc&page=1&include_null_first_air_dates=false")
            .map { data -> [Show]? in
                guard let data = data,
                    let response = try? JSONDecoder().decode(ShowsResponse.self, from: data) else {
                        return nil
                }
                return response.results
        }
    }
    
    func fetchMovieDetails(forMovieId id: Int) -> Observable<Movie?> {
        return httpClient.get(url: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(Constants.apiKey)&language=en-US)")
            .map { data -> Movie? in
                guard let data = data,
                    let response = try? JSONDecoder().decode(Movie.self, from: data) else {
                        return nil
                }
                return response
        }
    }
    
    func searchMovies(forQuery query: String) -> Observable<[Movie]?> {
        return httpClient.get(url: "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.apiKey)&language=en-US&query=\(query)&page=1&include_adult=false")
            .map { data -> [Movie]? in
                guard let data = data,
                    let response = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                        return nil
                }
                
                return response.results
            }
    }
    
    func searchPeople(forQuery query: String) -> Observable<[Person]?> {
        return httpClient.get(url: "https://api.themoviedb.org/3/search/person?api_key=\(Constants.apiKey)&language=en-US&query=\(query)&page=1&include_adult=false")
            .map { data -> [Person]? in
                guard let data = data,
                    let response = try? JSONDecoder().decode(PeopleResponse.self, from: data) else {
                        return nil
                }
                return response.results
        }
    }
    
    func login(withUsername username: String, password: String) -> Observable<Bool> {
        return fetchAuthToken()
            .flatMap { [weak self] (token: String?) -> Observable<Data?> in
                guard let strongSelf = self,
                    let token = token else { return Observable.just(nil) }
                return strongSelf.httpClient.post(url: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(Constants.apiKey)",
                    params: ["username": username, "password": password, "request_token": token])
            }
            .map { (data: Data?) -> Bool in
                guard let data = data,
                    let response = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                        return false
                }
                return response.success
            }
    }


    private func fetchAuthToken() -> Observable<String?> {
        return httpClient.get(url: "https://api.themoviedb.org/3/authentication/token/new?api_key=\(Constants.apiKey)")
                .map { data -> String? in
                    guard let data = data,
                        let response = try? JSONDecoder().decode(AuthTokenResponse.self, from: data) else {
                            return nil
                    }
                    return response.requestToken
                }
    }
}

extension TMDBApi: StaticFactory {
    enum Factory {
        static let `default`: TMDBApiProvider = TMDBApi()
    }
}
