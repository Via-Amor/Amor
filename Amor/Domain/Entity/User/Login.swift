//
//  LoginModel.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

struct Login {
    let user_id: String
    let nickname: String
    let profileImage: String?
    let token: Token
    
    init(_ dto: LoginResponseDTO) {
        self.user_id = dto.user_id
        self.nickname = dto.nickname
        self.profileImage = dto.profileImage
        self.token = dto.token.toDomain()
    }
}
