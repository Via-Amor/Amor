//
//  ChannelTarget.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation
import Moya

enum ChannelTarget {
    case getMyChannels(query: ChannelRequestDTO)
}

extension ChannelTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .getMyChannels(let query):
            return "workspaces/\(query.workspace_id)/my-channels"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyChannels:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyChannels:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMyChannels:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
