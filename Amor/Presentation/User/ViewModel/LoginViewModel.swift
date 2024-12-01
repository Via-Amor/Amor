//
//  LoginViewModel.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    private let useCase: UserUseCase
    private let disposeBag = DisposeBag()
    
    init(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let loginButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let emailValid: Observable<Bool>
        let passwordValid: Observable<Bool>
        let loginButtonEnabled: Observable<Bool>
    }
    
}

extension LoginViewModel {
    func transform(_ input: Input) -> Output {
        let emailValid = input.loginButtonClicked
            .withLatestFrom(input.emailText)
            .withUnretained(self)
            .map { $1 }
            .flatMap { email in
                self.useCase.validateEmail(email)
            }
            .share(replay: 1)
        
        let passwordValid = input.loginButtonClicked
            .withLatestFrom(input.passwordText)
            .withUnretained(self)
            .map { $1 }
            .flatMap { password in
                self.useCase.validatePassword(password)
            }
            .share(replay: 1)
        
        let loginButtonEnabled = Observable.combineLatest(input.emailText, input.passwordText)
            .map { $0.count > 0 && $1.count > 0}
            .share(replay: 1)
        
        Observable.zip(emailValid, passwordValid)
            .filter { $0 && $1 }
            .withLatestFrom(Observable.combineLatest(input.emailText, input.passwordText))
            .withUnretained(self)
            .map { _, value in
                let (email, password) = value
                return LoginRequestModel(email: email, password: password)
            }
            .flatMap { request in
                self.useCase.login(request: request)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            emailValid: emailValid,
            passwordValid: passwordValid,
            loginButtonEnabled: loginButtonEnabled
        )
    }
}
