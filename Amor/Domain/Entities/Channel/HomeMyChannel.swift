//
//  HomeMyChannel.swift
//  Amor
//
//  Created by 김상규 on 11/15/24.
//

import Foundation

struct HomeMyChannel {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    
    init(_ dto: ChannelResponseDTO) {
        self.channel_id = dto.channel_id
        self.name = dto.name
        self.description = dto.description
        self.coverImage = dto.coverImage
        self.owner_id = dto.owner_id
    }
}
