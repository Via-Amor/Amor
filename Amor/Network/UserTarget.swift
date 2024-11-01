//
//  UserTarget.swift
//  Amor
//
//  Created by 홍정민 on 11/1/24.
//

import Foundation
import Moya

enum UserTarget {
    case validEmail(body: ValidEmailRequestDTO)
}

extension UserTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .validEmail:
            return "users/validation/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validEmail:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .validEmail(let body):
            return .requestJSONEncodable(body)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .validEmail:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey
            ]
        }
    }
}
