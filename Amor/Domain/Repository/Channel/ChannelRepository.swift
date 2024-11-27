//
//  HomeRepository.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift

protocol ChannelRepository {
    func fetchLogin(request: LoginRequestDTO) -> Single<Result<LoginResponseDTO, NetworkError>>
    func fetchChannels(request: ChannelRequestDTO) -> Single<Result<[ChannelResponseDTO], NetworkError>>
    func fetchChannelDetail(channelID: String) -> Single<Result<ChannelDetailResponseDTO, NetworkError>>
    func fetchChannelChatList(requestDTO: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>>
    func addChannel(path: ChannelRequestDTO, body: AddChannelRequestDTO) -> Single<Result<ChannelResponseDTO, NetworkError>>
}
