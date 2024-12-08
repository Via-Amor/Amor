//
//  Chat.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation
import RealmSwift

struct Chat {
    let id: String
    let name: String
    let chat_id: String
    let profileImage: String?
    let nickname: String
    let content: String?
    let createdAt: String
    let files: [String]
    let userId: String
    let email: String
}

extension Chat {
    func toDTO() -> ChannelChat {
        let fileList = List<String>()
        fileList.append(objectsIn: self.files)
        
        return ChannelChat(
            chatId: chat_id,
            channelId: id,
            channelName: name,
            content: content,
            createAt: createdAt.toServerDate(),
            files: fileList,
            userId: userId,
            email: email,
            nickname: nickname,
            profileImage: profileImage
        )
    }
    
    func toDTO() -> DMChat {
        let fileList = List<String>()
        fileList.append(objectsIn: self.files)
        
        return DMChat(
            dmId: chat_id,
            roomId: id,
            roomName: nickname,
            content: content,
            createAt: createdAt.toServerDate(),
            files: fileList,
            userId: userId,
            email: email,
            nickname: nickname,
            profileImage: profileImage
        )
    }
    
    func toDTO() -> DMChatResponseDTO {
        return DMChatResponseDTO(
            dm_id: chat_id,
            room_id: id,
            content: content,
            createdAt: createdAt,
            files: files,
            user: SpaceMemberDTO(
                user_id: userId,
                email: email,
                nickname: nickname,
                profileImage: profileImage
            )
        )
    }
    
    func toDTO() -> ChannelChatResponseDTO {
        return ChannelChatResponseDTO(
            channel_id: id,
            channelName: name,
            chat_id: chat_id,
            content: content,
            createdAt: createdAt,
            files: files,
            user: ChannelMemberDTO(
                user_id: userId,
                email: email,
                nickname: nickname,
                profileImage: profileImage
            )
        )
    }
}
