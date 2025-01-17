//
//  MyProfileResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String?
    let sesacCoin: Int
    let createdAt: String
}

extension ProfileResponseDTO {
    func toDomain() -> Profile {
        Profile(self)
    }
}
