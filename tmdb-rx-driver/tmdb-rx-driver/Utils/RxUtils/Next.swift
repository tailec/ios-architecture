//
//  Next.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation
import RxSwift

extension ObserverType where Element == Void {
    func onNext() {
        onNext(())
    }
}
