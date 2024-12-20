//
//  LoginRequest.swift
//  Amor
//
//  Created by 홍정민 on 12/20/24.
//

import Foundation

struct LoginRequest {
    let email: String
    let password: String
}

extension LoginRequest {
    func toDTO() -> LoginRequestDTO {
        return LoginRequestDTO(
            email: self.email,
            password: self.password
        )
    }
}
