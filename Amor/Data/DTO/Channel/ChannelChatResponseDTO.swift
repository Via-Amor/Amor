//
//  ChannelChatResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 12/8/24.
//

import Foundation

struct ChannelChatResponseDTO: Decodable {
    let channel_id: String
    let channelName: String
    let chat_id: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: ChannelMemberDTO
}

extension ChannelChatResponseDTO {
    func toDTO() -> ChatResponseDTO {
        return ChatResponseDTO(
            id: channel_id,
            name: channelName,
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
