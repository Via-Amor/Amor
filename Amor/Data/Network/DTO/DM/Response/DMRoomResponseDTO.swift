//
//  DMRoomResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation

struct DMRoomResponseDTO: Decodable {
    let room_id: String
    let createdAt: String
    let user: DMUserResponseDTO
}

struct DMUserResponseDTO: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
}

extension DMRoomResponseDTO {
    func toDomain() -> DMRoom {
        DMRoom(self)
    }
}

extension DMUserResponseDTO {
    func toDomain() -> DMUser {
        DMUser(self)
    }
}
