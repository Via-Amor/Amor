//
//  UserUseCase.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation
import RxSwift

protocol UserUseCase {
    func validateEmail(_ email: String) -> Observable<Bool>
    func validatePassword(_ password: String) -> Observable<Bool>
    func login(request: LoginRequestModel) -> Single<Result<LoginModel, NetworkError>>
}

final class DefaultUserUseCase: UserUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func validateEmail(_ email: String) -> Observable<Bool> {
        return Observable.just(email.validateRegex(regex: .email))
    }
    
    func validatePassword(_ password: String) -> Observable<Bool> {
        return Observable.just(password.validateRegex(regex: .password))
    }
    
    func login(request: LoginRequestModel) -> Single<Result<LoginModel, NetworkError>> {
        repository.login(requestDTO: request.toDTO())
            .flatMap { result in
                switch result {
                case .success(let value):
                    UserDefaultsStorage.token = value.token.accessToken
                    UserDefaultsStorage.refresh = value.token.refreshToken
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
}
