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
// 소켓을 통한 실시간 메시지 응답 처리
protocol ChatUseCase {
    /* Channel */
    func fetchChannelChatList(channelID: String)
    -> Single<[Chat]>
    func postServerChannelChat(
        channelID: String,
        request: ChatRequestBody
    )
    -> Single<Result<Chat, NetworkError>>
    
    func deleteAllPersistChannelChat(id: String)
    
    /* DM */
    func fetchDMChatList(roomID: String)
    -> Single<[Chat]>
    func postServerDMChat(
        roomID: String,
        request: ChatRequestBody
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
