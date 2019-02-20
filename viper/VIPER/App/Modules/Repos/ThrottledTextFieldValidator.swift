//
//  ThrottledTextFieldValidator.swift
//  VIPER
//
//  Created by krawiecp-home on 20/02/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

final class ThrottledTextFieldValidator {
    private var lastQuery: String?
    private let throttle: Throttle
    private let validationRule: ((String) -> Bool)
    
    init(throttle: Throttle = Throttle(minimumDelay: 0.3),
         validationRule: @escaping ((String) -> Bool) = { query in return query.count > 2 }) {
        self.throttle = throttle
        self.validationRule = validationRule
    }
    
    func validate(query: String,
                  completion: @escaping ((String?) -> ())) {
        guard validationRule(query),
            distinctUntilChanged(query) else {
                completion(nil)
                return
        }
        throttle.throttle {
            completion(query)
        }
    }
    
    private func distinctUntilChanged(_ query: String) -> Bool {
        let valid = lastQuery != query
        lastQuery = query
        return valid
    }
}
