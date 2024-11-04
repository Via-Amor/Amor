//
//  DMTarget.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import Moya

enum DMTarget {
    case login(body: LoginRequestDTO)
    case getWorkSpaceMember(query: DMMembersRequestDTO)
    case getDMRooms(query: DMRoomRequestDTO )
}

extension DMTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "users/login"
        case .getWorkSpaceMember(let query):
            return "workspaces/\(query.workspace_id)/members"
        case .getDMRooms(let query):
            return "workspaces/\(query.workspace_id)/dms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .getWorkSpaceMember:
            return .get
        case .getDMRooms:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        
        case .login(let body):
            return .requestJSONEncodable(body)
        case .getWorkSpaceMember:
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
        case .getWorkSpaceMember:
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
