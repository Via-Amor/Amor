//
//  ChannelTarget.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation
import Moya

enum ChannelTarget {
    // 내가 속한 채널 리스트 조회
    case getMyChannels(query: ChannelRequestDTO)
    
    // 특정 채널 정보 조회
    case getChannelDetail(query: ChannelRequestDTO)
    
    // 채널 채팅 내역 조회
    case getChannelChatList(request: ChatRequestDTO)
}

extension ChannelTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .getMyChannels(let query):
            return "workspaces/\(query.workspaceId)/my-channels"
        case .getChannelDetail(let query):
            return "workspaces/\(query.workspaceId)/channels/\(query.channelId)"
        case .getChannelChatList(let request):
            return "workspaces/\(request.workspaceId)/channels/\(request.channelId)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyChannels:
            return .get
        case .getChannelDetail:
            return .get
        case .getChannelChatList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyChannels:
            return .requestPlain
        case .getChannelDetail:
            return .requestPlain
        case .getChannelChatList(let request):
            return .requestParameters(
                parameters: ["cursor_date": request.cursor_date],
                encoding: URLEncoding.queryString
            )
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
        case .getChannelDetail:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .getChannelChatList:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
