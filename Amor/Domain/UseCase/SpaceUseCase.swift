//
//  SpaceUseCase.swift
//  Amor
//
//  Created by 홍정민 on 12/1/24.
//

import Foundation
import RxSwift

protocol SpaceUseCase {
    func getSpaceInfo(request: SpaceRequestDTO)
    -> Single<Result<SpaceInfo, NetworkError>>
    func getAllMySpaces()
    -> Single<Result<[SpaceSimpleInfo], NetworkError>>
    func addSpace(body: EditSpaceRequestDTO)
    -> Single<Result<SpaceSimpleInfo, NetworkError>>
    func editSpaceInfo(request: SpaceRequestDTO, body: EditSpaceRequestDTO)
    -> Single<Result<SpaceSimpleInfo, NetworkError>>
    func addMember(request: SpaceRequestDTO, body: AddMemberRequestDTO)
    -> Single<Result<SpaceMember, NetworkError>>
}

final class DefaultSpaceUseCase: SpaceUseCase {
    let spaceRepository: SpaceRepository
    
    init(spaceRepository: SpaceRepository) {
        self.spaceRepository = spaceRepository
    }
  
    func getSpaceInfo(request: SpaceRequestDTO) 
    -> Single<Result<SpaceInfo, NetworkError>> {
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
    
    func getAllMySpaces() 
    -> Single<Result<[SpaceSimpleInfo], NetworkError>> {
        spaceRepository.fetchAllMySpaces()
            .flatMap{ result in
                switch result {
                case .success(let value):
                    return .just(.success(value.map{ $0.toDomain() }))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func addSpace(body: EditSpaceRequestDTO) 
    -> Single<Result<SpaceSimpleInfo, NetworkError>> {
        spaceRepository.fetchAddSpace(body: body)
            .flatMap{ result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func editSpaceInfo(request: SpaceRequestDTO, body: EditSpaceRequestDTO) 
    -> Single<Result<SpaceSimpleInfo, NetworkError>> {
        spaceRepository.fetchEditSpaceInfo(request: request, body: body)
            .flatMap{ result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func addMember(request: SpaceRequestDTO, body: AddMemberRequestDTO) -> Single<Result<SpaceMember, NetworkError>> {
        spaceRepository.fetchAddMember(request: request, body: body)
            .flatMap{ result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
}
