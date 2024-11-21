//
//  SpaceTarget.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation
import Moya

enum SpaceTarget {
    case getMySpacesInfo(query: SpaceRequestDTO)
    case getSpaceMember(query: SpaceMembersRequestDTO)
}

extension SpaceTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .getMySpacesInfo(let query):
            return "workspaces/\(query.workspace_id)"
        case .getSpaceMember(let query):
            return "workspaces/\(query.workspace_id)/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMySpacesInfo, .getSpaceMember:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMySpacesInfo, .getSpaceMember:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMySpacesInfo:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .getSpaceMember:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}