//
//  SpaceRepository.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import RxSwift

protocol SpaceRepository {
    func fetchSpaceInfo(request: SpaceRequestDTO) 
    -> Single<Result<SpaceInfoResponseDTO, NetworkError>>
    func fetchSpaceMembers(request: SpaceMembersRequestDTO) 
    -> Single<Result<[SpaceMemberResponseDTO], NetworkError>>
    func fetchAllMySpaces() 
    -> Single<Result<[SpaceSimpleInfoResponseDTO], NetworkError>>
    func fetchAddSpace(body: EditSpaceRequestDTO)
    -> Single<Result<SpaceSimpleInfoResponseDTO, NetworkError>>
    func fetchEditSpaceInfo(request: SpaceRequestDTO, body: EditSpaceRequestDTO)
    -> Single<Result<SpaceSimpleInfoResponseDTO, NetworkError>>
}
