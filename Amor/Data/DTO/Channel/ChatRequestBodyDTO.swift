//
//  ChatRequestBodyDTO.swift
//  Amor
//
//  Created by 홍정민 on 11/29/24.
//

import Foundation

struct ChatRequestBodyDTO: Encodable {
    let content: String
    let files: [Data]
    let fileNames: [String]
}
