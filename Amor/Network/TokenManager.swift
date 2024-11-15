//
//  UserManager.swift
//  Amor
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import Moya

protocol TokenRefreshable {
    func refreshToken(completion: @escaping (Result<AuthResponseDTO, NetworkError>) -> Void)
}

final class TokenManager: TokenRefreshable {
    static let shared = TokenManager()
    private init() { }
    
    func refreshToken(completion: @escaping (Result<AuthResponseDTO, NetworkError>) -> Void) {
        let refreshTarget = UserTarget.refreshToken
        let provider = MoyaProvider<UserTarget>()
        
        provider.request(refreshTarget) { result in
            guard let statusCode = try? result.get().statusCode else { return }
            switch result {
            case .success(let value):
                if statusCode == 200 {
                    guard let data = try? value.map(AuthResponseDTO.self) else {
                        return completion(.failure(NetworkError.decodeFailed))
                    }
                    completion(.success(data))
                }
            case .failure(let error):
                print(error)
                completion(.failure(NetworkError.commonError))
            }
        }
    }
}
