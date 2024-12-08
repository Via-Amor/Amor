//
//  ChatRequestDTO.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

struct ChatRequestDTO: Encodable {
    let workspaceId: String
    let id: String
    let cursor_date: String
}
