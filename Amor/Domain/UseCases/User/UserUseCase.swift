//
//  UserUseCase.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation
import RxSwift

protocol UserUseCase {
    func login() -> Single<Result<LoginModel, NetworkError>>
}

final class DefaultUserUseCase: UserUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func login() -> Single<Result<LoginModel, NetworkError>> {
        repository.login()
            .flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
}
