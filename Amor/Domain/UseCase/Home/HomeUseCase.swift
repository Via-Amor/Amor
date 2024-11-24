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
    func getSpaceInfo(spaceID: String) -> Single<Result<SpaceInfo, NetworkError>>
    func getMyChannels(spaceID: String) -> Single<Result<[Channel], NetworkError>>
    func getDMRooms(spaceID: String) -> Single<Result<[DMRoom], NetworkError>>
}

final class DefaultHomeUseCase: HomeUseCase {
    
    let channelRepository: ChannelRepository
    let spaceRepository: SpaceRepository
    let dmRepository: DMRepository
    
    init(channelRepository: ChannelRepository, spaceRepository: SpaceRepository, dmRepository: DMRepository) {
        self.channelRepository = channelRepository
        self.spaceRepository = spaceRepository
        self.dmRepository = dmRepository
    }
    
    func login() -> Single<Result<LoginModel, NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            channelRepository.fetchLogin { result in
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
    
    func getSpaceInfo(spaceID: String) -> RxSwift.Single<Result<SpaceInfo, NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            spaceRepository.fetchSpaceInfo(spaceID: spaceID) { result in
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
    
    func getMyChannels(spaceID: String) -> Single<Result<[Channel], NetworkError>> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            channelRepository.fetchChannels(spaceID: spaceID) { result in
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
