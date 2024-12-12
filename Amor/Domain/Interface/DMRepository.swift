//
//  DMViewRepository.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMRepository {
    func fetchDMRoomList(
        request: DMRoomRequestDTO
    )
    -> Single<Result<[DMRoomResponseDTO], NetworkError>>
    func makeDMRoom(
        request: DMRoomRequestDTO,
        body: DMRoomRequestDTOBody
    )
    -> Single<Result<DMRoomResponseDTO, NetworkError>>
    func postChat(
        request: ChatRequestDTO,
        body: ChatRequestBodyDTO
    )
    -> Single<Result<ChatResponseDTO, NetworkError>>
    func fetchServerDMChatList(request: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>>
    func fetchUnreadDMCount(
        request: UnreadDMRequstDTO
    )
    -> Single<Result<UnreadDMResponseDTO, NetworkError>>
}
