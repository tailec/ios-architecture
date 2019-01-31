//
//  ViewModelType.swift
//  MVVMPureObservables
//
//  Created by krawiecp-home on 25/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
