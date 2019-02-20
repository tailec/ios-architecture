//
//  ReposRemoteDataManager.swift
//  VIPER
//
//  Created by krawiecp-home on 20/02/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

final class ReposRemoteDataManager: ReposRemoteDataManagerType {
    private let networkingService: CancellableReposFetchable
    
    init(networkingService: CancellableReposFetchable = CancellableReposFetcher()) {
        self.networkingService = networkingService
    }
    
    func fetchRepos(for query: String, completion: @escaping ([Repo]) -> ()) {
        networkingService.fetchRepos(withQuery: query, completion: completion)
    }
}
