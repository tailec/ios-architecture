//
//  RawClosure.swift
//  Headway
//
//  Created by Dmytro Shulzhenko on 3/21/19.
//  Copyright © 2019 Dmitriy. All rights reserved.
//

import Foundation

func + <T>(lhs: @escaping (T) -> Void, rhs: @escaping (T) -> Void) -> (T) -> Void {
    return { prop in
        lhs(prop)
        rhs(prop)
    }
}

func + (lhs: @escaping () -> Void, rhs: @escaping () -> Void) -> () -> Void {
    return {
        lhs()
        rhs()
    }
}

func + <A, B>(lhs: @escaping (A, B) -> Void, rhs: @escaping () -> Void) -> (A, B) -> Void {
    return {
        lhs($0, $1)
        rhs()
    }
}
