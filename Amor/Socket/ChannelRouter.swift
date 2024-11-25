//
//  ChannelRouter.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation

enum ChannelRouter {
    case channel(id: String)
    
    var route: String {
        switch self {
        case .channel(let id):
            return "/ws-channel-\(id)"
        }
    }
}
