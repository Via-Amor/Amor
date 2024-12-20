//
//  Token.swift
//  Amor
//
//  Created by 홍정민 on 12/20/24.
//

import Foundation

struct Token {
    let accessToken: String
    let refreshToken: String
    
    init(_ dto: TokenResponseDTO) {
        self.accessToken = dto.accessToken
        self.refreshToken = dto.refreshToken
    }
}
