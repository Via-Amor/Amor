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
            switch result {
            case .success(let value):
                guard let statusCode = try? result.get().statusCode else { return }
                
                if statusCode == 200 {
                    guard let data = try? value.map(AuthResponseDTO.self) else {
                        return completion(.failure(NetworkError.decodeFailed))
                    }
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.invalidStatus))
                }
            case .failure(let error):
                completion(.failure(NetworkError.commonError))
            }
        }
    }
}
