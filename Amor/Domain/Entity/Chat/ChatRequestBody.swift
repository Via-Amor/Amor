//
//  ChatRequestBody.swift
//  Amor
//
//  Created by 홍정민 on 11/29/24.
//

import Foundation

struct ChatRequestBody {
    let content: String
    let files: [Data]
    let fileNames: [String]
}

extension ChatRequestBody {
    func toDTO() -> ChatRequestBodyDTO {
        return ChatRequestBodyDTO(
            content: content,
            files: files,
            fileNames: fileNames
        )
    }
}
