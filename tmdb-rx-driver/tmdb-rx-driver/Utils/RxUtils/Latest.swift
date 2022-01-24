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
}
