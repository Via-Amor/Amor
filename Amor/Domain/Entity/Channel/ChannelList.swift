//
//  ChannelList.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import Foundation

struct ChannelList {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let isAttend: Bool
}

extension ChannelList {
    func toChannel() -> Channel {
        return Channel(
            channel_id: channel_id,
            name: name,
            description: description,
            coverImage: coverImage,
            owner_id: owner_id  
        )
    }
}