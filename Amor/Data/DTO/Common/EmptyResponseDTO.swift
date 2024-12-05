//
//  EmptyResponseDTO.swift
//  Amor
//
//  Created by 홍정민 on 12/5/24.
//

import Foundation

struct EmptyResponseDTO: Decodable { }

extension EmptyResponseDTO {
    func toDomain() -> Empty {
        return Empty()
    }
}
