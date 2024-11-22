//
//  MyProfileTarget.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import Moya

enum MyProfileTarget {
    case getMyProfile
}

extension MyProfileTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .getMyProfile:
            return "users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyProfile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyProfile:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .getMyProfile:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
