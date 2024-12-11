//
//  UnreadDMResponseDTO.swift
//  Amor
//
//  Created by 김상규 on 12/11/24.
//

import Foundation

struct UnreadDMResponseDTO:Decodable {
    let room_id: String
    let count: Int
}
