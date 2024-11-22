//
//  NetworkError.swift
//  Amor
//
//  Created by 홍정민 on 11/1/24.
//

import Foundation

enum NetworkError: Error {
    case decodeFailed
    case invalidStatus
    case commonError
}
