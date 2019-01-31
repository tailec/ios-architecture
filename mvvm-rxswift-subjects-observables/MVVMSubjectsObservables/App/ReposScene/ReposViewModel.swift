//
//  TodoListViewModel.swift
//  MVVMPureObservables
//
//  Created by krawiecp-home on 25/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

final class ReposViewModel {
    // Inputs
    let viewWillAppearSubject = PublishSubject<Void>()
    let selectedIndexSubject = PublishSubject<IndexPath>()
    let searchQuerySubject = BehaviorSubject(value: "")
    
    // Outputs
    var loading: Driver<Bool>
    var repos: Driver<[RepoViewModel]>
    var selectedRepoId: Driver<Int>
    
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
        
        let loading = ActivityIndicator()
        self.loading = loading.asDriver()
        
        let initialRepos = self.viewWillAppearSubject
            .asObservable()
            .flatMap { _ in
                networkingService
                    .searchRepos(withQuery: "swift")
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let searchRepos = self.searchQuerySubject
            .asObservable()
            .filter { $0.count > 2}
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                networkingService
                    .searchRepos(withQuery: query)
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let repos = Driver.merge(initialRepos, searchRepos)
        
        self.repos = repos.map { $0.map { RepoViewModel(repo: $0)} }
        
        self.selectedRepoId = self.selectedIndexSubject
            .asObservable()
            .withLatestFrom(repos) { (indexPath, repos) in
                return repos[indexPath.item]
            }
            .map { $0.id }
            .asDriver(onErrorJustReturn: 0)
    }
}

struct RepoViewModel {
    let name: String
}

extension RepoViewModel {
    init(repo: Repo) {
        self.name = repo.name
    }
}
