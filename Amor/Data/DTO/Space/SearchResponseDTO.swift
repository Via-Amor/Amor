//
//  SearchResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 12/14/24.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let channels: [ChannelResponseDTO]
    let workspaceMembers: [SpaceMemberResponseDTO]
}

extension SearchResponseDTO {
    func toDomain() -> SearchResult {
        SearchResult(
            channels: channels.map{
                $0.toDomain()
            },
            workspaceMembers: workspaceMembers.map{
                $0.toDomain()
            }
        )
    }
}
