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
//    let accessToken: String
}

struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension LoginResponseDTO {
    func toDomain() -> LoginModel {
        LoginModel(self)
    }
}

extension TokenResponseDTO {
    func toDomain() -> TokenModel {
        TokenModel(self)
    }
}
