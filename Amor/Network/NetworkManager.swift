//
//  NetworkManager.swift
//  Amor
//
//  Created by 홍정민 on 11/1/24.
//

import Foundation
import Moya
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }

    func callNetwork<U: TargetType, T: Decodable>(
        target: U,
        response: T.Type
    ) -> Single<Result<T, NetworkError>> {
        let provider = MoyaProvider<U>()
        let result = Single<Result<T, NetworkError>>.create { observer in
            provider.request(target) { result in
                guard let statusCode = try? result.get().statusCode else { return }
                switch result {
                case .success(let value):
                    if statusCode == 200 {
                        do {
                            let data = try value.map(T.self)
                            observer(.success(.success(data)))
                        } catch {
                            observer(.success(.failure(NetworkError.decodeFailed)))
                        }
                    } else {
                        observer(.success(.failure(NetworkError.invalidStatus)))
                    }
                case .failure(let error):
                    observer(.success(.failure(NetworkError.commonError)))
                }
            }
            return Disposables.create()
        }
        return result
    }
}
