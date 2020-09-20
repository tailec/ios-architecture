//
//  ViewBinder.swift
//  Headway
//
//  Created by Dmytro Shulzhenko on 5/31/19.
//  Copyright © 2019 Dmitriy. All rights reserved.
//

import Foundation
import RxSwift
import RxViewController

protocol Binding {
    func bind()
}

// MARK: - ViewControllerBinder

// swiftlint:disable view_binding_before_did_load

protocol ViewControllerBinder: Disposable {
    associatedtype DisposeViewControllerContainer: UIViewController, DisposeContainer
    
    var viewController: DisposeViewControllerContainer { get }
    
    func bindLoaded()
}

extension ViewControllerBinder {
    var bag: DisposeBag {
        viewController.bag
    }
}

extension ViewControllerBinder where Self: AnyObject {
    func bind() {
        viewController.rx.viewDidLoad
            .subscribe(onNext: unowned(self, in: Self.bindLoaded))
            .disposed(by: viewController.bag)
    }
    
    var binded: Self {
        bind()
        return self
    }
}
