//
//  DMSpaceMember.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

struct SpaceMember {
    let user_id: String
    let nickname: String
    let email: String
    let profileImage: String?
    
    init(_ dto: SpaceMemberResponseDTO) {
        self.user_id = dto.user_id
        self.nickname = dto.nickname
        self.email = dto.email
        self.profileImage = dto.profileImage
    }
}
