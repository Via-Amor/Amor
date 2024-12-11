//
//  DMChatResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 12/8/24.
//

import Foundation

struct DMChatResponseDTO: Decodable {
    let dm_id: String
    let room_id: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: SpaceMemberDTO
}

extension DMChatResponseDTO {
    func toDTO() -> ChatResponseDTO {
        return ChatResponseDTO(
            id: room_id,
            name: user.nickname,
            chat_id: dm_id,
            profileImage: user.profileImage,
            nickname: user.nickname,
            content: content,
            createdAt: createdAt,
            files: files,
            userId: user.user_id,
            email: user.email
        )
    }
}
