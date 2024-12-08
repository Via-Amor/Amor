//
//  ChatResponseDTO.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

struct DMChatResponseDTO: Decodable {
    let dm_id: String
    let room_id: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: ChannelMemberDTO
    
    func toDTO() -> ChatResponseDTO {
        return ChatResponseDTO(
            channel_id: room_id,
            channelName: user.nickname,
            chat_id: dm_id,
            content: content,
            createdAt: createdAt,
            files: files,
            user: ChannelMemberDTO(user_id: user.user_id, email: user.email, nickname: user.nickname, profileImage: user.profileImage)
        )
    }
}

struct ChatResponseDTO: Decodable {
    let channel_id: String
    let channelName: String
    let chat_id: String
    let content: String?
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
