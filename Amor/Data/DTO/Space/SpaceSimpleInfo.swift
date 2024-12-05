//
//  SpaceSimpleInfo.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import Foundation

struct SpaceSimpleInfo {
    let workspace_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
    var isCurrentSpace: Bool {
        return self.workspace_id == UserDefaultsStorage.spaceId
    }
    
    init(_ dto: SpaceSimpleInfoResponseDTO) {
        self.workspace_id = dto.workspace_id
        self.name = dto.name
        self.description = dto.description
        self.coverImage = dto.coverImage
        self.owner_id = dto.owner_id
        self.createdAt = dto.createdAt
    }
}
