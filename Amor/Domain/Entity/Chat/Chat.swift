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
    func toChannelChat() -> ChannelChat {
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
    
    func toDMChat() -> DMChat {
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
    

}
