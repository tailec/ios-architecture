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

typealias DiscoverSelection = (item: CarouselViewModel.DataType, index: Int)

protocol DiscoverDriving {
    var didSelect: Driver<DiscoverSelection> { get }
    var state: Driver<DiscoverState> { get }
    
    func select(item: Int, index: Int)
}

final class DiscoverDriver: DiscoverDriving {
    private let bag = DisposeBag()
    private let didSelectRelay = PublishRelay<DiscoverSelection>()
    private let stateRelay = BehaviorRelay<DiscoverState>(value: .none)
    private var results: (movie: [Movie]?, person: [Person]?, show: [Show]?)? {
        didSet {
            let values = [CarouselViewModel(movies: results?.movie),
                          CarouselViewModel(people: results?.person),
                          CarouselViewModel(shows: results?.show)]
                .compactMap { $0 }
            stateRelay.accept(.results(values))
        }
    }
    private let api: TMDBApiProvider
    
    var didSelect: Driver<DiscoverSelection> { didSelectRelay.asDriver() }
    var state: Driver<DiscoverState> { stateRelay.asDriver() }
    
    init(api: TMDBApiProvider) {
        self.api = api
        bind()
    }
    
    func select(item: Int, index: Int) {
        switch item {
        case 0:
            guard let id = results?.movie?[index].id else { return }
            didSelectRelay.accept((.movie, id))
        case 1:
            didSelectRelay.accept((.person, 0))
        case 2:
            didSelectRelay.accept((.show, 0))
        default:
            break
        }
    }
    
    private func bind() {
        Observable
            .zip(api.fetchPopularMovies(), api.fetchPopularPeople(), api.fetchPopularShows())
            .bind(onNext: set(unowned: self, to: \.results))
            .disposed(by: bag)
    }
}
