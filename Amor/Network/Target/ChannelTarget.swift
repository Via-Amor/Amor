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
    case getChannelChatList(
        path: ChannelRequestDTO,
        query: ChatListRequestDTO
    )
    
    case addChannel(
        path: ChannelRequestDTO,
        body: AddChannelRequestDTO
    )
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
        case .getChannelChatList(let path, _):
            return "workspaces/\(path.workspaceId)/channels/\(path.channelId)/chats"
        case .addChannel(let path, _):
            return "workspaces/\(path.workspaceId)/channels"
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
        case .addChannel:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyChannels:
            return .requestPlain
        case .getChannelDetail:
            return .requestPlain
        case .getChannelChatList(_, let query):
            return .requestParameters(
                parameters: ["cursor_date": query.cursor_date],
                encoding: URLEncoding.queryString
            )
        case .addChannel(_, let body):
            return .requestJSONEncodable(body)
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
        case .addChannel:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
