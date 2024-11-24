//
//  DMRoom.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation

struct DMRoom: Decodable {
    let room_id: String
    let createdAt: String
    let user: DMUser
    
    init(_ dto: DMRoomResponseDTO) {
        self.room_id = dto.room_id
        self.createdAt = dto.createdAt
        self.user = dto.user.toDomain()
    }
}

struct DMUser: Decodable {
    let user_id: String
    let nickname: String
    let profileImage: String?
    
    init(_ dto: DMUserResponseDTO) {
        self.user_id = dto.user_id
        self.nickname = dto.nickname
        self.profileImage = dto.profileImage
    }
}
