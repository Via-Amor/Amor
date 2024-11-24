//
//  ChannelRequestDTO.swift
//  Amor
//
//  Created by 김상규 on 11/15/24.
//

import Foundation

struct ChannelRequestDTO: Decodable {
    var workspaceId: String = UserDefaultsStorage.spaceId
    var channelId: String = ""
}
