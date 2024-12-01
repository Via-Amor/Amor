//
//  MyProfile.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation

struct MyProfile {
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String?
    let sesacCoin: Int
    
    init(_ dto: MyProfileResponseDTO) {
        self.email = dto.email
        self.nickname = dto.nickname
        self.profileImage = dto.profileImage
        self.phone = dto.phone
        self.provider = dto.provider
        self.sesacCoin = dto.sesacCoin
    }
}
