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
