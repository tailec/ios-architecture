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

final class LoginViewController: UIViewController {
    var viewModel: LoginViewModel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(
            username: usernameTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTaps: loginButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.enabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.enabled
            .drive(onNext: { [weak self] enabled in
                guard let strongSelf = self else { return }
                strongSelf.loginButton.backgroundColor = enabled ?
                    UIColor(red: 255/255, green: 185/255, blue: 45/255, alpha: 1.0) :
                    UIColor.lightGray
            })
            .disposed(by: disposeBag)
        
        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        output.result
            .filter { $0 == LoginResult.failure }
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                let alert = UIAlertController(title: "Oops!", message: "Login failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                strongSelf.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
