//
//  ChatUseCase.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

// ChatUseCase
// 채널 및 DM의 채팅 목록 조회
// 채널 및 DM의 채팅 전송
// DM의 채팅 목록 및 읽지 않은 메시지 조회
// 소켓을 통한 실시간 메시지 응답
protocol ChatUseCase {
    /* Channel */
    func fetchChannelChatList(channelID: String)
    -> Single<[Chat]>
    func postServerChannelChat(
        request: ChatRequest,
        body: ChatRequestBody
    )
    -> Single<Result<Chat, NetworkError>>
    func deleteAllPersistChannelChat(id: String)
    
    /* DM */
    func fetchDMChatList(roomID: String)
    -> Single<[Chat]>
    func fetchDMChatListWithUnreadCount()
    -> Observable<[DMListContent]>
    func postServerDMChat(
        request: ChatRequest,
        body: ChatRequestBody
    )
    -> Single<Result<Chat, NetworkError>>
    func deleteAllPersistDMChat(id: String)
    
    /* Socket */
    func observeSocketChat(chatType: ChatType)
    -> Observable<[Chat]>
    func closeSocketConnection()
}


final class DefaultChatUseCase: ChatUseCase {
    private let channelChatDatabase: ChannelChatDatabase
    private let dmChatDatabase: DMChatDataBase
    private let channelRepository: ChannelRepository
    private let dmRepository: DMRepository
    private let socketIOManager: SocketIOManager
    
    init(channelChatDatabase: ChannelChatDatabase,
         dmChatDatabase: DMChatDataBase,
         channelRepository: ChannelRepository,
         dmRepository: DMRepository,
         socketIOManager: SocketIOManager) {
        self.channelChatDatabase = channelChatDatabase
        self.dmChatDatabase = dmChatDatabase
        self.channelRepository = channelRepository
        self.dmRepository = dmRepository
        self.socketIOManager = socketIOManager
    }
}

extension DefaultChatUseCase {
    func fetchChannelChatList(channelID: String)
    -> Single<[Chat]> {
        let channelChatList = channelChatDatabase.fetch(channelId: channelID)
            .map { $0.last?.toDomain() }
            .map { savedLastChat in
                ChatRequestDTO(
                    workspaceId: UserDefaultsStorage.spaceId,
                    id: channelID,
                    cursor_date: savedLastChat?.createdAt ?? ""
                )
            }
            .asObservable()
            .withUnretained(self)
            .flatMap { (owner, request) in
                owner.channelRepository.fetchChatList(request: request)
            }
            .flatMap { result -> Observable<[Chat]> in
                switch result {
                case .success(let value):
                    return .just(value.map { $0.toDomain() } )
                case .failure(let error):
                    print(error)
                    return .just([])
                }
            }
            .withUnretained(self)
            .flatMap { (owner, serverChatList) -> Single<[Chat]> in
                owner.channelChatDatabase.insert(
                    chatList: serverChatList.map { $0.toDTO() }
                )
                return owner.channelChatDatabase.fetch(
                    channelId: channelID
                ).map { $0.map { $0.toDomain() } }
            }
            .asSingle()
        
        return channelChatList
    }
    
    func postServerChannelChat(request: ChatRequest, body: ChatRequestBody)
    -> Single<Result<Chat, NetworkError>> {
        let request = request.toDTO()
        let body = body.toDTO()
        
        return channelRepository.postChat(
            request: request,
            body: body
        ).flatMap { result in
            switch result {
            case .success(let value):
                return .just(.success(value.toDomain()))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func deleteAllPersistChannelChat(id: String) {
        channelChatDatabase.deleteAll(channelId: id)
    }
}


// DM
extension DefaultChatUseCase {
    func fetchDMChatList(roomID: String)
    -> Single<[Chat]> {
        let dmChatList = dmChatDatabase.fetch(roomId: roomID)
            .map { $0.last?.toDomain() }
            .map { savedLastChat in
                ChatRequestDTO(
                    workspaceId: UserDefaultsStorage.spaceId,
                    id: roomID,
                    cursor_date: savedLastChat?.createdAt ?? ""
                )
            }
            .asObservable()
            .withUnretained(self)
            .flatMap { (owner, request) in
                owner.dmRepository.fetchServerDMChatList(request: request)
            }
            .flatMap { result -> Observable<[Chat]> in
                switch result {
                case .success(let value):
                    return .just(value.map { $0.toDomain() } )
                case .failure(let error):
                    print(error)
                    return .just([])
                }
            }
            .withUnretained(self)
            .flatMap { (owner, serverChatList) -> Single<[Chat]> in
                owner.dmChatDatabase.insert(
                    chatList: serverChatList.map { $0.toDTO() }
                )
                return owner.dmChatDatabase.fetch(
                    roomId: roomID
                ).map { $0.map { $0.toDomain() } }
            }
            .asSingle()
        
        return dmChatList
    }
    
    func fetchDMChatListWithUnreadCount()
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
                let content = $0.content ?? ""
                return !createdAt.isEmpty && !content.isEmpty
            })
        }
        
        return dmListContent
    }
    
    func postServerDMChat(request: ChatRequest, body: ChatRequestBody)
    -> Single<Result<Chat, NetworkError>> {
        let request = request.toDTO()
        let body = body.toDTO()
        
        return dmRepository.postChat(
            request: request,
            body: body
        ).flatMap { result in
            switch result {
            case .success(let value):
                return .just(.success(value.toDomain()))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func deleteAllPersistDMChat(id: String) {
        dmChatDatabase.deleteAll(dmId: id)
    }
}


// Socket
extension DefaultChatUseCase {
    func observeSocketChat(chatType: ChatType)
    -> Observable<[Chat]> {
        let router: SocketRouter
        switch chatType {
        case .channel(let channel):
            router = SocketRouter.channel(id: channel.channel_id)
        case .dm(let dmRoom):
            router = .dm(id: dmRoom?.room_id ?? "")
        }
        
        socketIOManager.establishConnection(router: router)
        return socketIOManager.receive(chatType: chatType)
            .map { $0.toDomain() }
            .withUnretained(self)
            .flatMap { (owner, chat) -> Observable<[Chat]> in
                switch chatType {
                case .channel(let channel):
                    owner.channelChatDatabase.insert(chat: chat.toDTO())
                    return owner.channelChatDatabase.fetch(channelId: channel.channel_id)
                        .map { $0.map { $0.toDomain() }}
                        .asObservable()
                case .dm(let dmRoom):
                    owner.dmChatDatabase.insert(chat: chat.toDTO())
                    return owner.dmChatDatabase.fetch(roomId: dmRoom?.room_id ?? "")
                        .map { $0.map { $0.toDomain() }}
                        .asObservable()
                    
                }
            }
        
    }
    
    func closeSocketConnection() {
        NotificationCenter.default.post(
            name: .disconnect,
            object: nil
        )
    }
}
