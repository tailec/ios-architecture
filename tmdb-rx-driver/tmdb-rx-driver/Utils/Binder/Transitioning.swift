//
//  Transitioning.swift
//  Headway
//
//  Created by Dmytro Shulzhenko on 18.06.2020.
//  Copyright © 2020 Headway. All rights reserved.
//

import UIKit
import RxSwift

protocol Transitioning {
    associatedtype Prop
    func perform(prop: Prop)
}

final class PresentTransition<Prop>: Disposable, Transitioning {
    private let isAnimated: Bool
    private unowned let viewController: UIViewController
    private let sourceViewFactory: (() -> UIView)?
    private let presentedFactory: (Prop) -> UIViewController?
    
    init(isAnimated: Bool,
         viewController: UIViewController,
         sourceViewFactory: (() -> UIView)?,
         presentedFactory: @escaping (Prop) -> UIViewController?) {
        self.isAnimated = isAnimated
        self.viewController = viewController
        self.sourceViewFactory = sourceViewFactory
        self.presentedFactory = presentedFactory
    }
    
    func dispose() { }

    func perform(prop: Prop) {
        guard let presented = presentedFactory(prop) else { return }
        presented.popoverPresentationController?.sourceView = sourceViewFactory?()
        viewController.present(presented, animated: isAnimated)
    }
}

final class DismissTransition: Disposable, Transitioning {
    private let isAnimated: Bool
    private unowned let viewController: UIViewController

    init(isAnimated: Bool, viewController: UIViewController) {
        self.isAnimated = isAnimated
        self.viewController = viewController
    }
    
    func dispose() { }
    
    func perform(prop: Void) {
        viewController.dismiss(animated: isAnimated)
    }
}

final class NavigationPushTransition<Prop>: Disposable, Transitioning {
    private let isAnimated: Bool
    private unowned let viewController: UIViewController
    private let presentedFactory: (Prop) -> UIViewController?
    
    init(isAnimated: Bool,
         viewController: UIViewController,
         presentedFactory: @escaping (Prop) -> UIViewController?) {
        self.isAnimated = isAnimated
        self.viewController = viewController
        self.presentedFactory = presentedFactory
    }
    
    func dispose() { }

    func perform(prop: Prop) {
        guard let presented = presentedFactory(prop) else { return }
        viewController.navigationController?
            .pushViewController(presented, animated: isAnimated)
    }
}

final class NavigationPopTransition: Disposable, Transitioning {
    private let isAnimated: Bool
    private unowned let viewController: UIViewController

    init(isAnimated: Bool, viewController: UIViewController) {
        self.isAnimated = isAnimated
        self.viewController = viewController
    }
    
    func dispose() { }
    
    func perform(prop: Void) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
