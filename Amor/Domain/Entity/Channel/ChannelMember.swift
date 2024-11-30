//
//  ChannelMember.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import Foundation

struct ChannelMember: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
}
