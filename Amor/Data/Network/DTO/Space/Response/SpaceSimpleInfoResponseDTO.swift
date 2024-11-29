//
//  SpaceSimpleInfoResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import Foundation

struct SpaceSimpleInfoResponseDTO: Decodable {
    let workspace_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
}

extension SpaceSimpleInfoResponseDTO {
    func toDomain() -> SpaceSimpleInfo {
        return SpaceSimpleInfo(self)
    }
}
