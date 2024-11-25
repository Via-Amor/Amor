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
    @Persisted var profileImage: String
}

extension ChannelChat {
    func toDomain() -> Chat {
        return Chat(
            profileImage: self.profileImage,
            nickname: self.nickname,
            content: self.content,
            createdAt: self.createAt,
            files: self.files.map { $0 }
        )
    }
}
