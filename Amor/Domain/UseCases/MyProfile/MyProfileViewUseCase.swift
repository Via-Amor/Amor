//
//  MyProfileViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import RxSwift

protocol MyProfileViewUseCase {
    func getMyProfile() -> Single<Result<MyProfile, NetworkError>>
}

final class DefaultMyProfileUseCase: MyProfileViewUseCase {
    private let repository: MyProfileViewRepository
    
    init(repository: MyProfileViewRepository) {
        self.repository = repository
    }
    
    func getMyProfile() -> Single<Result<MyProfile, NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            repository.fetchMyProfile { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.toDomain())))
                case .failure(let error):
                    print("getMyProfile error", error)
                    single(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
}
