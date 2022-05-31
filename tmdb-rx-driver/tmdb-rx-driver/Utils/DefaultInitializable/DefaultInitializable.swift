//
//  DefaultInitializable.swift
//  Headway
//
//  Created by Dmitriy on 2/19/19.
//  Copyright © 2019 Dmitriy. All rights reserved.
//

import Foundation

protocol DefaultInitializable {
    associatedtype ReturnType
    static var `default`: ReturnType { get }
}

protocol Mockable {
    associatedtype MockReturnType
    static var mock: MockReturnType { get }
}

protocol StaticFactory {
    associatedtype Factory
}

extension StaticFactory {
    static var factory: Factory.Type { return Factory.self }
}
