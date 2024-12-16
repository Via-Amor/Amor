//
//  NetworkManager.swift
//  Amor
//
//  Created by 홍정민 on 11/1/24.
//

import Foundation
import Moya
import RxSwift

protocol NetworkType {
    func callNetwork<U: TargetType, T: Decodable>(
        target: U,
        response: T.Type
    ) -> Single<Result<T, NetworkError>>
    func callNetworkEmptyResponse<U: TargetType>(
        target: U
    ) -> Single<Result<EmptyResponseDTO, NetworkError>>
}

final class NetworkManager: NetworkType {
    static let shared = NetworkManager()
    private init() { }

    func callNetwork<U: TargetType, T: Decodable>(
        target: U,
        response: T.Type
    ) -> Single<Result<T, NetworkError>> {
        let session = Session(interceptor: TokenInterceptor())
        let provider = MoyaProvider<U>(session: session)
        let result = Single<Result<T, NetworkError>>.create { observer in
            provider.request(target) { result in
                switch result {
                case .success(let value):
                    guard let statusCode = try? result.get().statusCode else { return }
                    if statusCode == 200 {
                        do {
                            let data = try value.map(T.self)
                            observer(.success(.success(data)))
                        } catch {
                            observer(.success(.failure(NetworkError.decodeFailed)))
                        }
                    } else {
                        do {
                            let data = try value.map(ErrorType.self)
                            print("에러 메시지: ", data.errorCode)
                            observer(.success(.failure(NetworkError.invalidStatus)))
                        } catch {
                            observer(.success(.failure(NetworkError.decodeFailed)))
                        }
                    }
                case .failure(let error):
                    do {
                        if let data = error.response {
                            print(try data.map(ErrorType.self))
                            observer(.success(.failure(NetworkError.invalidStatus)))
                        } else {
                            observer(.success(.failure(NetworkError.commonError)))
                        }
                    } catch {
                        observer(.success(.failure(NetworkError.decodeFailed)))
                    }
                }
            }
            return Disposables.create()
        }
        return result
    }
    
    func callNetworkEmptyResponse<U: TargetType>(
        target: U
    ) -> Single<Result<EmptyResponseDTO, NetworkError>> {
        let session = Session(interceptor: TokenInterceptor())
        let provider = MoyaProvider<U>(session: session)
        let result = Single<Result<EmptyResponseDTO, NetworkError>>.create { observer in
            provider.request(target) { result in
                switch result {
                case .success(let value):
                    guard let statusCode = try? result.get().statusCode else { return }
                    if statusCode == 200 {
                        let emptyResponse = EmptyResponseDTO()
                        observer(.success(.success(emptyResponse)))
                    } else {
                        do {
                            let data = try value.map(ErrorType.self)
                            print("에러 메시지: ", data.errorCode)
                            observer(.success(.failure(NetworkError.invalidStatus)))
                        } catch {
                            observer(.success(.failure(NetworkError.decodeFailed)))
                        }
                    }
                case .failure:
                    observer(.success(.failure(NetworkError.commonError)))
                }
            }
            return Disposables.create()
        }
        return result
    }
}

struct ErrorType: Decodable {
    let errorCode: String
}
