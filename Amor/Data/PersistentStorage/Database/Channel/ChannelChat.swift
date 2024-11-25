//
//  ChannelChat.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RealmSwift

class ChannelChat: Object {
    @Persisted(primaryKey: true) var chatId: String
    @Persisted(indexed: true) var channelId: String
    @Persisted var channelName: String
    @Persisted var content: String
    @Persisted var createAt: Date
    @Persisted var files: List<String>
    @Persisted var userId: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(
        chatId: String,
        channelId: String,
        channelName: String,
        content: String,
        createAt: Date,
        files: List<String>,
        userId: String,
        email: String,
        nickname: String,
        profileImage: String? = nil
    ) {
        self.init()
        self.chatId = chatId
        self.channelId = channelId
        self.channelName = channelName
        self.content = content
        self.createAt = createAt
        self.files = files
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

extension ChannelChat {
    func toDomain() -> Chat {
        return Chat(
            channel_id: channelId,
            channelName: channelName,
            chat_id: chatId,
            profileImage: profileImage,
            nickname: nickname,
            content: content,
            createdAt: createAt.toServerDateStr(),
            files: files.map { $0 },
            userId: userId,
            email: email
        )
       
    }
}
