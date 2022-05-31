//
//  Loading.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func processLoading(with observer: AnyObserver<Bool>) -> Observable<Element> {
        return `do`(onNext: { _ in observer.onNext(false) },
                    onError: { _ in observer.onNext(false) },
                    onCompleted: { observer.onNext(false) },
                    onSubscribe: { observer.onNext(true) })
    }
}

extension PrimitiveSequence where Trait == CompletableTrait, Element == Swift.Never {
    func processLoading(with observer: AnyObserver<Bool>) -> Completable {
        return `do`(onError: { _ in observer.onNext(false) },
                    onCompleted: { observer.onNext(false) },
                    onSubscribe: { observer.onNext(true) })
    }
}
