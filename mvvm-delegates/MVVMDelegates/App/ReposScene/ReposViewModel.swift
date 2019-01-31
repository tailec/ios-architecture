//
//  ReposViewModel.swift
//  MVVMDelegates
//
//  Created by krawiecp-home on 26/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

protocol ReposViewModelDelegate: class {
    func reposViewModel(_ reposViewModel: ReposViewModel,
                        isLoading: Bool)
    func reposViewModel(_ reposViewModel: ReposViewModel,
                        didReceiveRepos repos: [RepoViewModel])
    func reposViewModel(_ reposViewModel: ReposViewModel,
                        didSelectId id: Int)
}

final class ReposViewModel {
    weak var delegate: ReposViewModelDelegate?
    
    private var repos: [Repo]?
    
    private let throttle = Throttle(minimumDelay: 0.3)
    private var currentSearchNetworkTask: URLSessionDataTask?
    private var lastQuery: String?
    // Dependencies
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    // Inputs
    func ready() {
        delegate?.reposViewModel(self, isLoading: true)
        networkingService.searchRepos(withQuery: "swift") { [weak self] repos in
            guard let strongSelf  = self else { return }
            strongSelf.finishSearching(with: repos)
        }
    }
    
    func didChangeQuery(_ query: String) {
        guard query.count > 2,
            query != lastQuery else { return } // distinct until changed
        lastQuery = query
        
        throttle.throttle {
            self.startSearchWithQuery(query)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let repos = repos else { return }
        delegate?.reposViewModel(self, didSelectId: repos[indexPath.item].id)
    }
    
    // Private
    private func startSearchWithQuery(_ query: String) {
        currentSearchNetworkTask?.cancel() // cancel previous pending request
        
        delegate?.reposViewModel(self, isLoading: true)

        currentSearchNetworkTask = networkingService.searchRepos(withQuery: query) { [weak self] repos in
            guard let strongSelf  = self else { return }
            strongSelf.finishSearching(with: repos)
        }
    }
    
    private func finishSearching(with repos: [Repo]) {
        delegate?.reposViewModel(self, isLoading: false)
        
        self.repos = repos
        let repoViewModels = repos.map { RepoViewModel(repo: $0) }
        
        delegate?.reposViewModel(self, didReceiveRepos: repoViewModels)
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
