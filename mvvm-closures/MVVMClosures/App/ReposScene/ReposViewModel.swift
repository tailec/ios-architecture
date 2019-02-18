//
//  ReposViewModel.swift
//  MVVMClosures
//
//  Created by krawiecp-home on 26/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

final class ReposViewModel {
	// Outputs
	var isRefreshing: ((Bool) -> Void)?
	var didUpdateRepos: (([RepoViewModel]) -> Void)?
	var didSelecteRepo: ((Int) -> Void)?
    
	private(set) var repos: [Repo] = [Repo]() {
		didSet {
			didUpdateRepos?(repos.map { RepoViewModel(repo: $0) })
		}
	}
    
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
        isRefreshing?(true)
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
		if repos.isEmpty { return }
        didSelecteRepo?(repos[indexPath.item].id)
    }
    
    // Private
    private func startSearchWithQuery(_ query: String) {
        currentSearchNetworkTask?.cancel() // cancel previous pending request
        
        isRefreshing?(true)

        currentSearchNetworkTask = networkingService.searchRepos(withQuery: query) { [weak self] repos in
            guard let strongSelf  = self else { return }
            strongSelf.finishSearching(with: repos)
        }
    }
    
    private func finishSearching(with repos: [Repo]) {
        isRefreshing?(false)
        self.repos = repos
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
