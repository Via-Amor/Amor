//
//  ChannelTarget.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import Foundation
import Moya

enum ChannelTarget {
    case getSpaceChannels(query: ChannelRequestDTO)
    case getMyChannels(query: ChannelRequestDTO)
    case getChannelDetail(query: ChannelRequestDTO)
    case addChannel(
        path: ChannelRequestDTO,
        body: AddChannelRequestDTO
    )
    case editChannel(
        path: ChannelRequestDTO,
        body: EditChannelRequestDTO
    )
    case deleteChannel(path: ChannelRequestDTO)
    case exitChannel(path: ChannelRequestDTO)
    case changeAdmin(
        path: ChannelRequestDTO,
        body: ChangeAdminRequestDTO
    )
    case members(path: ChannelRequestDTO)
    case getChannelChatList(request: ChatRequestDTO)
    case postChannelChat(
        path: ChatRequestDTO,
        body: ChatRequestBodyDTO
    )
    case getUnread(request: UnreadChannelRequestDTO)
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
        case .getSpaceChannels(query: let query):
            return "workspaces/\(query.workspaceId)/channels"
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
        case .changeAdmin(let path, _):
            return "workspaces/\(path.workspaceId)/channels/\(path.channelId)/transfer/ownership"
        case .members(let path):
            return "workspaces/\(path.workspaceId)/channels/\(path.channelId)/members"
        case .getChannelChatList(let request):
            return "workspaces/\(request.workspaceId)/channels/\(request.id)/chats"
        case .postChannelChat(let path, _):
            return "workspaces/\(path.workspaceId)/channels/\(path.id)/chats"
        case .getUnread(let request):
            return "workspaces/\(request.workspaceId)/channels/\(request.channelID)/unreads"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSpaceChannels:
            return .get
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
        case .changeAdmin:
            return .put
        case .members:
            return .get
        case .getChannelChatList:
            return .get
        case .postChannelChat:
            return .post
        case .getUnread:
             return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSpaceChannels:
            return .requestPlain
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
        case .changeAdmin(_, let body):
            return .requestJSONEncodable(body)
        case .members:
            return .requestPlain
        case .getChannelChatList(let request):
            return .requestParameters(
                parameters: [Parameter.cursorDate.rawValue: request.cursor_date],
                encoding: URLEncoding.queryString
            )
        case .postChannelChat(_, let body):
            let multipartData = createChatMultipart(body)
            return .uploadMultipart(multipartData)
        case .getUnread(let request):
            return .requestParameters(
                parameters: [Parameter.after.rawValue: request.after],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getSpaceChannels:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
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
        case .changeAdmin:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .members:
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
        case .getUnread:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
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

