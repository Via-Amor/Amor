//
//  EditSpaceRequestDTO.swift
//  Amor
//
//  Created by 김상규 on 11/30/24.
//

import Foundation

struct EditSpaceRequestDTO: Encodable {
    let name: String
    let description: String?
    let image: Data?
    let imageName: String?
}
