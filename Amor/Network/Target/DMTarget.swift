//
//  DMTarget.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import Moya

enum DMTarget {
    case getDMList(request: DMRoomRequestDTO)
    case getDMRoom(request: DMRoomRequestDTO, body: DMRoomRequestDTOBody)
    // 채널 채팅 내역 조회
    case getDMChatList(request: ChatRequestDTO)
    
    // 채널 채팅 보내기
    case postDMChat(
        request: ChatRequestDTO,
        body: ChatRequestBodyDTO
    )
    
    case getUnreadDMs(
        request: UnreadDMRequstDTO
    )
}

extension DMTarget: TargetType {
    var baseURL: URL {
        return URL(string: apiUrl)!
    }
    
    var path: String {
        switch self {
        case .getDMList(let request):
            return "workspaces/\(request.workspace_id)/dms"
        case .getDMRoom(let request, _):
            return "workspaces/\(request.workspace_id)/dms"
        case .getDMChatList(let request):
            return "workspaces/\(request.workspaceId)/dms/\(request.id)/chats"
        case .postDMChat(let request, _):
            return "workspaces/\(request.workspaceId)/dms/\(request.id)/chats"
        case .getUnreadDMs(let request):
            return "workspaces/\(request.workspaceId)/dms/\(request.roomId)/unreads"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDMList:
            return .get
        case .getDMRoom:
            return .post
        case .getDMChatList:
            return .get
        case .postDMChat:
            return .post
        case .getUnreadDMs:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDMList:
            return .requestPlain
        case .getDMRoom(_, let body):
            return .requestJSONEncodable(body)
        case .getDMChatList(let request):
            return .requestParameters(
                parameters: [Parameter.cursorDate.rawValue: request.cursor_date],
                encoding: URLEncoding.queryString
            )
        case .postDMChat(_, let body):
            let multipartData = createChatMultipart(body)
            return .uploadMultipart(multipartData)
        case .getUnreadDMs(let request):
            return .requestParameters(
                parameters: [Parameter.after.rawValue: request.after],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getDMList:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .getDMRoom:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .getDMChatList:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .postDMChat:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .getUnreadDMs:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}

extension DMTarget {
  var validationType: ValidationType {
      return .successCodes
  }
}

extension DMTarget {
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
}
