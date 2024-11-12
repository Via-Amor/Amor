//
//  DefaultUserRepository.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation
import RxSwift

final class DefaultUserRepository: UserRepository {
    
    private let networkManager: NetworkType
    private let disposeBag = DisposeBag()
    
    init(_ networkManager: NetworkType) {
        self.networkManager = networkManager
    }
    
    func login(completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
        let loginRequestDTO = LoginRequestDTO(
            email: "qwe123@gmail.com",
            password: "Qwer1234!"
        )
        
        networkManager.callNetwork(
            target: UserTarget.login(
                body: loginRequestDTO
            ),
            response: LoginResponseDTO.self
        )
        .observe(on: MainScheduler.instance)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        .disposed(by: disposeBag)
    }
    
    func refresh(completion: @escaping (Result<AuthResponseDTO, NetworkError>) -> Void) {
        networkManager.callNetwork(
            target: UserTarget.refreshToken,
            response: AuthResponseDTO.self
        )
        .observe(on: MainScheduler.instance)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        .disposed(by: disposeBag)

    }
}
