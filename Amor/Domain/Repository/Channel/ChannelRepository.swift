//
//  HomeRepository.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation

protocol ChannelRepository {
    func fetchLogin(completionHandler: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void)
    func fetchChannels(spaceID: String, completionHandler: @escaping (Result<[ChannelResponseDTO], NetworkError>) -> Void)
}