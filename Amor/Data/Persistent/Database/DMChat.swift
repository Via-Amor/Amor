//
//  DMChat.swift
//  Amor
//
//  Created by 김상규 on 12/6/24.
//

import Foundation
import RealmSwift

class DMChat: Object {
    @Persisted(primaryKey: true) var dmId: String
    @Persisted(indexed: true) var roomId: String
    @Persisted var roomName: String
    @Persisted var content: String?
    @Persisted var createAt: Date
    @Persisted var files: List<String>
    @Persisted var userId: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(
        dmId: String,
        roomId: String,
        roomName: String,
        content: String?,
        createAt: Date,
        files: List<String>,
        userId: String,
        email: String,
        nickname: String,
        profileImage: String? = nil
    ) {
        self.init()
        self.dmId = dmId
        self.roomName = roomName
        self.roomId = roomId
        self.content = content
        self.createAt = createAt
        self.files = files
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

extension DMChat {
    func toDomain() -> Chat {
        return Chat(
            id: roomId,
            name: nickname,
            chat_id: dmId,
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
