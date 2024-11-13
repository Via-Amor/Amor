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
    
    func login() -> Single<Result<LoginResponseDTO, NetworkError>> {
        let loginRequestDTO = LoginRequestDTO(
            email: "qwe123@gmail.com",
            password: "Qwer1234!"
        )
        
        return networkManager.callNetwork(
            target: UserTarget.login(
                body: loginRequestDTO
            ),
            response: LoginResponseDTO.self
        )
    }
    
}
