//
//  SpaceTarget.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation
import Moya

enum SpaceTarget {
    case getCurrentSpaceInfo(request: SpaceRequestDTO)
    case getSpaceMember(request: SpaceMembersRequestDTO)
    case getAllMySpaces
}

extension SpaceTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .getCurrentSpaceInfo(let request):
            return "workspaces/\(request.workspace_id)"
        case .getSpaceMember(let request):
            return "workspaces/\(request.workspace_id)/members"
        case .getAllMySpaces:
            return "workspaces/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrentSpaceInfo, .getSpaceMember, .getAllMySpaces:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCurrentSpaceInfo, .getSpaceMember, .getAllMySpaces:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCurrentSpaceInfo:
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
        case .getAllMySpaces:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
