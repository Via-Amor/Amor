//
//  ChannelRouter.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation

enum SocketRouter {
    case channel(id: String)
    case dm(id: String)
    
    var route: String {
        switch self {
        case .channel(let id):
            return "/ws-channel-\(id)"
        case .dm(let id):
            return "/ws-dm-\(id)"
        }
    }
}
