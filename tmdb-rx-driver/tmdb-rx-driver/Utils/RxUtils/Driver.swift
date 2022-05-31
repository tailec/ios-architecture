//
//  Driver.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    func asDriver(_ file: StaticString = #file,
                  _ function: StaticString = #function,
                  _ line: UInt = #line,
                  onError: ((Error) -> Void)? = nil) -> Driver<Element> {
        asObservable()
            .do(onError: { error in
                onError?(error)
                log(.fatal(error, file, function, line))
            })
            .asDriver(onErrorRecover: { _ in .never() })
    }
    
    func asDriver(onError `default`: @escaping @autoclosure () -> Element) -> Driver<Element> {
        return Observable.create { observer in
            self.asObservable()
                .subscribe(onNext: observer.onNext,
                           onError: { error in
                            log(.error(error))
                            observer.onNext(`default`())
                },
                           onCompleted: observer.onCompleted)
            }
            .asDriver(onErrorRecover: { _ in .never() })
    }
}
