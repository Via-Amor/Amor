//
//  AddChannelRequestDTO.swift
//  Amor
//
//  Created by 김상규 on 11/27/24.
//

import Foundation

struct AddChannelRequestDTO: Encodable {
    let name: String
    let description: String?
    let image: String?
    
    init(name: String, description: String?, image: String? = nil) {
        self.name = name
        self.description = description
        self.image = image
    }
}
