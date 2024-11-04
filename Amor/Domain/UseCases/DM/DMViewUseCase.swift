//
//  DMViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMViewUseCase {
    func login() -> Single<Result<LoginModel, NetworkError>>
    func getSpaceMembers(spaceID: String) -> Single<Result<[DMSpaceMember], NetworkError>>
    func getDMRooms(spaceID: String) -> Single<Result<[DMRoom], NetworkError>>
}

final class DefaultDMViewUseCase: DMViewUseCase {
    
    private let networkManager = NetworkManager.shared
    private let repository: DMViewRepository
    
    init(repository: DMViewRepository) {
        self.repository = repository
    }
    
    func login() -> Single<Result<LoginModel, NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            repository.fetchLogin { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.toDomain())))
                case .failure(let error):
                    print("login error", error)
                    single(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getSpaceMembers(spaceID: String) -> Single<Result<[DMSpaceMember], NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            repository.fetchSpaceMembers(spaceID: spaceID) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.map({ $0.toDomain() }))))
                case .failure(let error):
                    print("getSpaceMembers error", error)
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func getDMRooms(spaceID: String) -> Single<Result<[DMRoom], NetworkError>> {
        
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            repository.fetchDMRooms(spaceID: spaceID) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.map({ $0.toDomain() }))))
                case .failure(let error):
                    print("getDMRooms error", error)
                    single(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    
}
