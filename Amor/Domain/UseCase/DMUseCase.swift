//
//  DMViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMUseCase {
    // DM방 조회
    func fetchDMRoomList(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoom], NetworkError>>
    
    // DM방 생성
    func makeDMRoom(
        request: DMRoomRequestDTO,
        body: DMRoomRequestDTOBody
    )
    -> Single<Result<DMRoom, NetworkError>>
    
    // DM 채팅내역 리스트
    func fetchServerDMChatList(
        request: ChatRequest
    )
    -> Single<Result<[ChatResponseDTO], NetworkError>>
    
    // 읽지 않은 채팅 개수
    func fetchUnreadDMCount(
        request: UnreadDMRequst
    )
    -> Single<Result<UnreadDMResponseDTO, NetworkError>>
}

final class DefaultDMUseCase: DMUseCase {
    private let dmRepository: DMRepository
    
    init(dmRepository: DMRepository) {
        self.dmRepository = dmRepository
    }
    
    func fetchDMRoomList(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoom], NetworkError>> {
        dmRepository.fetchDMRoomList(request: request)
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.map({ $0.toDomain() })))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func makeDMRoom(
        request: DMRoomRequestDTO,
        body: DMRoomRequestDTOBody
    ) -> Single<Result<DMRoom, NetworkError>> {
        dmRepository.makeDMRoom(request: request, body: body)
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func fetchServerDMChatList(request: ChatRequest)
    -> Single<Result<[ChatResponseDTO], NetworkError>> {
        let requestDTO = ChatRequestDTO(
            workspaceId: request.workspaceId,
            id: request.id,
            cursor_date: request.cursor_date
        )
        return self.dmRepository.fetchServerDMChatList(
            request: requestDTO
        )
    }
    
    func fetchUnreadDMCount(request: UnreadDMRequst)
    -> Single<Result<UnreadDMResponseDTO, NetworkError>> {
        let requestDTO = UnreadDMRequstDTO(
            roomId: request.id,
            workspaceId: request.workspaceId,
            after: request.after
        )
        return self.dmRepository.fetchUnreadDMCount(
            request: requestDTO
        )
    }
}
