//
//  EditProfileViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation

protocol EditProfileUseCase {
    func changeNickname(nickname: String)
    func changePhone(phone: String)
}

final class DefaultEditProfileUseCase: EditProfileUseCase {
    let element: ProfileElement
    
    init(element: ProfileElement) {
        self.element = element
    }
    
    func changeNickname(nickname: String) {
        print(nickname)
    }
    
    func changePhone(phone: String) {
        print(phone)
    }
    
    
}
