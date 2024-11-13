//
//  UserRepository.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation
import RxSwift

protocol UserRepository {
    func login() -> Single<Result<LoginResponseDTO, NetworkError>>
}
