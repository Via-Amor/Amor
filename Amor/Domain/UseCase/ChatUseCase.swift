//
//  ChatUseCase.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatUseCase {
    func fetchChannelChatList(channelID: String)
    -> Single<[ChatListContent]>
    func postServerChannelChat(
        channelID: String,
        request: ChatRequestBody
    )
    -> Single<Result<Chat, NetworkError>>
    func fetchDMChatList(roomID: String)
    -> Single<[ChatListContent]>
    func postServerDMChat(
        roomID: String,
        request: ChatRequestBody
    )
    -> Single<Result<Chat, NetworkError>>
    func observeSocketChat(chatType: ChatType)
    -> Observable<[ChatListContent]>
    func closeSocketConnection()
}


final class DefaultChatUseCase: ChatUseCase {
    private let channelChatDatabase: ChannelChatDatabase
    private let dmChatDatabase: DMChatDatabase
    private let channelRepository: ChannelRepository
    private let dmRepository: DMRepository
    private let socketIOManager: SocketIOManager
    
    init(channelChatDatabase: ChannelChatDatabase,
         dmChatDatabase: DMChatDatabase,
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
    -> Single<[ChatListContent]> {
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
            .flatMap { (owner, serverChatList) -> Single<[ChatListContent]> in
                owner.channelChatDatabase.insert(
                    chatList: serverChatList.map { $0.toChannelChat() }
                )
                return owner.channelChatDatabase.fetch(
                    channelId: channelID
                ).map {
                    $0.map { chat in
                        var isMyChat = false
                        if chat.userId == UserDefaultsStorage.userId {
                            isMyChat = true
                        }
                        return ChatListContent(
                            profileImage: chat.profileImage,
                            nickname: chat.nickname,
                            content: chat.content,
                            createdAt: chat.createAt.toServerDateStr(),
                            files: chat.files.map { $0 },
                            isMyChat: isMyChat
                        )
                    }
                }
            }
            .asSingle()
        
        return channelChatList
    }
    
    func postServerChannelChat(
        channelID: String,
        request: ChatRequestBody
    )
    -> Single<Result<Chat, NetworkError>> {
        let path = ChatRequestDTO(
            workspaceId: UserDefaultsStorage.spaceId,
            id: channelID,
            cursor_date: ""
        )
        let body = ChatRequestBodyDTO(
            content: request.content,
            files: request.files,
            fileNames: request.fileNames
        )
        
        return channelRepository.postChat(
            path: path,
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
    
    func postServerChannelChat(request: ChatRequest, body: ChatRequestBody)
    -> Single<Result<Chat, NetworkError>> {
        let request = request.toDTO()
        let body = body.toDTO()
        
        return channelRepository.postChat(
            path: request,
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
    
}

extension DefaultChatUseCase {
    func fetchDMChatList(roomID: String)
    -> Single<[ChatListContent]> {
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
            .flatMap { (owner, serverChatList) -> Single<[ChatListContent]> in
                owner.dmChatDatabase.insert(
                    chatList: serverChatList.map { $0.toDMChat() }
                )
                return owner.dmChatDatabase.fetch(
                    roomId: roomID
                ).map {
                    $0.map { chat in
                        var isMyChat = false
                        if chat.userId == UserDefaultsStorage.userId {
                            isMyChat = true
                        }
                        return ChatListContent(
                            profileImage: chat.profileImage,
                            nickname: chat.nickname,
                            content: chat.content,
                            createdAt: chat.createAt.toServerDateStr(),
                            files: chat.files.map { $0 },
                            isMyChat: isMyChat
                        )
                    }
                }
            }
            .asSingle()
        
        return dmChatList
    }
    
    func postServerDMChat(
        roomID: String,
        request: ChatRequestBody
    )
    -> Single<Result<Chat, NetworkError>> {
        let path = ChatRequestDTO(
            workspaceId: UserDefaultsStorage.spaceId,
            id: roomID,
            cursor_date: ""
        )
        let body = ChatRequestBodyDTO(
            content: request.content,
            files: request.files,
            fileNames: request.fileNames
        )
        
        return dmRepository.postChat(
            path: path,
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

extension DefaultChatUseCase {
    func observeSocketChat(chatType: ChatType)
    -> Observable<[ChatListContent]> {
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
            .flatMap { (owner, chat) -> Observable<[ChatListContent]> in
                switch chatType {
                case .channel(let channel):
                    owner.channelChatDatabase.insert(chat: chat.toChannelChat())
                    return owner.channelChatDatabase.fetch(channelId: channel.channel_id)
                        .map {
                            $0.map { chat in
                                var isMyChat = false
                                if chat.userId == UserDefaultsStorage.userId {
                                    isMyChat = true
                                }
                                return ChatListContent(
                                    profileImage: chat.profileImage,
                                    nickname: chat.nickname,
                                    content: chat.content,
                                    createdAt: chat.createAt.toServerDateStr(),
                                    files: chat.files.map { $0 },
                                    isMyChat: isMyChat
                                )
                            }
                        }
                        .asObservable()
                case .dm(let dmRoom):
                    owner.dmChatDatabase.insert(chat: chat.toDMChat())
                    return owner.dmChatDatabase.fetch(roomId: dmRoom?.room_id ?? "")
                        .map {
                            $0.map { chat in
                                var isMyChat = false
                                if chat.userId == UserDefaultsStorage.userId {
                                    isMyChat = true
                                }
                                return ChatListContent(
                                    profileImage: chat.profileImage,
                                    nickname: chat.nickname,
                                    content: chat.content,
                                    createdAt: chat.createAt.toServerDateStr(),
                                    files: chat.files.map { $0 },
                                    isMyChat: isMyChat
                                )
                            }
                        }
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
