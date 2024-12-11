//
//  DMRoom.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation

struct DMRoom {
    let room_id: String
    let createdAt: String
    let user: DMUser
    
    init(_ dto: DMRoomResponseDTO) {
        self.room_id = dto.room_id
        self.createdAt = dto.createdAt
        self.user = dto.user.toDomain()
    }
    
    func toDomain() -> DMRoomInfo {
        DMRoomInfo(
            room_id: room_id,
            roomName: user.nickname,
            profileImage: user.profileImage,
            content: nil,
            createdAt: "",
            files: []
        )
    }
}

struct DMUser {
    let user_id: String
    let nickname: String
    let profileImage: String?
    
    init(_ dto: DMUserResponseDTO) {
        self.user_id = dto.user_id
        self.nickname = dto.nickname
        self.profileImage = dto.profileImage
    }
}
