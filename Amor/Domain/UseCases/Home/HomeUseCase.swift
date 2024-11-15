//
//  HomeUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    func login() -> Single<Result<LoginModel, NetworkError>>
    func getMyChannels(spaceID: String) -> Single<Result<[HomeMyChannel], NetworkError>>
    func getDMRooms(spaceID: String) -> Single<Result<[DMRoom], NetworkError>>
}

final class DefaultHomeUseCase: HomeUseCase {
    let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func login() -> Single<Result<LoginModel, NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            homeRepository.fetchLogin { result in
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
    
    func getMyChannels(spaceID: String) -> Single<Result<[HomeMyChannel], NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            homeRepository.fetchChannels(spaceID: spaceID) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.map({ $0.toDomain() }))))
                case .failure(let error):
                    print("getMyChannels error", error)
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func getDMRooms(spaceID: String) -> Single<Result<[DMRoom], NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            homeRepository.fetchDMRooms(spaceID: spaceID) { result in
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
