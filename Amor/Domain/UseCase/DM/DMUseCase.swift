//
//  DMViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMUseCase {
    func login() -> Single<Result<LoginModel, NetworkError>>
    func getSpaceMembers(spaceID: String) -> Single<Result<[SpaceMember], NetworkError>>
    func getDMRooms(spaceID: String) -> Single<Result<[DMRoom], NetworkError>>
}

final class DefaultDMUseCase: DMUseCase {
    
    private let networkManager = NetworkManager.shared
    private let dmRepository: DMRepository
    private let spaceRepository: SpaceRepository
    
    init(dmRepository: DMRepository, spaceRepository: SpaceRepository) {
        self.dmRepository = dmRepository
        self.spaceRepository = spaceRepository
    }
    
    func login() -> Single<Result<LoginModel, NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            dmRepository.fetchLogin { result in
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
    
    func getSpaceMembers(spaceID: String) -> Single<Result<[SpaceMember], NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            spaceRepository.fetchSpaceMembers(spaceID: spaceID) { result in
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
            dmRepository.fetchDMRooms(spaceID: spaceID) { result in
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
