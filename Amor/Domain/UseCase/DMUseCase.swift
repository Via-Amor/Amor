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
    func getServerDMs(requests: [ChatRequest]) -> Observable<([[Chat]])>
    func getRecentPersistDMs(chats: [Chat]) -> Observable<[Chat]>
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
    
    func getServerDMs(requests: [ChatRequest]) -> Observable<([[Chat]])> {
        return Observable.from(requests)
            .map {
                ChatRequestDTO(workspaceId: $0.workspaceId, id: $0.id, cursor_date: $0.cursor_date)
            }
            .flatMap { request in
                self.dmRepository.fetchChatList(requestDTO: request)
                    .map { result -> [Chat] in
                        switch result {
                        case .success(let chats):
                            return chats.map {
                                $0.toDomain()
                            }.sorted {
                                $0.createdAt.toServerDate() > $1.createdAt.toServerDate()
                            }
                        case .failure:
                            return []
                        }
                    }
            }
            .toArray()
            .asObservable()
    }
}
