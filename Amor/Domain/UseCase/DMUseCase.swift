//
//  DMViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMUseCase {
    func getDMList(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoom], NetworkError>>
    func getDMRoom(request: DMRoomRequestDTO, body: DMRoomRequestDTOBody)
    -> Single<Result<DMRoom, NetworkError>>
    func getServerDMs(request: ChatRequest)
    -> Single<Result<[ChatResponseDTO], NetworkError>>
    func getRecentPersistDMs(chats: [Chat])
    -> Observable<[Chat]>
    func getUnreadDMs(request: UnreadDMRequst)
    -> Single<Result<UnreadDMResponseDTO, NetworkError>>
}

final class DefaultDMUseCase: DMUseCase {
    func getRecentPersistDMs(chats: [Chat]) -> Observable<[Chat]> {
        return Observable.just(
            chats.sorted {
                $0.createdAt.toServerDate() > $1.createdAt.toServerDate()
            }
        )
    }
    
    private let dmRepository: DMRepository
    
    init(dmRepository: DMRepository) {
        self.dmRepository = dmRepository
    }
    
    func getDMList(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoom], NetworkError>> {
        dmRepository.fetchDMList(request: request)
            .flatMap{ result in
                switch result {
                case .success(let success):
                    return .just(.success(success.map({ $0.toDomain() })))
                case .failure(let error):
                    print("getDMRooms error", error)
                    return .just(.failure(error))
                }
            }
    }
    
    func getDMRoom(request: DMRoomRequestDTO, body: DMRoomRequestDTOBody) -> Single<Result<DMRoom, NetworkError>> {
        dmRepository.fetchDMRoom(request: request, body: body)
            .flatMap{ result in
                switch result {
                case .success(let success):
                    return .just(.success(success.toDomain()))
                case .failure(let error):
                    print("getDMRoom error", error)
                    return .just(.failure(error))
                }
            }
    }
    
    func getServerDMs(request: ChatRequest) -> Single<Result<[ChatResponseDTO], NetworkError>> {
        let requestDTO = ChatRequestDTO(
            workspaceId: request.workspaceId,
            id: request.id,
            cursor_date: request.cursor_date
        )
        
        return self.dmRepository.fetchChatList(requestDTO: requestDTO)
    }
    
    func getUnreadDMs(request: UnreadDMRequst) -> Single<Result<UnreadDMResponseDTO, NetworkError>> {
        let requestDTO = UnreadDMRequstDTO(roomId: request.id, workspaceId: request.workspaceId, after: request.after)
        return self.dmRepository.fetchUnreadDMs(request: requestDTO)
    }
}
