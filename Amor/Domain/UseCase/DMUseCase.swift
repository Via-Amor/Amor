//
//  DMViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMUseCase {
    func getSpaceInfo(request: SpaceRequestDTO) -> Single<Result<SpaceInfo, NetworkError>>
    func getMyProfile() -> Single<Result<MyProfile, NetworkError>>
    func getSpaceMembers(request: SpaceMembersRequestDTO)
    -> Single<Result<[SpaceMember], NetworkError>>
    func getDMRooms(request: DMRoomRequestDTO) 
    -> Single<Result<[DMRoom], NetworkError>>
}

final class DefaultDMUseCase: DMUseCase {
    private let userRepository: UserRepository
    private let dmRepository: DMRepository
    private let spaceRepository: SpaceRepository
    
    init(userRepository: UserRepository, dmRepository: DMRepository, spaceRepository: SpaceRepository) {
        self.userRepository = userRepository
        self.dmRepository = dmRepository
        self.spaceRepository = spaceRepository
    }
    
    func getSpaceInfo(request: SpaceRequestDTO) -> Single<Result<SpaceInfo, NetworkError>> {
        spaceRepository.fetchSpaceInfo(request: request)
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.toDomain()))
                case .failure(let error):
                    print("getSpaceInfo error", error)
                    return .just(.failure(error))
                }
            }
    }
    
    func getMyProfile() -> Single<Result<MyProfile, NetworkError>> {
        userRepository.fetchMyProfile()
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
    
    func getSpaceMembers(request: SpaceMembersRequestDTO) 
    -> Single<Result<[SpaceMember], NetworkError>> {
        spaceRepository.fetchSpaceMembers(request: request)
            .flatMap{ result in
                switch result {
                case .success(let success):
                    return .just(.success(success.map({ $0.toDomain() })))
                case .failure(let error):
                    print("getSpaceMembers error", error)
                    return .just(.failure(error))
                }
            }
    }
    
    func getDMRooms(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoom], NetworkError>> {
        dmRepository.fetchDMRooms(request: request)
            .flatMap{ result in
                switch result {
                case .success(let success):
                    return .just(.success(success.map({ $0.toDomain() })))
                case .failure(let error):
                    print("getDMRooms error", error)
                    return .just(.failure(error))
                }
            }
    }
}
