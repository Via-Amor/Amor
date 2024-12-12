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
    /* Channel */
    func fetchServerChannelChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>>
    func postServerChannelChat(request: ChatRequest, body: ChatRequestBody)
    -> Single<Result<Chat, NetworkError>>
    func insertPersistChannelChat(chatList: [Chat])
    func insertPersistChannelChat(chat: Chat)
    func fetchPersistChannelChat(id: String)
    -> Single<[Chat]>
    func deleteAllPersistChannelChat(id: String)
    
    /* DM */
    func fetchServerDMChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>>
    func postServerDMChat(request: ChatRequest, body: ChatRequestBody)
    -> Single<Result<Chat, NetworkError>>
    func insertPersistDMChat(chatList: [Chat])
    func insertPersistDMChat(chat: Chat)
    func fetchPersistDMChat(id: String)
    -> Single<[Chat]>
    func deleteAllPersistDMChat(id: String)
    
    /* Socket */
    func receiveSocketChat(chatType: ChatType)
    -> Observable<Chat>
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

// Channel
extension DefaultChatUseCase {
    func fetchServerChannelChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>> {
        let request = request.toDTO()
        return channelRepository.fetchChatList(
            request: request
        ).flatMap { result in
            switch result {
            case .success(let value):
                return .just(.success(value.map { $0.toDomain() }))
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
    
    func insertPersistChannelChat(chatList: [Chat]) {
        channelChatDatabase.insert(chatList: chatList.map { $0.toDTO() })
    }
    
    func insertPersistChannelChat(chat: Chat) {
        channelChatDatabase.insert(chat: chat.toDTO())
    }
    
    func fetchPersistChannelChat(id: String)
    -> Single<[Chat]> {
        return channelChatDatabase.fetch(channelId: id).map {
            $0.map { $0.toDomain() }
        }
    }
    
    func deleteAllPersistChannelChat(id: String) {
        channelChatDatabase.deleteAll(channelId: id)
    }
}


// DM
extension DefaultChatUseCase {
    func fetchServerDMChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>> {
        let request = request.toDTO()
        
        return dmRepository.fetchServerDMChatList(request: request)
            .flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.map { $0.toDomain() }))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
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
    
    
    func insertPersistDMChat(chatList: [Chat]) {
        dmChatDatabase.insert(chatList: chatList.map { $0.toDTO() })
    }
    
    func insertPersistDMChat(chat: Chat) {
        dmChatDatabase.insert(chat: chat.toDTO())
    }
    
    func fetchPersistDMChat(id: String)
    -> Single<[Chat]> {
        return dmChatDatabase.fetch(roomId: id).map {
            $0.map { $0.toDomain() }
        }
    }
    
    func deleteAllPersistDMChat(id: String) {
        dmChatDatabase.deleteAll(dmId: id)
    }
}


// Socket
extension DefaultChatUseCase {
    func receiveSocketChat(chatType: ChatType)
    -> Observable<Chat> {
        let router: SocketRouter
        switch chatType {
        case .channel(let channel):
            router = .channel(id: channel.channel_id)
        case .dm(let dmRoom):
            router = .dm(id: dmRoom?.room_id ?? "")
        }
        
        socketIOManager.establishConnection(router: router)
        return socketIOManager.receive(chatType: chatType).map { $0.toDomain() }
    }
    
    func closeSocketConnection() {
        NotificationCenter.default.post(
            name: .disconnect,
            object: nil
        )
    }
}
