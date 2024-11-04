//
//  DMViewRepository.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMViewRepository {
    func fetchLogin(completionHandler: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void)
    func fetchSpaceMembers(spaceID: String, completionHandler: @escaping (Result<[DMSpaceMemberDTO], NetworkError>) -> Void)
}
