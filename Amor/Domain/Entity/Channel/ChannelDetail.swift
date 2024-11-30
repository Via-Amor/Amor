//
//  ChannelSummary.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

struct ChannelDetail {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
    let channelMembers: [ChannelMember]
}
