//
//  SpaceInfoResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation

struct SpaceInfoResponseDTO: Decodable {
    let workspace_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
    let channels: [ChannelResponseDTO]
    let workspaceMembers: [SpaceMemberResponseDTO]
}

extension SpaceInfoResponseDTO {
    func toDomain() -> SpaceInfo {
        return SpaceInfo(self)
    }
}
