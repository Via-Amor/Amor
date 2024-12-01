//
//  UserRepository.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation
import RxSwift

protocol UserRepository {
    func login(requestDTO: LoginRequestDTO)
    -> Single<Result<LoginResponseDTO, NetworkError>>
    func fetchMyProfile() 
    -> Single<Result<MyProfileResponseDTO, NetworkError>>
}
