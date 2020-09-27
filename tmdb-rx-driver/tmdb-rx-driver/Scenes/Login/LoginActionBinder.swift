//
//  LoginActionBinder.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 24.09.2020.
//

import Foundation

final class LoginActionBinder: ViewControllerBinder {
    private let driver: LoginDriving
    unowned let viewController: LoginViewController
    
    init(viewController: LoginViewController, driver: LoginDriving) {
        self.driver = driver
        self.viewController = viewController
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        let userName = viewController.usernameTextField.rx.text.map({ $0 ?? "" })
        let password = viewController.passwordTextField.rx.text.map({ $0 ?? "" })
        
        viewController.bag.insert(
            userName.bind(onNext: set(unowned: self, to: \.driver.userName)),
            password.bind(onNext: set(unowned: self, to: \.driver.password)),
            viewController.loginButton.rx.tap.bind(onNext: driver.login)
        )
    }
}
