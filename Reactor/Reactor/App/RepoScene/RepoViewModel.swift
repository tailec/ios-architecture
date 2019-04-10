//
//  RepoViewModel.swift
//  Reactor
//
//  Created by KangJungu on 25/03/2019.
//  Copyright © 2019 June. All rights reserved.
//

import Foundation

struct RepoViewModel {
    let name: String
    var hashValue:Int
}

extension RepoViewModel: Hashable {
    init(repo: Repo) {
        self.name = repo.name
        self.hashValue = repo.id.hashValue
    }
}
