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
        let loginSuccess: Driver<Void>
    }
    
}

extension LoginViewModel {
    func transform(_ input: Input) -> Output {
        let loginSuccess = PublishRelay<Void>()
        
        let emailValid = input.loginButtonClicked
            .withLatestFrom(input.emailText)
            .withUnretained(self)
            .flatMap { owner, email in
                owner.useCase.validateEmail(email)
            }
            .share(replay: 1)
        
        let passwordValid = input.loginButtonClicked
            .withLatestFrom(input.passwordText)
            .withUnretained(self)
            .flatMap { owner, password in
                owner.useCase.validatePassword(password)
            }
            .share(replay: 1)
        
        let loginButtonEnabled = Observable.combineLatest(input.emailText, input.passwordText)
            .map { $0.count > 0 && $1.count > 0}
            .share(replay: 1)
        
        Observable.zip(emailValid, passwordValid)
            .filter { $0 && $1 }
            .withLatestFrom(Observable.combineLatest(input.emailText, input.passwordText))
            .map { value in
                let (email, password) = value
                return LoginRequest(email: email, password: password)
            }
            .withUnretained(self)
            .flatMap { owner, request in
                owner.useCase.login(request: request)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    loginSuccess.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            emailValid: emailValid,
            passwordValid: passwordValid,
            loginButtonEnabled: loginButtonEnabled, 
            loginSuccess: loginSuccess.asDriver(onErrorJustReturn: ())
        )
    }
}
