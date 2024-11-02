//
//  TokenInterceptor.swift
//  Amor
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import Alamofire
import RxSwift

final class TokenInterceptor: RequestInterceptor {
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(
            name: Header.authoriztion.rawValue,
            value: UserDefaultsStorage.token
        )
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 419 else {
             completion(.doNotRetry)
             return
         }
        
        UserManager.shared.refreshToken()
             .subscribe(with: self) { owner, result in
                 switch result {
                 case .success(let value):
                     UserDefaultsStorage.token = value.accessToken
                     completion(.retry)
                 case .failure(let error):
                     UserDefaultsStorage.removeAll()
                     completion(.doNotRetryWithError(error))
                 }
             }
             .disposed(by: disposeBag)
         
    }
}
