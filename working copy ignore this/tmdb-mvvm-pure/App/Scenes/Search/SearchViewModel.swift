//
//  SearchViewModel.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 29/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    struct Input {
        let searchText: Driver<String>
        let selectedCategoryIndex: Driver<Int>
        let selected: Driver<IndexPath>
    }
    
    struct Output {
        let switchHidden: Driver<Bool>
        let loading: Driver<Bool>
        let results: Driver<[SearchResultItemViewModel]>
        let selectedDone: Driver<Void>
    }
    
    struct Dependencies {
        let api: TMDBApiProvider
        let navigator: SearchNavigatable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let loading = activityIndicator.asDriver()
        
        let query = input.searchText
            .asObservable()
            .filter { $0.count >= 3 }
            .throttle(0.5, scheduler: MainScheduler.instance)
        
        let selectedCategoryIndex = input.selectedCategoryIndex
            .asObservable()
            .map { index in return index == 0 ? SearchResultItemType.movies : SearchResultItemType.people }
        
        let results = Observable.combineLatest(query, selectedCategoryIndex)
            .flatMapLatest { pair -> Observable<[SearchResultItem]> in
                let (query, type) = pair
                switch type {
                case .movies: return self.dependencies.api.searchMovies(forQuery: query)
                    .trackActivity(activityIndicator)
                    .map { movies -> [SearchResultItem] in
                        guard let movies = movies else { return [] }
                        return  movies.map { SearchResultItem(movie: $0) }
                    }
                case .people:
                    return self.dependencies.api.searchPeople(forQuery: query)
                        .trackActivity(activityIndicator)
                        .map { people -> [SearchResultItem] in
                            guard let people = people else { return [] }
                            return  people.map { SearchResultItem(person: $0) }
                    }
                }
        }
        
        let emptyResults =  input.searchText
            .asObservable()
            .filter { $0.count < 3 }
            .map { _ in return [SearchResultItem]() }
        
        let mappedResults = Observable.merge(results, emptyResults)
            .map { $0.map { SearchResultItemViewModel(searchResultItem: $0) }}
            .asDriver(onErrorJustReturn: [])
        
        let switchHidden = input.searchText
            .map { $0.count < 3 }
        
        let selectedDone = input.selected
            .asObservable()
            .withLatestFrom(Observable.merge(results, emptyResults)) { indexPath, results in
                return results[indexPath.row]
            }
            .do(onNext: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result.type {
                case .movies: strongSelf.dependencies.navigator.navigateToMovieDetailScreen(withMovieId: result.id,
                                                                                            api: strongSelf.dependencies.api)
                case .people: print("Not implemented.")
                }
                
            })
            .map { _ in return () }
            .asDriver(onErrorJustReturn: ())
        
        return Output(switchHidden: switchHidden,
                      loading: loading,
                      results: mappedResults,
                      selectedDone: selectedDone)
    }
}

enum SearchResultItemType {
    case movies, people
}

struct SearchResultItem {
    let id: Int
    let title: String
    let subtitle: String
    let imageUrl: String?
    let type: SearchResultItemType
}

struct SearchResultItemViewModel {
    let title: String
    let subtitle: String
    let imageUrl: String?
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

extension SearchResultItemViewModel {
    init(searchResultItem: SearchResultItem) {
        self.title = searchResultItem.title
        self.subtitle = searchResultItem.subtitle
        self.imageUrl = searchResultItem.imageUrl
    }
}
