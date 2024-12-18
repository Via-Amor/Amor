//
//  SpaceUseCase.swift
//  Amor
//
//  Created by 홍정민 on 12/1/24.
//

import Foundation
import RxSwift

protocol SpaceUseCase {
    func getSpaceMembers(request: SpaceMembersRequestDTO)
    -> Observable<[SpaceMember]>
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
    func changeSpaceOwner(request: SpaceRequestDTO, body: ChangeSpaceOwnerRequestDTO)
    -> Single<Result<SpaceSimpleInfo, NetworkError>>
    func removeSpace(request: SpaceRequestDTO)
    -> Single<Result<Empty, NetworkError>>
    func exitSpace(request: SpaceRequestDTO)
    -> Single<Result<[SpaceSimpleInfo], NetworkError>>
    func searchInSpace(request: SpaceRequestDTO, query: SearchRequestDTO)
    -> Single<Result<SearchResult, NetworkError>>
}

final class DefaultSpaceUseCase: SpaceUseCase {

    let spaceRepository: SpaceRepository
    
    init(spaceRepository: SpaceRepository) {
        self.spaceRepository = spaceRepository
    }
    
    func getSpaceMembers(request: SpaceMembersRequestDTO) -> Observable<[SpaceMember]> {
        return spaceRepository.fetchSpaceMembers(request: request)
            .asObservable()
            .flatMap { result -> Observable<[SpaceMember]> in
                switch result {
                case .success(let success):
                    return .just(success.map {
                        $0.toDomain()
                    }.filter {
                        $0.user_id != UserDefaultsStorage.userId
                    }
                    )
                case .failure(let error):
                    print("getSpaceInfo error", error)
                    return Observable.never()
                }
            }
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
                    UserDefaultsStorage.spaceId = value.workspace_id
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
    
    func changeSpaceOwner(request: SpaceRequestDTO, body: ChangeSpaceOwnerRequestDTO) -> Single<Result<SpaceSimpleInfo, NetworkError>> {
        spaceRepository.fetchChangeSpaceOwner(request: request, body: body)
            .flatMap{ result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func removeSpace(request: SpaceRequestDTO) -> Single<Result<Empty, NetworkError>> {
        self.spaceRepository.fetchRemoveSpace(request: request)
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.toDomain()))
                case .failure(let error):
                    print("removeSpace error", error)
                    return .just(.failure(error))
                }
            }
    }
    
    func exitSpace(request: SpaceRequestDTO) -> Single<Result<[SpaceSimpleInfo], NetworkError>> {
        self.spaceRepository.fetchExitSpace(request: request)
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.map { $0.toDomain() }))
                case .failure(let error):
                    print("leaveSpace error", error)
                    return .just(.failure(error))
                }
            }
    }
    
    func searchInSpace(request: SpaceRequestDTO, query: SearchRequestDTO) -> Single<Result<SearchResult, NetworkError>> {
        self.spaceRepository.fetchSearchInSpace(request: request, query: query)
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.toDomain()))
                case .failure(let error):
                    print("searchInSpace error", error)
                    return .just(.failure(error))
                }
            }
    }
}

