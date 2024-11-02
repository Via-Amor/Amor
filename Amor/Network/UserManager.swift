//
//  UserManager.swift
//  Amor
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import RxSwift

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    func refreshToken() -> Single<Result<AuthResponseDTO, NetworkError>> {
        let refreshTarget = UserTarget.refreshToken
        
        return NetworkManager.shared.callNetwork(
            target: refreshTarget,
            response: AuthResponseDTO.self)
    }
}
