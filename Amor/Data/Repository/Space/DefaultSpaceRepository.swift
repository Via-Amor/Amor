//
//  DefaultSpaceRepository.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation
import RxSwift

final class DefaultSpaceRepository: SpaceRepository {
    
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
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
}
