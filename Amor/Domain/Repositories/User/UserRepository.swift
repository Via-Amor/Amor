//
//  UserRepository.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation

protocol UserRepository {
    func login(completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void)
    func refresh(completion: @escaping (Result<AuthResponseDTO, NetworkError>) -> Void)
}
