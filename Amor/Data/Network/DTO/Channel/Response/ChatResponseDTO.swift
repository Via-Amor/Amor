//
//  ChatResponseDTO.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

struct ChatResponseDTO: Decodable {
    let channel_id: String
    let channelName: String
    let chat_id: String
    let content: String
    let createdAt: String
    let files: [String]
    let user: ChannelMemberDTO
}

extension ChatResponseDTO {
    func toDomain() -> Chat {
        return Chat(
            channel_id: channel_id,
            channelName: channelName,
            chat_id: chat_id,
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
