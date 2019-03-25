//
//  ReposReactor.swift
//  Reactor
//
//  Created by KangJungu on 25/03/2019.
//  Copyright © 2019 June. All rights reserved.
//

import RxSwift
import ReactorKit

final class ReposReactor:Reactor {
    enum Action {
        case ready
        case search(text:String)
        case selected(index:IndexPath)
    }
    
    enum Mutation {
        case indicator(start:Bool)
        case selected(index:IndexPath)
        case searchEnded(repos:[Repo])
    }
    
    struct State {
        var loading:Bool
        var respoViewModels:[RepoViewModel] {return respos.map{RepoViewModel(repo: $0)}}
        fileprivate var respos:[Repo]
        var selectedRepoId:Int?
    }
    
    struct Dependencies {
        let networking: NetworkingService
    }
    
    private let dependencies: Dependencies
    let initialState: ReposReactor.State
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.initialState = State(loading: false, respos: [], selectedRepoId: nil)
    }
    
    func mutate(action: ReposReactor.Action) -> Observable<ReposReactor.Mutation> {
        switch action {
        case .ready:
            return self.search("swift")
        case .search(let text):
            guard text.count > 2 else {return Observable.empty()}
            return self.search(text)
        case .selected(let indexPath):
            return Observable.just(Mutation.selected(index: indexPath))
        }
    }
    
    private func search(_ text:String) -> Observable<Mutation> {
        let searchObservable:Observable<Mutation> = self.dependencies.networking.searchRepos(withQuery: text).map{Mutation.searchEnded(repos: $0)}
        
        return Observable<ReposReactor.Mutation>.concat(
            Observable.just(Mutation.indicator(start: true)),
            searchObservable,
            Observable.just(Mutation.indicator(start: false))
        )
    }
    
    func reduce(state: ReposReactor.State, mutation: ReposReactor.Mutation) -> ReposReactor.State {
        var state = state
        switch mutation {
        case .indicator(let start):
            state.loading = start
        case .searchEnded(let repos):
            state.respos = repos
        case .selected(let index):
            state.selectedRepoId = currentState.respos[index.item].id
        }
        return state
    }
}
