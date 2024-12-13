//
//  DefaultSpaceRepository.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation
import RxSwift

final class DefaultSpaceRepository: SpaceRepository {
    
    private let networkManager: NetworkType
    private let disposeBag = DisposeBag()
    
    init(_ networkManager: NetworkType) {
        self.networkManager = networkManager
    }
    
    func fetchSpaceInfo(request: SpaceRequestDTO) -> Single<Result<SpaceInfoResponseDTO, NetworkError>> {
        return networkManager.callNetwork(target: SpaceTarget.getCurrentSpaceInfo(request: request), response: SpaceInfoResponseDTO.self)
    }
    
    func fetchSpaceMembers(request: SpaceMembersRequestDTO) -> Single<Result<[SpaceMemberResponseDTO], NetworkError>> {
        return networkManager.callNetwork(target: SpaceTarget.getSpaceMember(request: request), response: [SpaceMemberResponseDTO].self)
    }
    
    func fetchAllMySpaces() -> Single<Result<[SpaceSimpleInfoResponseDTO], NetworkError>> {
        return networkManager.callNetwork(target: SpaceTarget.getAllMySpaces, response: [SpaceSimpleInfoResponseDTO].self)
    }
    
    func fetchAddSpace(body: EditSpaceRequestDTO) -> Single<Result<SpaceSimpleInfoResponseDTO, NetworkError>> {
        return networkManager.callNetwork(target: SpaceTarget.createSpace(body: body), response: SpaceSimpleInfoResponseDTO.self)
    }
    
    func fetchEditSpaceInfo(request: SpaceRequestDTO, body: EditSpaceRequestDTO) -> Single<Result<SpaceSimpleInfoResponseDTO, NetworkError>> {
        return networkManager.callNetwork(target: SpaceTarget.editSpace(request: request, body: body), response: SpaceSimpleInfoResponseDTO.self)
    }
    
    func fetchAddMember(request: SpaceRequestDTO, body: AddMemberRequestDTO) -> Single<Result<SpaceMemberResponseDTO, NetworkError>> {
        return networkManager.callNetwork(target: SpaceTarget.addMember(request: request, body: body), response: SpaceMemberResponseDTO.self)
    }
    
    func fetchChangeSpaceOwner(request: SpaceRequestDTO, body: ChangeSpaceOwnerRequestDTO) -> Single<Result<SpaceSimpleInfoResponseDTO, NetworkError>> {
        print(request, body)
        return networkManager.callNetwork(target: SpaceTarget.changeSpaceOwner(request: request, body: body), response: SpaceSimpleInfoResponseDTO.self)
    }
    
    func fetchRemoveSpace(request: SpaceRequestDTO)
    -> Single<Result<EmptyResponseDTO, NetworkError>> {
        return networkManager.callNetworkEmptyResponse(target: SpaceTarget.deleteSpace(request: request))
    }
    
    func fetchLeaveSpace(request: SpaceRequestDTO) -> Single<Result<[SpaceSimpleInfoResponseDTO], NetworkError>> {
        return networkManager.callNetwork(target: SpaceTarget.leaveSpace(request: request), response: [SpaceSimpleInfoResponseDTO].self)
    }
}
