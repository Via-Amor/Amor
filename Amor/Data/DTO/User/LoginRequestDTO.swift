//
//  LoginRequestDTO.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}
