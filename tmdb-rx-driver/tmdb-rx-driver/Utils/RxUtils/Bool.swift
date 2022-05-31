//
//  Bool.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable where Element == Bool {
    func whenTrue() -> Observable<Element> {
        return filter { $0 }
    }
    
    func whenFalse() -> Observable<Element> {
        return filter { !$0 }
    }
}

extension SharedSequence where Element == Bool {
    func whenTrue() -> SharedSequence {
        return filter { $0 }
    }
    
    func whenFalse() -> SharedSequence {
        return filter { !$0 }
    }
}
