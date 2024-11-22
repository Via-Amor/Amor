//
//  DMSpaceMembersResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

struct SpaceMemberResponseDTO: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
}

extension SpaceMemberResponseDTO {
    func toDomain() -> SpaceMember {
        return SpaceMember(self)
    }
}
