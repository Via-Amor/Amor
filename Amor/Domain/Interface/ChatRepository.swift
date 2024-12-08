//
//  ChatRepository.swift
//  Amor
//
//  Created by 김상규 on 12/8/24.
//

import RxSwift

// 채팅 공통 레포지토리
protocol ChatRepository {
    func fetchChatList(requestDTO: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>>
    func postChat(
        requestDTO: ChatRequestDTO,
        bodyDTO: ChatRequestBodyDTO
    )
    -> Single<Result<ChatResponseDTO, NetworkError>>
}
