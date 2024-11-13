//
//  LoginViewModel.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation
import RxSwift

final class LoginViewModel: BaseViewModel {
    private let useCase: UserUseCase
    private let disposeBag = DisposeBag()
    
    init(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        useCase.login()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output()
    }
}
