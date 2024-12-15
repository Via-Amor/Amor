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

    // 여기서부터 신규 작성
    
    // DM 메인 리스트 조회
    func fetchDMChatListWithCount()
    -> Observable<[DMListContent]>
    
    // 홈화면 DM 섹션 리스트 조회
    func fetchHomeDMChatListWithCount()
    -> Observable<[HomeSectionItem]>
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

extension DefaultDMUseCase {
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
                                    return .never()
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
                            .map { (persistList, serverList, count) in
                                var lastChat: Chat?
                                
                                if serverList.isEmpty {
                                    lastChat = persistList.last
                                } else {
                                    lastChat = serverList.last
                                }
                                
                                return DMListContent(
                                    room_id: room.room_id,
                                    profileImage: room.user.profileImage,
                                    nickname: room.user.nickname,
                                    content: lastChat?.content ?? "",
                                    unreadCount: count,
                                    createdAt: lastChat?.createdAt ?? "",
                                    files: lastChat?.files ?? []
                                )
                            }
                        return dmListContent
                    }
                    return Observable.zip(dmList)
                case .failure(let error):
                    print(error)
                    return Observable.never()
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
    
    func fetchHomeDMChatListWithCount()
    -> Observable<[HomeSectionItem]> {
        let request = DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
        let dmList = dmRepository.fetchDMRoomList(request: request)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, result -> Observable<[HomeDMListContent]> in
                switch result {
                case .success(let value):
                    let dmList = value.map { room in
                        let persistChatList = owner.dmChatDatabase.fetch(roomId: room.room_id)
                            .map { $0.map { $0.toDomain() } }
                            .asObservable()
                        
                        let chatRequest = ChatRequestDTO(
                            workspaceId: UserDefaultsStorage.spaceId,
                            id: room.room_id,
                            cursor_date: ""
                        )
                        
                        let totalCount = owner.dmRepository.fetchServerDMChatList(request: chatRequest)
                            .flatMap { result  in
                                switch result {
                                case .success(let value):
                                    return .just(value.count)
                                case .failure(let error):
                                    print(error)
                                    return .never()
                                }
                            }
                            .asObservable()
                        
                        let unreadCount = persistChatList
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
                        
                        let dmListContent = Observable.zip(totalCount, unreadCount)
                            .map { (totalCount, unreadCount) in
                                let dmContent = HomeDMListContent(
                                    roomID: room.room_id,
                                    opponentProfile: room.user.profileImage,
                                    opponentName: room.user.nickname,
                                    totalChatCount: totalCount,
                                    unreadCount: unreadCount)
                                return dmContent
                            }
                        
                        return dmListContent
                    }
                    return Observable.zip(dmList)
                case .failure(let error):
                    print(error)
                    return Observable.never()
                }
            }
        
        let dmSectionList = dmList.flatMap { contentList in
            let filteredList = contentList.filter { $0.totalChatCount > 0 }
                .map { HomeSectionItem.dmRoomItem($0) }
            return Observable.just(filteredList)
        }
        
        return dmSectionList
    }
}
