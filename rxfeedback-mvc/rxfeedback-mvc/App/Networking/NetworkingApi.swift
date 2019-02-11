//
//  NetworkingApi.swift
//  MVVMPureObservables
//
//  Created by krawiecp-home on 25/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkingService {
    func searchRepos(withQuery query: String) -> Observable<[Repo]>
}

final class NetworkingApi: NetworkingService {
    func searchRepos(withQuery query: String) -> Observable<[Repo]> {
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(query)")!)
        return URLSession.shared.rx.data(request: request)
            .map { data -> [Repo] in
                guard let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else { return [] }
                return response.items
            }
    }
}

fileprivate struct SearchResponse: Decodable {
    let items: [Repo]
}
