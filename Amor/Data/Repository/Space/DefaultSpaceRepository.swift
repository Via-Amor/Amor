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
    
    func fetchSpaceInfo(spaceID: String, completionHandler: @escaping (Result<SpaceInfoResponseDTO, NetworkError>) -> Void) {
        networkManager.callNetwork(target: SpaceTarget.getMySpacesInfo(query: SpaceRequestDTO(workspace_id: spaceID)), response: SpaceInfoResponseDTO.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let error):
                    print("fetchSpaceMembers error", error)
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchSpaceMembers(spaceID: String, completionHandler: @escaping (Result<[SpaceMemberResponseDTO], NetworkError>) -> Void) {
        let query = SpaceMembersRequestDTO(workspace_id: spaceID)
        networkManager.callNetwork(target: SpaceTarget.getSpaceMember(query: query), response: [SpaceMemberResponseDTO].self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let error):
                    print("fetchSpaceMembers error", error)
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
}
