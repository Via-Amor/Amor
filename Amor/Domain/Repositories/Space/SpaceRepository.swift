//
//  SpaceRepository.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation

protocol SpaceRepository {
    func fetchSpaceMembers(spaceID: String, completionHandler: @escaping (Result<[SpaceMemberResponseDTO], NetworkError>) -> Void)
}
