//
//  HomeRepository.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift

protocol ChannelRepository {
    func fetchLogin(completionHandler: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void)
    func fetchChannels(spaceID: String, completionHandler: @escaping (Result<[ChannelResponseDTO], NetworkError>) -> Void)
    func fetchChannelDetail(channelID: String) -> Single<Result<ChannelDetailResponseDTO, NetworkError>>
    func fetchChannelChatList(path: ChannelRequestDTO, query: ChatListRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>>
}
