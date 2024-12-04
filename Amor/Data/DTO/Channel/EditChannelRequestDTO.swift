//
//  EditChannelRequestDTO.swift
//  Amor
//
//  Created by 홍정민 on 12/4/24.
//

import Foundation

struct EditChannelRequestDTO: Encodable {
    let name: String
    let description: String
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
