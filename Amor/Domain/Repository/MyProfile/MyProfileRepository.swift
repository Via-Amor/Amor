//
//  MyProfileViewRepository.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import RxSwift

protocol MyProfileRepository {
    func fetchMyProfile() -> Single<Result<MyProfileResponseDTO, NetworkError>>
}
