//
//  DMViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMUseCase {
    func makeDMRoom(
        request: DMRoomRequestDTO,
        body: DMRoomRequestDTOBody
    )
    -> Single<Result<DMRoom, NetworkError>>
    func fetchDMChatListWithCount()
    -> Observable<[DMListContent]>
}

final class DefaultDMUseCase: DMUseCase {
    private let dmRepository: DMRepository
    private let dmChatDatabase: DMChatDatabase

    init(
        dmRepository: DMRepository,
        dmChatDatabase: DMChatDatabase
    ) {
        self.dmRepository = dmRepository
        self.dmChatDatabase = dmChatDatabase
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
    
    func fetchDMChatListWithCount()
    -> Observable<[DMListContent]> {
        let request = DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
        let dmList = dmRepository.fetchDMRoomList(request: request)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, result -> Observable<[DMListContent]> in
                switch result {
                case .success(let value):
                    let dmList = value.map { room in
                        let persistChatList = owner.dmChatDatabase.fetch(roomId: room.room_id)
                            .map { $0.map { $0.toDomain() } }
                            .asObservable()
                        
                        let serverChatList = persistChatList
                            .map { chat in
                                return chat.last?.createdAt ?? ""
                            }
                            .map { lastChatDate in
                                return ChatRequest(
                                    workspaceId: UserDefaultsStorage.spaceId,
                                    id: room.room_id,
                                    cursor_date: lastChatDate
                                )
                            }
                            .flatMap { request in
                                owner.dmRepository.fetchServerDMChatList(
                                    request: request.toDTO()
                                )
                            }
                            .flatMap { result -> Observable<[Chat]> in
                                switch result {
                                case .success(let value):
                                    return .just(value.map { $0.toDomain() })
                                case .failure(let error):
                                    print(error)
                                    return .just([])
                                }
                            }
                        
                        let unReadCount = persistChatList
                            .map { chat in
                                return chat.last?.createdAt ?? ""
                            }
                            .map { lastChatDate in
                                return UnreadDMRequstDTO(
                                    roomId: room.room_id,
                                    workspaceId: UserDefaultsStorage.spaceId,
                                    after: lastChatDate
                                )
                            }
                            .flatMap { request in
                                owner.dmRepository.fetchUnreadDMCount(request: request)
                            }
                            .flatMap { result -> Observable<Int> in
                                switch result {
                                case .success(let value):
                                    return .just(value.count)
                                case .failure(let error):
                                    print(error)
                                    return .just(0)
                                }
                            }
                        
                        let dmListContent = Observable.zip(persistChatList, serverChatList, unReadCount)
                            .map { (persistChatList, serverList, unreadCount) in
                                var lastChat: Chat?
                                let savedCount = persistChatList.count
                                let totalCount = serverList.count
                                var convertUnreadCount = unreadCount
                                
                                if savedCount == 0 && unreadCount == 0 && totalCount > 0 {
                                    convertUnreadCount = totalCount
                                }
                                
                                if serverList.isEmpty {
                                    lastChat = persistChatList.last
                                } else {
                                    lastChat = serverList.last
                                }
                                
                                return DMListContent(
                                    room_id: room.room_id,
                                    profileImage: room.user.profileImage,
                                    nickname: room.user.nickname,
                                    content: lastChat?.content ?? "",
                                    unreadCount: convertUnreadCount,
                                    createdAt: lastChat?.createdAt ?? "",
                                    files: lastChat?.files ?? []
                                )
                            }
                        return dmListContent
                    }
                    return Observable.zip(dmList).ifEmpty(default: [])
                case .failure(let error):
                    print(error)
                    return Observable.just([])
                }
            }
        
        let dmListContent = dmList.flatMap { listContent in
            return Observable.just(listContent.filter {
                let createdAt = $0.createdAt
                return !createdAt.isEmpty
            })
        }
        
        return dmListContent
    }
}
