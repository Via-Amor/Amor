//
//  HomeRepository.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift

protocol ChannelRepository {
    func fetchChannels(request: ChannelRequestDTO)
    -> Single<Result<[ChannelResponseDTO], NetworkError>>
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelDetailResponseDTO, NetworkError>>
    func addChannel(
        path: ChannelRequestDTO,
        body: AddChannelRequestDTO
    )
    -> Single<Result<ChannelResponseDTO, NetworkError>>
    func editChannel(
        path: ChannelRequestDTO,
        body: EditChannelRequestDTO
    ) -> Single<Result<ChannelResponseDTO, NetworkError>>
    func deleteChannel(
        path: ChannelRequestDTO
    ) -> Single<Result<EmptyResponseDTO, NetworkError>>
    func exitChannel(
        path: ChannelRequestDTO
    ) -> Single<Result<[ChannelResponseDTO], NetworkError>>
    func changeAdmin(
        path: ChannelRequestDTO,
        body: ChangeAdminRequestDTO
    )
    -> Single<Result<ChannelResponseDTO, NetworkError>>
    func members(path: ChannelRequestDTO)
    -> Single<Result<[ChannelMemberDTO], NetworkError>>
    func fetchChatList(request: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>>
    func postChat(
        path: ChatRequestDTO,
        body: ChatRequestBodyDTO
    )
    -> Single<Result<ChatResponseDTO, NetworkError>>
}
