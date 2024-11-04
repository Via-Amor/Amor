//
//  DMSpaceMember.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

struct DMSpaceMember {
    let user_id: String
    let nickname: String
    let profileImage: String?
    
    init(_ dto: DMSpaceMemberDTO) {
        self.user_id = dto.user_id
        self.nickname = dto.nickname
        self.profileImage = dto.profileImage
    }
}
