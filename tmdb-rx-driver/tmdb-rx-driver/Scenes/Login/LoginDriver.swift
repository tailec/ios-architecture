//
//  LoginViewModel.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

enum LoginViewState {
    case success
    case failure
    case loading
    case disabled
    case enabled
}

protocol LoginDriving: class {
    var state: Driver<LoginViewState> { get }
    var userName: String { get set }
    var password: String { get set }
    func login()
}

final class LoginDriver: LoginDriving {
    private let activityIndicator = ActivityIndicator()
    private let stateRelay = PublishRelay<LoginViewState>()
    
    private let api: TMDBApiProvider
    
    let bag = DisposeBag()
    
    var state: Driver<LoginViewState> { stateRelay.asDriver() }
    var userName: String = "" { didSet { validateCredentials() } }
    var password: String = "" { didSet { validateCredentials() } }
    
    private var areCredentialsValid: Bool {
        userName.count > 0 && password.count >= 4
    }
    
    init(api: TMDBApiProvider) {
        self.api = api
        bind()
    }
    
    func login() {
        api.login(withUsername: userName, password: password)
            .trackActivity(activityIndicator)
            .map({ $0 ? .success : .failure })
            .bind(onNext: stateRelay.accept)
            .disposed(by: bag)
    }
    
    private func bind() {
        activityIndicator
            .filter({ $0 })
            .map({ _ in LoginViewState.loading })
            .drive(onNext: stateRelay.accept)
            .disposed(by: bag)
    }
    
    private func validateCredentials() {
        stateRelay.accept(areCredentialsValid ? .enabled : .disabled)
    }
}

extension LoginDriver: StaticFactory {
    enum Factory {
        static var `default`: LoginDriving {
            LoginDriver(api: TMDBApi.Factory.default)
        }
    }
}
