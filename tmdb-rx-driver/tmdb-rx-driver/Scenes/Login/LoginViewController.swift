//
//  LoginViewController.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: DisposeViewController {
    @IBOutlet private (set) var usernameTextField: UITextField!
    @IBOutlet private (set) var passwordTextField: UITextField!
    @IBOutlet private (set) var loginButton: UIButton!
}

extension LoginViewController: StaticFactory {
    enum Factory {
        static var `default`: LoginViewController {
            let vc = R.storyboard.main.loginViewController()!
            let driver = LoginDriver.Factory.default
            let stateBinder = LoginStateBinder(viewController: vc, driver: driver)
            let actionBinder = LoginActionBinder(viewController: vc, driver: driver)
            
            let toMainDriver = driver.state.compactMap({ $0 == .success ? () : nil })
            let navigationBinder = DismissBinder<LoginViewController>.Factory
                .dismiss(viewController: vc, driver: toMainDriver)

            vc.bag.insert(stateBinder, actionBinder, navigationBinder)
            return vc
        }
    }
}
