//
//  MyProfileViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import RxSwift

protocol MyProfileUseCase {
    func getMyProfile() -> Single<Result<MyProfile, NetworkError>>
}

final class DefaultMyProfileUseCase: MyProfileUseCase {
    private let repository: MyProfileRepository
    
    init(repository: MyProfileRepository) {
        self.repository = repository
    }
    
    func getMyProfile() -> Single<Result<MyProfile, NetworkError>> {
        repository.fetchMyProfile()
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.toDomain()))
                case .failure(let error):
                    print("getMyProfile error", error)
                    return .just(.failure(error))
                }
            }
    }
}
