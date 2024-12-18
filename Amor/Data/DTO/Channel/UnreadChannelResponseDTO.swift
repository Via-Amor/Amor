//
//  UnreadChannelResponseDTO.swift
//  Amor
//
//  Created by 홍정민 on 12/15/24.
//

import Foundation

struct UnreadChannelResponseDTO:Decodable {
    let channel_id: String
    let count: Int
}
