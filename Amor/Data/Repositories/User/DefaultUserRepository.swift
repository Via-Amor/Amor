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
    
    func login(requestDTO: LoginRequestDTO) -> Single<Result<LoginResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: UserTarget.login(
                body: requestDTO
            ),
            response: LoginResponseDTO.self
        )
    }
    
}
