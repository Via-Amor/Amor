//
//  Chat.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation
import RealmSwift

struct Chat {
    let channel_id: String
    let channelName: String
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
            channelId: channel_id,
            channelName: channelName,
            content: content,
            createAt: createdAt.toServerDate(),
            files: fileList,
            userId: userId,
            email: email,
            nickname: nickname,
            profileImage: profileImage
        )
    }
}
