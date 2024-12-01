//
//  LoginResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let user_id: String
    let nickname: String
    let profileImage: String?
    let token: TokenResponseDTO
}

struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension LoginResponseDTO {
    func toDomain() -> Login {
        Login(self)
    }
}

extension TokenResponseDTO {
    func toDomain() -> Token {
        Token(self)
    }
}
