//
//  DMTarget.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import Moya

enum DMTarget {
    case getDMRooms(request: DMRoomRequestDTO)
}

extension DMTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .getDMRooms(let query):
            return "workspaces/\(query.workspace_id)/dms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDMRooms:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDMRooms:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getDMRooms:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
