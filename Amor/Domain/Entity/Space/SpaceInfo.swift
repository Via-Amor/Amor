//
//  SpaceInfo.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation

struct SpaceInfo {
    let workspace_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
    let channels: [Channel]
    let workspaceMembers: [SpaceMember]
    
    init(_ dto: SpaceInfoResponseDTO) {
        self.workspace_id = dto.workspace_id
        self.name = dto.name
        self.description = dto.description
        self.coverImage = dto.coverImage
        self.owner_id = dto.owner_id
        self.createdAt = dto.createdAt
        self.channels = dto.channels.map { $0.toDomain() }
        self.workspaceMembers = dto.workspaceMembers.map { $0.toDomain() }
    }
}
