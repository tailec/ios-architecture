//
//  TodoListViewModel.swift
//  MVVMPureObservables
//
//  Created by krawiecp-home on 25/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RepoViewModelInputs {
    func viewWillAppear()
    func didSelect(index: IndexPath)
    func didSearch(query: String)
}

protocol RepoViewModelOutputs {
    var loading: Driver<Bool> { get }
    var repos: Driver<[RepoViewModel]> { get }
    var selectedRepoId: Driver<Int> { get }
}

protocol ReposViewModelType {
    var inputs: RepoViewModelInputs { get }
    var outputs: RepoViewModelOutputs { get }
}

final class ReposViewModel: ReposViewModelType, RepoViewModelInputs, RepoViewModelOutputs {
    init() {
        let loading = ActivityIndicator()
        self.loading = loading.asDriver()
        
        let initialRepos = self.viewWillAppearSubject
            .asObservable()
            .flatMap { _ in
                AppEnvironment.current.networkingService
                    .searchRepos(withQuery: "swift")
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let searchRepos = self.didSearchSubject
            .asObservable()
            .filter { $0.count > 2}
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                AppEnvironment.current.networkingService
                    .searchRepos(withQuery: query)
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let repos = Driver.merge(initialRepos, searchRepos)
        
        self.repos = repos.map { $0.map { RepoViewModel(repo: $0)} }
        
        self.selectedRepoId = self.didSelectSubject
            .asObservable()
            .withLatestFrom(repos) { (indexPath, repos) in
                return repos[indexPath.item]
            }
            .map { $0.id }
            .asDriver(onErrorJustReturn: 0)
    }
    
    private let viewWillAppearSubject = PublishSubject<Void>()
    func viewWillAppear() {
        viewWillAppearSubject.onNext(())
    }
    
    private let didSelectSubject = PublishSubject<IndexPath>()
    func didSelect(index: IndexPath) {
        didSelectSubject.onNext(index)
    }
    
    private let didSearchSubject = PublishSubject<String>()
    func didSearch(query: String) {
        didSearchSubject.onNext(query)
    }
    
    let loading: Driver<Bool>
    let repos: Driver<[RepoViewModel]>
    let selectedRepoId: Driver<Int>
    
    var inputs: RepoViewModelInputs { return self }
    var outputs: RepoViewModelOutputs { return self }
}

struct RepoViewModel {
    let name: String
}

extension RepoViewModel {
    init(repo: Repo) {
        self.name = repo.name
    }
}
