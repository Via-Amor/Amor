//
//  LoginViewController.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseVC<LoginView> {
    var coordinator: UserCoordinator?
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = Navigation.User.login
    }
    
    override func bind() {
        let input = LoginViewModel.Input(
            emailText: baseView.emailTextField.textField.rx.text.orEmpty,
            passwordText: baseView.passwordTextField.textField.rx.text.orEmpty,
            loginButtonClicked: baseView.loginButton.rx.tap
        )
        let output = viewModel.transform(input)
        
        output.emailValid
            .map { value in
                let color: UIColor = value ? .black: .red
                return color
            }
            .bind(to: baseView.emailTextField.titleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.passwordValid
            .map { value in
                let color: UIColor = value ? .black: .red
                return color
            }
            .bind(to: baseView.passwordTextField.titleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        Observable.zip(output.emailValid, output.passwordValid)
            .bind(with: self) { owner, value in
                let (emailValid, passwordValid) = value
                if !emailValid {
                    owner.baseView.emailTextField.textField.becomeFirstResponder()
                } else if passwordValid {
                    owner.baseView.passwordTextField.textField.becomeFirstResponder()
                }
            }
            .disposed(by: disposeBag)
        
        output.loginButtonEnabled
            .bind(with: self) { owner, value in
                if value {
                    owner.baseView.loginButton.configuration?.baseBackgroundColor = .themeGreen
                } else {
                    owner.baseView.loginButton.configuration?.baseBackgroundColor = .themeInactive
                }
            }
            .disposed(by: disposeBag)
        
        output.loginSuccess
            .drive(with: self) { owner, _ in
                owner.coordinator?.login()
            }
            .disposed(by: disposeBag)
     
        output.loginButtonEnabled
            .bind(to: baseView.loginButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
    }
    
}

