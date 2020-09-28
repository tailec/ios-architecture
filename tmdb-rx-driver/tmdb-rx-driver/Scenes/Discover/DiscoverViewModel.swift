//
//  DiscoverViewModel.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

enum DiscoverState {
    case none
    case loading
    case results([CarouselViewModel])
}

enum DiscoverSelection {
    case movie
    case person
    case show
}

final class DiscoverViewModel: ViewModelType {
    struct Input {
        let ready: Driver<Void>
        let selected: Driver<(Int, Int)>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let results: Driver<[CarouselViewModel]>
        let selected: Driver<Void>
    }
    
    struct Dependencies {
        let api: TMDBApiProvider
        let navigator: DiscoverNavigatable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: DiscoverViewModel.Input) -> DiscoverViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let loading = activityIndicator.asDriver()
        
        let results = input.ready
            .asObservable()
            .flatMap {
                 Observable.zip(self.dependencies.api.fetchPopularMovies(),
                                self.dependencies.api.fetchPopularPeople(),
                                self.dependencies.api.fetchPopularShows())
                    .trackActivity(activityIndicator)
            }
            .share()
        
        let mappedResults = results
            .map { movies, people, shows in
                return [CarouselViewModel(movies: movies),
                        CarouselViewModel(people: people),
                        CarouselViewModel(shows: shows)]
                    .compactMap { $0 } // If one of the network requests fails, CarouselViewModel is nil and compactMap removes nils from array
                                       // so the data is not displayed
            }
            .asDriver(onErrorJustReturn: [])
        
        let selected = input.selected
            .asObservable()
            .withLatestFrom(results) { ($0, $1 ) }
            .do(onNext: { [weak self] (index: (Int, Int), res: ([Movie]?, [Person]?, [Show]?)) in
                guard let strongSelf = self else { return }
                let (carouselIndex, itemIndex) = index
                let (movies, _, _) = res

                switch carouselIndex {
                case 0:
                    guard let id = movies?[itemIndex].id else { return }
                    strongSelf.dependencies.navigator.navigateToMovieDetailScreen(withMovieId: id,
                                                                                      api: strongSelf.dependencies.api)
                case 1: strongSelf.dependencies.navigator.navigateToPersonDetailScreen()
                case 2: strongSelf.dependencies.navigator.navigateToShowDetailScreen()
                default: return
                }
            })
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
            
        return Output(loading: loading,
                      results: mappedResults,
                      selected: selected)
    }
}
