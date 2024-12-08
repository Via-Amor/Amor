//
//  SpaceMemberDTO.swift
//  Amor
//
//  Created by 김상규 on 12/8/24.
//

import Foundation

struct SpaceMemberDTO: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
}

extension SpaceMemberDTO {
    func toDomain() -> SpaceMember {
        return SpaceMember(
            user_id: user_id,
            nickname: nickname,
            email: email,
            profileImage: profileImage
        )
    }
}
