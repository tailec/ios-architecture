//
//  Just.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Completable {
    static func just(block: @escaping () throws -> Void) -> Completable {
        return Completable.create { observer in
            do {
                try block()
                observer(.completed)
            } catch let error {
                observer(.error(error))
            }
            
            return Disposables.create()
        }
    }
}

extension Single {
    static func just(block: @escaping () throws -> Element) -> Single<Element> {
        return Single.create { observer in
            do {
                let element = try block()
                observer(.success(element))
            } catch let error {
                observer(.error(error))
            }
            
            return Disposables.create()
        }
    }
}

extension PrimitiveSequenceType {
    static var completed: Completable {
        return Completable.just { }
    }
}
