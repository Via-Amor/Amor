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
    
    // 채널 편집
    case editChannel(
        path: ChannelRequestDTO,
        body: EditChannelRequestDTO
    )
    
    // 채널 삭제
    case deleteChannel(path: ChannelRequestDTO)
    
    // 채널 나가기
    case exitChannel(path: ChannelRequestDTO)
    
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
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var path: String {
        switch self {
        case .getMyChannels(let query):
            return "workspaces/\(query.workspaceId)/my-channels"
        case .getChannelDetail(let query):
            return "workspaces/\(query.workspaceId)/channels/\(query.channelId)"
        case .addChannel(let path, _):
            return "workspaces/\(path.workspaceId)/channels"
        case .editChannel(let path, _):
            return "workspaces/\(path.workspaceId)/channels/\(path.channelId)"
        case .deleteChannel(let path):
            return "workspaces/\(path.workspaceId)/channels/\(path.channelId)"
        case .exitChannel(path: let path):
            return "workspaces/\(path.workspaceId)/channels/\(path.channelId)/exit"
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
        case .editChannel:
            return .put
        case .deleteChannel:
            return .delete
        case .exitChannel:
            return .get
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
        case .editChannel(_, let body):
            let multipartData = createEditChannelMultipart(body)
            return .uploadMultipart(multipartData)
        case .deleteChannel:
            return .requestPlain
        case .exitChannel:
            return .requestPlain
        case .getChannelChatList(let request):
            return .requestParameters(
                parameters: [Parameter.cursorDate.rawValue: request.cursor_date],
                encoding: URLEncoding.queryString
            )
        case .postChannelChat(_, let body):
            let multipartData = createChatMultipart(body)
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
        case .editChannel:
            return [
                Header.contentType.rawValue: HeaderValue.multipart.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .deleteChannel:
            return [
                Header.contentType.rawValue: HeaderValue.multipart.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .exitChannel:
            return [
                Header.contentType.rawValue: HeaderValue.multipart.rawValue,
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

extension ChannelTarget {
    private func createChatMultipart(_ body: ChatRequestBodyDTO)
    -> [MultipartFormData] {
        var multipartFormData: [MultipartFormData] = []
        
        if !body.content.isEmpty {
            let content = MultipartFormData(
                provider: .data(body.content.data(using: .utf8)!),
                name: MultipartName.content.rawValue,
                mimeType: MultipartType.text.rawValue
            )
            multipartFormData.append(content)
        }
        
        for (idx, file) in body.files.enumerated() {
            let image = MultipartFormData(
                provider: .data(file),
                name: MultipartName.files.rawValue,
                fileName: "\(body.fileNames[idx]).jpg",
                mimeType: MultipartType.jpg.rawValue
            )
            multipartFormData.append(image)
        }
        
        return multipartFormData
    }
    
    private func createEditChannelMultipart(_ body: EditChannelRequestDTO) 
    -> [MultipartFormData] {
        var multipartFormData: [MultipartFormData] = []
        let name = MultipartFormData(
            provider: .data(body.name.data(using: .utf8)!),
            name: MultipartName.name.rawValue,
            mimeType: MultipartType.text.rawValue
        )
        multipartFormData.append(name)
        
        if !body.description.isEmpty {
            let description = MultipartFormData(
                provider: .data(body.description.data(using: .utf8)!),
                name: MultipartName.description.rawValue,
                mimeType: MultipartType.text.rawValue
            )
            multipartFormData.append(description)
        }

        return multipartFormData
    }
}

