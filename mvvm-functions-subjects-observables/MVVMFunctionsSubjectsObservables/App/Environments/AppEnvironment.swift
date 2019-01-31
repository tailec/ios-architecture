//
//  AppEnvironment.swift
//  MVVMFunctionsSubjectsObservables
//
//  Created by krawiecp-home on 26/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

final class AppEnvironment {
    static var current = Environment()
}

struct Environment {
    let networkingService: NetworkingService
    
    init(networkingService: NetworkingService = NetworkingApi()) {
        self.networkingService = networkingService
    }
}
