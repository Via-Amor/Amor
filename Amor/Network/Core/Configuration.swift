//
//  initNetwork.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import Foundation

let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""

enum Header: String {
    case authoriztion = "Authorization"
    case contentType = "Content-Type"
    case sesacKey = "SesacKey"
    case refresh = "RefreshToken"
}

enum HeaderValue: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}

enum Parameter: String {
    case after = "after"
    case cursorDate = "cursor_date"
}

enum MultipartName: String {
    case content
    case files
    case name
    case description
}

enum MultipartType: String {
    case text = "text/plain"
    case jpg = "image/jpg"
}
