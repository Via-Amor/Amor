//
//  ChannelDetailResponseDTO.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

// 특정 채널 정보 조회 시 사용
struct ChannelDetailResponseDTO: Decodable {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
    let channelMembers: [ChannelMemberDTO]
}

extension ChannelDetailResponseDTO {
    func toDomain() ->  ChannelDetail {
        return ChannelDetail(
            channel_id: self.channel_id,
            name: self.name,
            description: self.description,
            coverImage: self.coverImage,
            owner_id: self.owner_id,
            createdAt: self.createdAt,
            channelMembers: self.channelMembers.map { $0.toDomain() }
        )
    }
}
