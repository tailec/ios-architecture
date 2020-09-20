//
//  Calable.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import RxSwift

extension Completable {
    static func fromCallable(_ execute: @escaping (@escaping (Error?) -> Void) -> Void) -> Completable {
        return Completable
            .create { observer in
                execute { error in
                    error.flatMap { observer(.error($0)) }
                    observer(.completed)
                }
                
                return Disposables.create()
        }
    }
}
