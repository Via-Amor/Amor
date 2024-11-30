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
    
    // 채널 추가
    case addChannel(
        path: ChannelRequestDTO,
        body: AddChannelRequestDTO
    )
    
    // 채널 채팅 내역 조회
    case getChannelChatList(request: ChatRequestDTO)
    
    // 채널 채팅 보내기
    case postChannelChat(
        request: ChatRequestDTO,
        body: ChatRequestBodyDTO
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
        case .addChannel(let path, _):
            return "workspaces/\(path.workspaceId)/channels"
        case .getChannelChatList(let request):
            return "workspaces/\(request.workspaceId)/channels/\(request.channelId)/chats"
        case .postChannelChat(let request, _):
            return "workspaces/\(request.workspaceId)/channels/\(request.channelId)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyChannels:
            return .get
        case .getChannelDetail:
            return .get
        case .addChannel:
            return .post
        case .getChannelChatList:
            return .get
        case .postChannelChat:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyChannels:
            return .requestPlain
        case .getChannelDetail:
            return .requestPlain
        case .addChannel(_, let body):
            return .requestJSONEncodable(body)
        case .getChannelChatList(let request):
            return .requestParameters(
                parameters: ["cursor_date": request.cursor_date],
                encoding: URLEncoding.queryString
            )
        case .postChannelChat(_, let body):
            var multipartData: [MultipartFormData] = []
            
            if !body.content.isEmpty {
                let content = MultipartFormData(
                    provider: .data(body.content.data(using: .utf8)!),
                    name: "content",
                    mimeType: "text/plain"
                )
                multipartData.append(content)
            }
            
            for (idx, file) in body.files.enumerated() {
                let image = MultipartFormData(
                    provider: .data(file),
                    name: "files",
                    fileName: "\(body.fileNames[idx]).jpg",
                    mimeType: "image/jpg"
                )
                multipartData.append(image)
            }
            
            return .uploadMultipart(multipartData)
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
        case .addChannel:
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
        case .postChannelChat:
            return [
                Header.contentType.rawValue: HeaderValue.multipart.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}
