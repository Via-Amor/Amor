//
//  ChatRequest.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

struct ChatRequest {
    let workspaceId: String
    let id: String
    let cursor_date: String
}

extension ChatRequest {
    func toDTO() -> ChatRequestDTO {
        return ChatRequestDTO(
            workspaceId: workspaceId,
            id: id,
            cursor_date: cursor_date
        )
    }
}
