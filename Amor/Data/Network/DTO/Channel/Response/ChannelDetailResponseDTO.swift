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
    // 채팅방 상단 영역 데이터로 변환
    func toDomain() -> ChannelSummary {
        ChannelSummary(
            channel_id: self.channel_id,
            name: self.name,
            memberCount: self.channelMembers.count
        )
    }
}
