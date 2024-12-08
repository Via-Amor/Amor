//
//  ChatResponseDTO.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

struct ChatResponseDTO {
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
    
    func toDomain() -> Chat {
        return Chat(
            id: id,
            name: name,
            chat_id: chat_id,
            profileImage: profileImage,
            nickname: nickname,
            content: content,
            createdAt: createdAt,
            files: files,
            userId: userId,
            email: email
        )
    }
}
