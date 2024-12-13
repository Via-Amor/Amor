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
