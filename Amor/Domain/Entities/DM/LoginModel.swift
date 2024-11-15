//
//  LoginModel.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

/* Domain: 로그인 요청 모델 
 * Request -> DTO
 */
struct LoginRequestModel {
    let email: String
    let password: String
}

extension LoginRequestModel {
    func toDTO() -> LoginRequestDTO {
        return LoginRequestDTO(
            email: self.email,
            password: self.password
        )
    }
}

/* Domain: 로그인 응답 모델 
 * DTO -> Response
 */
struct LoginModel {
    let user_id: String
    let nickname: String
    let profileImage: String?
    let token: TokenModel
    
    init(_ dto: LoginResponseDTO) {
        self.user_id = dto.user_id
        self.nickname = dto.nickname
        self.profileImage = dto.profileImage
        self.token = dto.token.toDomain()
    }
}

struct TokenModel {
    let accessToken: String
    let refreshToken: String
    
    init(_ dto: TokenResponseDTO) {
        self.accessToken = dto.accessToken
        self.refreshToken = dto.refreshToken
    }
}
