//
//  TokenInterceptor.swift
//  Amor
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import Alamofire
import Kingfisher

final class TokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(
            name: Header.authoriztion.rawValue,
            value: UserDefaultsStorage.token
        )
        completion(.success(urlRequest))
    }
    

    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 400 else {
            completion(.doNotRetry)
            return
        }
        
        guard let data = (request as? DataRequest)?.data,
        let decodedData = try? JSONDecoder().decode(ErrorType.self, from: data), decodedData.errorCode == "E05" else {
            completion(.doNotRetry)
            return
        }
        
        print(#function, decodedData.errorCode)

        
        TokenManager.shared.refreshToken { result in
            switch result {
            case .success(let value):
                UserDefaultsStorage.token = value.accessToken
                print("리프레시 토큰 갱신🔑: \(UserDefaultsStorage.token)")
                KingfisherManager.shared.setDefaultModifier()
                completion(.retry)
            case .failure(let error):
                NotificationCenter.default.post(name: .expired, object: nil)
                completion(.doNotRetryWithError(error))
            }
        }

    }
}
