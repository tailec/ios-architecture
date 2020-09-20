//
//  Latest.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    var latestIfReplayed: Element? {
        var element: Element?
        subscribe(onNext: { element = $0 }).dispose()
        return element
    }
    
    var await: Element {
        return latestIfReplayed ?? await(for: { })
    }
    
    func await(for trigger: () -> Void) -> Element {
        let group = DispatchGroup()
        
        var value: Element!
        var disposable: Disposable!
        
        group.enter()
        disposable = subscribe(onNext: { newValue in
            value = newValue
            disposable.dispose()
            group.leave()
        })
        trigger()
        group.wait()
        
        return value
    }
}
