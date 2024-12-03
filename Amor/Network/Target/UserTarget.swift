//
//  UserTarget.swift
//  Amor
//
//  Created by 홍정민 on 11/1/24.
//

import Foundation
import Moya

enum UserTarget {
    case login(body: LoginRequestDTO)
    case validEmail(body: ValidEmailRequestDTO)
    case refreshToken
    case getMyProfile
}

extension UserTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "users/login"
        case .validEmail:
            return "users/validation/email"
        case .refreshToken:
            return "auth/refresh"
        case .getMyProfile:
            return "users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .validEmail:
            return .post
        case .refreshToken:
            return .get
        case .getMyProfile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let body):
            return .requestJSONEncodable(body)
        case .validEmail(let body):
            return .requestJSONEncodable(body)
        case .refreshToken:
            return .requestPlain
        case .getMyProfile:
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
        case .validEmail:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey
            ]
        case .refreshToken:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.refresh.rawValue: UserDefaultsStorage.refresh
            ]
        case .getMyProfile:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}

extension UserTarget {
  var validationType: ValidationType {
      return .successCodes
  }
}
