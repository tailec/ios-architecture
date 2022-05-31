//
//  Closure.swift
//  Headway
//
//  Created by Dmytro Shulzhenko on 3/6/19.
//  Copyright © 2019 Dmitriy. All rights reserved.
//

import Foundation

struct Closure<Inputs, Outputs> {
    let closure: (Inputs) -> Outputs
    
    init(_ closure: @escaping (Inputs) -> Outputs) {
        self.closure = closure
    }
}

extension Closure {
    func execute(_ inputs: Inputs) -> Outputs {
        return closure(inputs)
    }
}

extension Closure {
    func map<T>(_ transform: @escaping (T) -> Inputs) -> Closure<T, Outputs> {
        return Closure<T, Outputs> { self.execute(transform($0)) }
    }
}

extension Closure {
    func filter(_ predicate: @escaping (Inputs) -> Bool) -> Closure<Inputs, Outputs?> {
        return Closure<Inputs, Outputs?> { predicate($0) ? self.execute($0) : nil }
    }
}
