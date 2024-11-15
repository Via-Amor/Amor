//
//  ChannelResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/15/24.
//

import Foundation

struct ChannelResponseDTO: Decodable {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
}

extension ChannelResponseDTO {
    func toDomain() -> HomeMyChannel {
        HomeMyChannel(self)
    }
}
