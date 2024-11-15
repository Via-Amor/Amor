//
//  HomeTarget.swift
//  Amor
//
//  Created by 김상규 on 11/15/24.
//

import Foundation
import Moya

enum HomeTarget {
    case login(body: LoginRequestDTO)
    case getMyChannels(query: ChannelRequestDTO)
    case getDMRooms(query: DMRoomRequestDTO )
}

extension HomeTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "users/login"
        case .getMyChannels(let query):
            return "workspaces/\(query.workspace_id)/my-channels"
        case .getDMRooms(let query):
            return "workspaces/\(query.workspace_id)/dms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .getMyChannels:
            return .get
        case .getDMRooms:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        
        case .login(let body):
            return .requestJSONEncodable(body)
        case .getMyChannels:
            return .requestPlain
        case .getDMRooms:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey
            ]
        case .getMyChannels:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .getDMRooms:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
