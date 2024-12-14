//
//  DMListContent.swift
//  Amor
//
//  Created by 홍정민 on 12/13/24.
//

import Foundation

struct DMListContent {
    let room_id: String
    let profileImage: String?
    let nickname: String
    let content: String?
    let unreadCount: Int
    let createdAt: String
    let files: [String]
}

extension DMListContent {
    func toDMRoomInfo() -> DMRoomInfo {
        return DMRoomInfo(
            room_id: room_id,
            roomName: nickname,
            profileImage: profileImage,
            content: content,
            createdAt: createdAt,
            files: files
        )
    }
}
