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
    case createSpace(body: EditSpaceRequestDTO)
    case editSpace(request: SpaceRequestDTO, body: EditSpaceRequestDTO)
    case addMember(request: SpaceRequestDTO, body: AddMemberRequestDTO)
    case changeSpaceOwner(request: SpaceRequestDTO, body: ChangeSpaceOwnerRequestDTO)
    case removeSpace(request: SpaceRequestDTO)
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
        case .createSpace:
            return "workspaces"
        case .editSpace(let request, _):
            return "workspaces/\(request.workspace_id)"
        case .addMember(let request, _):
            return "workspaces/\(request.workspace_id)/members"
        case .changeSpaceOwner(let request, _):
            return "workspaces/\(request.workspace_id)/transfer/ownership"
        case .removeSpace(request: let request):
            return "workspaces/\(request.workspace_id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrentSpaceInfo, .getSpaceMember, .getAllMySpaces:
            return .get
        case .createSpace:
            return .post
        case .addMember:
            return .post
        case .editSpace, .changeSpaceOwner:
            return .put
        case .removeSpace:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCurrentSpaceInfo, .getSpaceMember, .getAllMySpaces:
            return .requestPlain
        case .createSpace(let body):
            var multipartData: [MultipartFormData] = []
            
            let name = MultipartFormData(
                provider: .data(body.name.data(using: .utf8)!),
                name: "name",
                mimeType: "text/plain"
            )
            multipartData.append(name)
            
            if let description = body.description {
                let data = MultipartFormData(
                    provider: .data(description.data(using: .utf8)!),
                    name: "description",
                    mimeType: "text/plain"
                )
                multipartData.append(data)
            }
            
            let data = MultipartFormData(
                provider: .data(body.image ?? Data()),
                name: "image",
                fileName: "\(body.imageName ?? "").jpg",
                mimeType: "image/jpg"
            )
            multipartData.append(data)
            
            return .uploadMultipart(multipartData)
            
        case .editSpace(_, let body):
            var multipartData: [MultipartFormData] = []
            
            let name = MultipartFormData(
                provider: .data(body.name.data(using: .utf8)!),
                name: "name",
                mimeType: "text/plain"
            )
            multipartData.append(name)
            
            if let description = body.description {
                let data = MultipartFormData(
                    provider: .data(description.data(using: .utf8)!),
                    name: "description",
                    mimeType: "text/plain"
                )
                multipartData.append(data)
            }
            
            if let image = body.image {
                let data = MultipartFormData(
                    provider: .data(image),
                    name: "image",
                    fileName: "\(body.imageName ?? "\(Date().toServerDateStr())").jpg",
                    mimeType: "image/jpg"
                )
                multipartData.append(data)
            }
            
            return .uploadMultipart(multipartData)
        case .addMember(_, let body):
            return .requestJSONEncodable(body)
        case .changeSpaceOwner(_, let body):
            return .requestJSONEncodable(body)
        case .removeSpace:
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
        case .createSpace, .editSpace:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .addMember:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .changeSpaceOwner:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        case .removeSpace:
            return [
                Header.contentType.rawValue: HeaderValue.json.rawValue,
                Header.sesacKey.rawValue: apiKey,
                Header.authoriztion.rawValue: UserDefaultsStorage.token
            ]
        }
    }
}

extension SpaceTarget {
  var validationType: ValidationType {
      return .successCodes
  }
}
