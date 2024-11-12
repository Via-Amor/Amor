//
//  DMSpaceMembersResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

struct DMSpaceMemberDTO: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
}

extension DMSpaceMemberDTO {
    func toDomain() -> DMSpaceMember {
        return DMSpaceMember(self)
    }
}
