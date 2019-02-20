//
//  CancellableReposFetcher.swift
//  VIPER
//
//  Created by krawiecp-home on 20/02/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

protocol CancellableReposFetchable {
    func fetchRepos(withQuery query: String, completion: @escaping (([Repo]) -> ()))
}

final class CancellableReposFetcher: CancellableReposFetchable {
    private var currentSearchNetworkTask: URLSessionDataTask?
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService = NetworkingApi()) {
        self.networkingService = networkingService
    }
    
    func fetchRepos(withQuery query: String, completion: @escaping (([Repo]) -> ())) {
        currentSearchNetworkTask?.cancel() // cancel previous pending request
        
        _ = currentSearchNetworkTask = networkingService.searchRepos(withQuery: query) { repos in
            completion(repos)
        }
    }
}
