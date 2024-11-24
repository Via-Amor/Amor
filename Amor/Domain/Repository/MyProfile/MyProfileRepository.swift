//
//  MyProfileViewRepository.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation

protocol MyProfileRepository {
    func fetchMyProfile(completionHandler: @escaping (Result<MyProfileResponseDTO, NetworkError>) -> Void )
}
